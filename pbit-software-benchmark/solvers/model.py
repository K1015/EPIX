"""Exact objectives and binary conditional fields for the four input families."""
import hashlib
import json


def require(condition, message):
    if not condition:
        raise ValueError(message)


def problem_signature(problem):
    """Match the source audit's mathematical identity, independent of folder names."""
    family = problem['source_family']
    if family in ('kings', 'chimera'):
        entries = [(tuple(sorted((u+1, v+1))), w) for u,v,w in problem['edges']]
    elif family == 'sat':
        entries = [(tuple(sorted((v+1)*s for v,s in zip(c['variables'], c['signs']))), 0)
                   for c in problem['constraints']]
    else:
        entries = [(tuple(sorted(v+1 for v in c['variables'])), c['parity'])
                   for c in problem['constraints']]
    payload = json.dumps([family, sorted(entries)], separators=(',', ':')).encode()
    return hashlib.sha256(payload).hexdigest()


class Problem:
    def __init__(self, data):
        self.data = data
        self.n = data['n_variables']
        self.kind = data['problem_type']
        require(type(self.n) is int and self.n > 0, 'n_variables must be a positive integer')
        require(data['node_index_base'] == 0, 'Only zero-based node IDs are supported')
        require(self.kind in ('signed_weighted_maxcut', '3sat', '3xorsat'), 'Unknown problem type')
        self.rows = [[] for _ in range(self.n)]
        self.edges = data.get('edges', [])
        self.constraints = data.get('constraints', [])
        if self.kind == 'signed_weighted_maxcut':
            require(bool(self.edges), 'No edges')
            seen = set()
            for u,v,w in self.edges:
                require(all(type(i) is int and 0 <= i < self.n for i in (u,v)), 'Invalid graph endpoint')
                require(u != v and type(w) is int and w != 0, 'Invalid weighted edge')
                edge = tuple(sorted((u,v)))
                require(edge not in seen, 'Duplicate graph edge')
                seen.add(edge)
                self.rows[u].append((v,w)); self.rows[v].append((u,w))
        else:
            require(bool(self.constraints), 'No constraints')
            for c in self.constraints:
                nodes = c['variables']
                require(len(nodes) == len(set(nodes)) == 3, 'Each constraint needs three distinct variables')
                require(all(type(i) is int and 0 <= i < self.n for i in nodes), 'Invalid factor variable')
                if self.kind == '3sat':
                    signs = c['signs']
                    require(len(signs) == 3 and all(type(s) is int and s in (-1,1) for s in signs), 'Invalid SAT signs')
                    for k,i in enumerate(nodes):
                        other = [j for j in range(3) if j != k]
                        a,b = other
                        self.rows[i].append((nodes[a], nodes[b], int(signs[a]>0), int(signs[b]>0), signs[k]))
                else:
                    require(type(c['parity']) is int and c['parity'] in (0,1), 'Invalid XOR parity')
                    for k,i in enumerate(nodes):
                        other = [nodes[j] for j in range(3) if j != k]
                        self.rows[i].append((*other, c['parity']))

    def check_bits(self, bits):
        require(len(bits) == self.n and all(type(b) is int and b in (0,1) for b in bits),
                'Assignment must contain one binary integer per variable')

    def objective(self, bits):
        self.check_bits(bits)
        if self.kind == 'signed_weighted_maxcut':
            return sum(w for u,v,w in self.edges if bits[u] != bits[v])
        if self.kind == '3sat':
            return sum(not any(bits[v] == (s > 0) for v,s in zip(c['variables'],c['signs']))
                       for c in self.constraints)
        return sum((sum(bits[v] for v in c['variables']) % 2) != c['parity']
                   for c in self.constraints)

    def energy(self, bits):
        value = self.objective(bits)
        return -value if self.kind == 'signed_weighted_maxcut' else value

    def conditional_q(self, bits, site):
        """Q_i = E(x_i=0) - E(x_i=1), without changing the assignment."""
        row = self.rows[site]
        if self.kind == 'signed_weighted_maxcut':
            return sum(w*(1-2*bits[j]) for j,w in row)
        if self.kind == '3sat':
            return sum(s for a,b,va,vb,s in row if bits[a] != va and bits[b] != vb)
        return sum(2*(z ^ bits[a] ^ bits[b])-1 for a,b,z in row)

    @property
    def target_energy(self):
        target = self.data['objective']['target']
        if target is None:
            return None
        return -target if self.kind == 'signed_weighted_maxcut' else target

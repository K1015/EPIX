"""Discover instance folders directly from their problem files."""
from pathlib import Path
import re

from .model import require

PREFIXES = ('kings_maxcut', 'chimera_maxcut', '3hypergraph_sat', '3hypergraph_xorsat')
INSTANCE = re.compile(r'(kings_maxcut|chimera_maxcut|3hypergraph_sat|3hypergraph_xorsat)([1-9][0-9]*)_instance([1-9][0-9]*)')


def instance_path(root, instance_id):
    match = INSTANCE.fullmatch(instance_id)
    require(match is not None, 'Invalid instance ID; use --list to see available names')
    prefix, size, number = match.groups()
    root = Path(root).resolve()
    path = root / (prefix+size) / instance_id / 'problem.json'
    require(path.resolve().is_relative_to(root), 'Instance path leaves the collection')
    require(path.is_file(), 'Unknown instance ID; use --list to see available names')
    return path


def discover_instances(root):
    root = Path(root).resolve()
    rows = []
    for path in root.glob('*/*/problem.json'):
        iid = path.parent.name
        expected = instance_path(root, iid)
        require(expected == path, 'Instance folder does not match its name')
        prefix, size, number = INSTANCE.fullmatch(iid).groups()
        rows.append(dict(instance_id=iid, group=prefix+size, n_variables=int(size),
                         instance_number=int(number), problem_path=path))
    return sorted(rows, key=lambda row: (
        PREFIXES.index(INSTANCE.fullmatch(row['instance_id']).group(1)),
        row['n_variables'], row['instance_number']))

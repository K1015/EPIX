#!/usr/bin/env python3
"""Plot the example waveforms and saved chip energy results."""
import argparse
import json
import os
from pathlib import Path
import sys
import tempfile

os.environ.setdefault(
    'MPLCONFIGDIR', str(Path(tempfile.gettempdir()) / 'epix_example_matplotlib')
)
sys.dont_write_bytecode = True
import matplotlib

matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from estimate import read_vcd

HERE = Path(__file__).resolve().parent
plt.rcParams.update(
    {
        'font.family': 'Arial',
        'font.size': 12,
        'pdf.fonttype': 42,
        'mathtext.fontset': 'dejavuserif',
        'axes.spines.top': False,
        'axes.spines.right': False,
    }
)
COLORS = ['#60718c', '#1f6b99', '#159a87', '#b56328']


def edges(records, signal):
    return [
        (t, before, after)
        for (_, before), (t, after) in zip(records, records[1:])
        if before.get(signal) == 0 and after.get(signal) == 1
    ]


def visits(records):
    found, previous = [], False
    for t, values in records:
        active = (
            values.get('lane_visit') == 1
            and values.get('lane_slot') == 0
            and values.get('search') == 1
        )
        if active and not previous:
            found.append((t, values))
        previous = active
    return found


def digital(ax, records, origin, signals, labels, title, note, span=(-0.4, 0.8)):
    """Draw a short set of digital signals around one event."""
    times = np.array([t for t, _ in records])
    keep = (times >= origin + span[0] * 1e6 - 1e5) & (
        times <= origin + span[1] * 1e6 + 1e5
    )
    selected = [row for row, use in zip(records, keep) if use]
    x = np.array([(t - origin) / 1e6 for t, _ in selected])
    for index, signal in enumerate(signals):
        values = [signal(v) if callable(signal) else v[signal] for _, v in selected]
        y = 1.25 * (len(signals) - index - 1) + 0.68 * np.array(values, dtype=float)
        ax.step(x, y, where='post', lw=1.8, color=COLORS[index])
    ax.set_yticks(
        [1.25 * (len(signals) - i - 1) + 0.34 for i in range(len(signals))],
        labels,
        fontsize=11,
    )
    ax.set_xlim(span)
    ax.set_ylim(-0.25, 1.25 * (len(signals) - 1) + 1.05)
    ax.set_xlabel('Time from marked event (µs)', fontsize=12)
    ax.tick_params(axis='x', labelsize=11)
    ax.grid(axis='x', linestyle='dotted', alpha=0.5)
    ax.axvline(0, color='#999999', lw=0.8, ls=':')
    ax.set_title(title, loc='left', fontsize=14, fontweight='bold', pad=30)
    ax.text(0, 1.02, note, transform=ax.transAxes, fontsize=10, color='#45536a')


def plot_waveform(data, records, out):
    """Show SRAM activity and one p-bit refresh or reuse event."""
    epix = records['epix']
    write_t = next(
        t for t, before, _ in edges(epix, 'sram_clk') if before['sram_we'] == 1
    )
    read_t = next(
        t
        for t, before, _ in edges(epix, 'sram_clk')
        if before['sram_we'] == 0 and before['search'] == 1
    )
    candidates = visits(epix)
    index = next(i for i, (_, v) in enumerate(candidates) if v['lane_refresh'] == 0)
    base_visit = visits(records['baseline'])[index]
    epix_visit = candidates[index]
    fig, axs = plt.subplots(2, 2, figsize=(12, 8.7))
    signals = ['clk', 'sram_ce', 'sram_we', 'sram_clk']
    labels = ['Root clock', 'SRAM enable', 'Write enable', 'SRAM clock']
    digital(
        axs[0, 0],
        epix,
        write_t,
        signals,
        labels,
        'A  Coefficient loading',
        'Write rise: 2.75703 pJ; write fall: 1.138487 pJ',
    )
    digital(
        axs[0, 1],
        epix,
        read_t,
        signals,
        labels,
        'B  Search read',
        'Read rise: 9.93135 pJ; following fall: 0.92870 pJ',
    )
    site_visit = lambda v: int(v['lane_visit'] == 1 and v['lane_slot'] == 0)
    site_refresh = lambda v: int(v['lane_refresh'] == 1 and v['lane_slot'] == 0)
    signals = ['clk', site_visit, site_refresh, 'rng_clock']
    labels = ['Root clock', 'P-bit 0 visit', 'Fresh request', 'P-bit 0 clock']
    for mode, axis, (event_t, value) in [
        ('baseline', axs[1, 0], base_visit),
        ('epix', axs[1, 1], epix_visit),
    ]:
        after = next(v for t, v in records[mode] if t >= event_t + 0.8e6)
        initial, final = value['rng_state'], after['rng_state']
        note = f'Visit {index + 1}; LFSR 0x{initial:08X} → 0x{final:08X}'
        digital(
            axis,
            records[mode],
            event_t,
            signals,
            labels,
            (
                'C  Baseline: fresh random word'
                if mode == 'baseline'
                else 'D  EPIX: reuse holds the LFSR'
            ),
            note,
        )
    w = data['modes']['epix']['waveform_example']['windows']
    fig.suptitle(
        'Chimera128: actual RTL waveform excerpts',
        fontsize=19,
        fontweight='bold',
        y=0.99,
    )
    fig.text(
        0.5,
        0.94,
        '5 MHz · 16-sweep illustration · Liberty SRAM energy at archived mapped clock slews',
        ha='center',
        fontsize=12,
    )
    fig.text(
        0.5,
        0.038,
        f'Whole waveform SRAM integral: setup {w["setup_only"]["sram_internal_energy_nj"]:.6f} nJ + '
        f'search {w["search"]["sram_internal_energy_nj"]:.6f} nJ = {w["with_setup"]["sram_internal_energy_nj"]:.6f} nJ.',
        ha='center',
        fontsize=12,
    )
    fig.text(
        0.5,
        0.009,
        'SRAM control is sampled immediately before each clock edge. SRAM internal energy is one part of chip dynamic energy.',
        ha='center',
        fontsize=10,
        color='#45536a',
    )
    fig.subplots_adjust(
        top=0.835, bottom=0.12, left=0.12, right=0.97, hspace=0.82, wspace=0.44
    )
    fig.savefig(out / 'waveform.png', dpi=170)
    plt.close(fig)


def plot_energy(data, out):
    """Show the saved chip energy by component."""
    native = {
        m: data['modes'][m]['archived_native']['windows']['with_setup']
        for m in ('baseline', 'epix')
    }
    parts = [
        ('standard_cell_internal', 'Cell internal', '#7957a6'),
        ('all_output_switching', 'Output switching', '#238f98'),
        ('root_clock_input_charging', 'Root clock input', '#519b45'),
        ('sram_internal', 'SRAM internal', '#df9b35'),
        ('all_leakage', 'Leakage', '#a8acb5'),
    ]
    fig, ax = plt.subplots(figsize=(8.4, 7.2))
    bottom = np.zeros(2)
    for key, label, color in parts:
        values = np.array([native[m]['components_nj'][key] / 1000 for m in native])
        ax.bar(
            [0, 1],
            values,
            bottom=bottom,
            width=0.5,
            label=label,
            color=color,
            edgecolor='white',
            linewidth=0.35,
        )
        bottom += values
    for i, value in enumerate(bottom):
        ax.text(
            i, value + 2, f'{value:.3f} µJ', ha='center', fontsize=14, fontweight='bold'
        )
    ax.set_xticks([0, 1], ['Baseline', 'EPIX'], fontsize=15)
    ax.set_ylabel('Total energy including setup (µJ)', fontsize=17)
    ax.set_ylim(0, 198)
    ax.set_xlim(-0.65, 1.65)
    ax.tick_params(axis='y', labelsize=13)
    ax.grid(axis='y', linestyle='dotted', alpha=0.5)
    ax.set_axisbelow(True)
    fig.suptitle(
        'Existing full-run SKY130 energy estimate',
        fontsize=18,
        fontweight='bold',
        y=0.98,
    )
    fig.text(
        0.5,
        0.925,
        'Chimera128 · one paired native trial · 1.8 V, 25 °C · pre-route activity',
        ha='center',
        fontsize=11,
    )
    ax.legend(
        loc='upper center',
        bbox_to_anchor=(0.5, 1.2),
        ncol=3,
        fontsize=10,
        frameon=False,
    )
    fig.text(
        0.5,
        0.12,
        f'Total energy saving: {data["native_total_energy_saving_percent"]:.2f}%',
        ha='center',
        fontsize=15,
        fontweight='bold',
    )
    fig.text(
        0.5,
        0.076,
        'Latency: '
        + ' / '.join(f'{native[m]["duration_us"] / 1e6:.7f} s' for m in native)
        + '     Dynamic power: '
        + ' / '.join(f'{native[m]["dynamic_power_uw"]:.3f} µW' for m in native),
        ha='center',
        fontsize=11,
    )
    fig.text(
        0.5,
        0.029,
        'These chip estimates use archived mapped-pin activity; they were not computed from the new short RTL waveforms.',
        ha='center',
        fontsize=9,
        color='#45536a',
    )
    fig.subplots_adjust(top=0.76, bottom=0.23, left=0.15, right=0.96)
    fig.savefig(out / 'energy.png', dpi=170)
    plt.close(fig)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--waveforms', type=Path, default=HERE)
    parser.add_argument('--results', type=Path, default=HERE / 'results.json')
    parser.add_argument('--output', type=Path, default=HERE)
    args = parser.parse_args()
    data = json.loads(args.results.read_text())
    records = {
        m: read_vcd(args.waveforms / (m + '.vcd'))[0] for m in ('baseline', 'epix')
    }
    args.output.mkdir(parents=True, exist_ok=True)
    plot_waveform(data, records, args.output)
    plot_energy(data, args.output)
    print('Wrote waveform.png and energy.png to ' + str(args.output))


if __name__ == '__main__':
    main()

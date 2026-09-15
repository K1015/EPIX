# IID and EPIX ASIC experiments

Run 20 problem instances in two modes: IID and EPIX for Max-Cut, Chimera, SAT and XORSAT at 128, 288, 512, 800 and 32 variables, in that priority order. Both modes use the same problem, target solution, initialization and search settings.

Each `cases/` directory contains its input, target certificate, simulation entry point and `rtl/baseline/` and `rtl/epix/` sources. `asic.json` lists the files to compile. Shared software references are in `software/`; RTL generation sources are in `rtl/` and the family software directories. The bundled library is **SKY130 HD TT, 1.8 V, 25 °C**, with a **200 ns clock period**.

## Current status

The completed checks cover problem inputs, software solutions and RTL/software agreement in simulation. SKY130 area, power, latency and energy estimation are pending.

## Verify software and RTL

Install the dependencies in [tool setup](tools/README.md) before transferring to an offline host. Source and library paths resolve from this package. Set tool locations through `PATH` or the environment variables described in setup.

Check inputs, RNG architecture and test fixtures:

```sh
make check
```

Compare the four 128-variable RTL designs with software using three paired trials per mode:

```sh
python3 run.py --validate-only --cases maxcut128 chimera128 sat128 xorsat128 --work runs/rtl128
```

Omit `--cases` to check all 20 instances. Use `--trials` to select the validation trial count. Each run generates software vectors and compares intermediate states, final outcomes and counters with RTL.

## RNG organization

Max-Cut and Chimera use one RNG engine per 32 variables, with a separate RNG state for each variable. Engines supply fresh words in parallel across banks; an update group commits after all requested words arrive. Max-Cut also has two RNGs for replica exchanges and cluster moves. SAT and XORSAT use one sequential variable-update sampler and one RNG. IID and EPIX use the same organization within each pair.

For the later ASIC estimation stage, follow the [SKY130 procedure](flow/README.md) using the supplied [technology settings](tech/README.md).

Preserve the [source notices and licenses](NOTICES.md) when sharing the package.

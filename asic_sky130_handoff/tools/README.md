# Install the tools

Install Python with NumPy, a native C/C++ compiler, Make, Yosys with Slang and ABC, Verilator, `fst2vcd`, LZ4 and zlib. The flow was tested with Python 3.13.9, NumPy 2.3.3 and Verilator 5.053. Install the Python package from [requirements.txt](../software/requirements.txt). Prepare dependencies before transferring to an offline host. Use package and work directory names containing only letters, digits, dots, underscores, hyphens and directory separators.

A host-compatible [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) supplies Yosys, Slang, Verilator and `fst2vcd`. Put tools on `PATH`; `YOSYS`, `VERILATOR`, `OPENSTA` and `FST2VCD` select specific executables. Set `YOSYS_SLANG_PLUGIN=slang`. For bundles that provide `verilator_bin`, use that native executable and its matching runtime headers.

## OpenSTA

Use [OpenSTA 3.1.0 at commit d97587f](https://github.com/parallaxsw/OpenSTA/tree/d97587f669b4f169be7132346df70e7d634500c3) with [power_activity.patch](power_activity.patch). The patch preserves supplied cell-pin activity through power calculation. The experiment verifies those annotations after each report.

Building OpenSTA requires a C++20 compiler, CMake, Git, Flex, Bison, SWIG, Tcl development files, zlib and Eigen 3.4.0. Tested versions include Bison 3.8.2, SWIG 4.3.0 and Tcl 8.6.15. Fetch the sources while connected and run from the package root:

```sh
mkdir -p .tool_sources .tool_build .toolchain
task_tool_prefix="$(pwd)/.toolchain"
git clone https://github.com/cuddorg/cudd.git .tool_sources/cudd
git -C .tool_sources/cudd checkout f54f533303640afd5dbe47a05ebeabb3066f2a25
cd .tool_sources/cudd
./configure --prefix="$task_tool_prefix" --enable-static --disable-shared
make -j2
make install
cd ../..
git clone https://github.com/parallaxsw/OpenSTA.git .tool_sources/OpenSTA
git -C .tool_sources/OpenSTA checkout d97587f669b4f169be7132346df70e7d634500c3
git -C .tool_sources/OpenSTA apply ../../tools/power_activity.patch
cmake -S .tool_sources/OpenSTA -B .tool_build/opensta -DCMAKE_BUILD_TYPE=Release -DCUDD_DIR="$task_tool_prefix" -DUSE_TCL_READLINE=OFF
cmake --build .tool_build/opensta --target sta --parallel 2
export OPENSTA="$(pwd)/.tool_build/opensta/sta"
python3 tools/verify_opensta.py --sta "$OPENSTA"
python3 tools/test_readback.py --sta "$OPENSTA"
```

Confirm both verification commands pass. They check the supplied SKY130 circuit, activity units, annotation retention and report completion. Keep `OPENSTA` set to this executable for the suite. For dependencies installed under a custom prefix, add that prefix through `CMAKE_PREFIX_PATH` when configuring.

## FST compression

Use native LZ4 1.10.0 for FST linking. Build the pinned source and point `LZ4_LIBRARY` to its static archive:

```sh
git clone https://github.com/lz4/lz4.git .tool_sources/lz4
git -C .tool_sources/lz4 checkout ebb370ca83af193212df4dcbadcc5d87bc0de2f0
make -C .tool_sources/lz4/lib liblz4.a -j2
export LZ4_LIBRARY="$(pwd)/.tool_sources/lz4/lib/liblz4.a"
```

Keep the [OpenSTA license](LICENSE.OpenSTA) and [LZ4 license](LICENSE.LZ4) with the sources. Continue with the [run guide](../flow/README.md).

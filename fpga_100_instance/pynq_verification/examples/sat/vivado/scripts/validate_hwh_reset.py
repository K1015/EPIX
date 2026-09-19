#!/usr/bin/env python3
"""Reject asserted static resets or disconnected reset/clock nets in the HWH."""
import argparse
import hashlib
import json
from pathlib import Path
import xml.etree.ElementTree as ET


def validate(path):
    raw = Path(path).read_bytes()
    root = ET.fromstring(raw)
    modules = {m.get("INSTANCE"): m for m in root.findall(".//MODULE")}
    checks = []

    def require(condition, message):
        if not condition:
            raise ValueError(message)
        checks.append(message)

    def module(name):
        require(name in modules, "module exists: " + name)
        return modules[name]

    def params(name):
        return {
            p.get("NAME"): p.get("VALUE")
            for p in module(name).findall("./PARAMETERS/PARAMETER")
        }

    def port(name, signal):
        p = module(name).find("./PORTS/PORT[@NAME='{}']".format(signal))
        require(p is not None, "port exists: {}/{}".format(name, signal))
        return p

    def wired(name, signal, source, source_port, polarity=None):
        p = port(name, signal)
        targets = {
            (c.get("INSTANCE"), c.get("PORT"))
            for c in p.findall("./CONNECTIONS/CONNECTION")
        }
        require(
            (source, source_port) in targets,
            "connection: {}/{} <- {}/{}".format(name, signal, source, source_port),
        )
        if polarity:
            require(
                p.get("POLARITY") == polarity,
                "polarity: {}/{} = {}".format(name, signal, polarity),
            )

    reset = "rst_ps7_0_100M"
    rp = params(reset)
    require(rp["C_EXT_RESET_HIGH"] == "0", "external reset parameter is active low")
    require(rp["C_AUX_RESET_HIGH"] == "1", "auxiliary reset parameter is active high")
    require(int(params("const_zero")["CONST_VAL"], 0) == 0, "const_zero value is zero")
    require(int(params("const_one")["CONST_VAL"], 0) == 1, "const_one value is one")
    wired(reset, "ext_reset_in", "ps7_0", "FCLK_RESET0_N", "ACTIVE_LOW")
    wired(reset, "aux_reset_in", "const_zero", "dout", "ACTIVE_HIGH")
    wired(reset, "mb_debug_sys_rst", "const_zero", "dout", "ACTIVE_HIGH")
    wired(reset, "dcm_locked", "const_one", "dout")
    wired("axi_interconnect_0", "ARESETN", reset, "interconnect_aresetn")
    for p in ("S00_ARESETN", "M00_ARESETN"):
        wired("axi_interconnect_0", p, reset, "peripheral_aresetn")
    wired("maxcut26_0", "s_axi_aresetn", reset, "peripheral_aresetn", "ACTIVE_LOW")

    # Check every clock on the bus, including the reset synchronizer itself.
    for name, signal in (
        (reset, "slowest_sync_clk"),
        ("maxcut26_0", "s_axi_aclk"),
        ("ps7_0", "M_AXI_GP0_ACLK"),
        ("axi_interconnect_0", "ACLK"),
        ("axi_interconnect_0", "S00_ACLK"),
        ("axi_interconnect_0", "M00_ACLK"),
    ):
        wired(name, signal, "ps7_0", "FCLK_CLK0")
    fclk = port("ps7_0", "FCLK_CLK0")
    require(
        fclk.get("CLKFREQUENCY") == "100000000", "FCLK0 metadata frequency is 100 MHz"
    )
    require(
        port("ps7_0", "FCLK_RESET0_N").get("POLARITY") == "ACTIVE_LOW",
        "PS7 reset output is active low",
    )
    return {
        "schema": "maxcut26_hwh_reset_validation_v1",
        "status": "PASS",
        "hwh_sha256": hashlib.sha256(raw).hexdigest(),
        "checks": checks,
        "scope": "Generated HWH reset and clock integration; physical behavior requires board validation.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--hwh", required=True, type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = validate(args.hwh)
    if args.output:
        args.output.write_text(json.dumps(result, indent=2) + "\n")
    print("PASS: {} reset/clock integration assertions".format(len(result["checks"])))


if __name__ == "__main__":
    main()

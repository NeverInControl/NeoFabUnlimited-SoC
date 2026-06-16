# Third-Party Hardware IP

This directory contains vendored (copied) open-source hardware components used in this System-on-Chip architecture. 

To guarantee build stability and synthesizeability without relying on external package managers or dynamic submodules, these IP cores have been snapshotted and baked directly into this repository.

> **Legal & Licensing Note:** > All third-party IP cores retain their original copyright and licensing. The respective `LICENSE` files have been preserved inside each subdirectory. If you fork this repository, you must respect the original authors' licenses.

---

## 1. NEORV32 (RISC-V CPU)
* **Author:** Stephan Nolting
* **Repository:** [https://github.com/stnolting/neorv32](https://github.com/stnolting/neorv32)
* **License:** BSD 3-Clause License

**Description:**
The NEORV32 is a customizable, highly-extensible 32-bit RISC-V soft-core processor. In this architecture, it serves as the primary host CPU, running the Zephyr RTOS and managing the hardware accelerator daemon.

---

## 2. Wishbone Interconnect (`wb_intercon`)
* **Author:** Olof Kindgren
* **Repository:** [https://github.com/olofk/wb_intercon](https://github.com/olofk/wb_intercon)
* **License:** ISC License

**Description:**
A collection of Wishbone bus interconnect components (arbiters, multiplexers, and address decoders). In this architecture, it is used to safely route memory-mapped transactions between the NEORV32 host, the target memory, and the dynamically reconfigurable FABulous eFPGA accelerators.
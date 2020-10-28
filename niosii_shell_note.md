## Board Support Package Creation

Tool: nios2-bsp.

Usage: `nios2-bsp <bsp-type> <bsp-dir> <sopc-path> [<override>]`.

- `<bsp-type>`: usually `hal`, another option is `ucosii` when MicroC OS is used.
- `<bsp-dir>`: path to the BSP directory.
- `<sopc-path>`: path to the Nios system's .sopcinfo file.
- `<override>`: optional, override default settings (see handbook page 72 for more details).

## Application Project Creation

Tool: nios2-app-generate-makefile.

Usage: `nios2-app-generate-makefile --bsp-dir <bsp-dir> --elf-name <exec-elf-name> --src-dir <c-src-dir>`.

The meaning of options should be clear from their names (all specifying directories).

For other options, see handbook page 396 for more details.

`nios2-app-update-makefile --app-dir <app-dir>` can be used to update generated Makefile after source file is added/removed, etc. It is also fine to regenerate a Makefile from scratch.

## Make Targets

help: display all available targets.
all (default): builds associated BSP and then builds application.
app: builds only application.
clean: clean project files.
download-elf: build application and then downloads and runs it (using USB-Blaster and JTAG).
program-flash: program the application executable to flash memory.

## Other tools

nios2-terminal: open a terminal for JTAG UART module's input/output.


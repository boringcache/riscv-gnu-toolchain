#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$RUNNER_TEMP/validation"
git rev-parse HEAD > "$RUNNER_TEMP/validation/source.txt"
git submodule status > "$RUNNER_TEMP/validation/submodules.txt"
ccache -z
/usr/bin/time -v -o "$RUNNER_TEMP/validation/build-time.txt"   make -j "$(nproc)" FLANG_PARALLEL_COMPILE_JOBS="$(( ($(nproc) + 1) / 2 ))"   -o stamps/build-gcc-linux-stage2 stamps/build-llvm-linux
ccache --print-stats > "$RUNNER_TEMP/validation/ccache.txt"
/mnt/riscv/bin/clang --version > "$RUNNER_TEMP/validation/clang.txt"
printf 'int main(void) { return 0; }\n' > "$RUNNER_TEMP/validation/hello.c"
/mnt/riscv/bin/riscv64-unknown-linux-gnu-clang "$RUNNER_TEMP/validation/hello.c" -o "$RUNNER_TEMP/validation/hello"
readelf -h "$RUNNER_TEMP/validation/hello" > "$RUNNER_TEMP/validation/elf.txt"
grep -q 'RISC-V' "$RUNNER_TEMP/validation/elf.txt"

# RISC-V cache validation

Qualified for validation of remote compiler reuse and reduced eviction pressure from a small local ccache. [Cold and warm run](https://github.com/boringcache/riscv-gnu-toolchain/actions/runs/34321006638).

One v1.21.0 is pinned to `90111526eb218a7f1e119ac2b29f765bd4d82734` and uses GitHub OIDC with its native ccache adapter. The baseline archives the local ccache with GitHub Actions cache.

Both providers use PR 1900 source `fb407fa3bb9723ccdf2361f6e36e8410d33e5a7d`, ccache 4.14, the HTTP helper 0.9, Ubuntu 24.04 and a 2 GB local cache limit. The retained GNU toolchain artifact comes from the same source revision. Both build and install LLVM, then compile and inspect a RISC-V executable.

Status: both corrected cold builds are running. The original attempt with an unsupported ccache version is excluded. Warm jobs use fresh runners and restore-only policies.

Compare build time, cache completion, compiler hits/misses and local eviction statistics. The measured workload excludes rebuilding GNU, packaging and the full platform/test matrix. A later source revision and physical storage savings are not yet measured.

# RISC-V cache validation

Qualified for shared native compiler caching. All four cold/warm builds passed, with identical compiler hit counts and zero reported cache or backend errors. BoringCache's warm build was slower in this sample; the test did not establish the cause. [Run and artifacts](https://github.com/boringcache/riscv-gnu-toolchain/actions/runs/34321006638) · [Measurements](boringcache-validation.json).

One v1.21.0 is pinned to `90111526eb218a7f1e119ac2b29f765bd4d82734` and uses GitHub OIDC with its native ccache adapter in remote-only mode. The baseline archives a local ccache, limited to 2 GB, with GitHub Actions cache. Warm jobs use fresh runners and restore-only policies.

Both providers use PR 1900 source `fb407fa3bb9723ccdf2361f6e36e8410d33e5a7d`, LLVM `ca7933e47d3a3451d81e72ac174dcb5aa28b59d1`, ccache 4.14, HTTP helper 0.9 and Ubuntu 24.04. Source, submodules and the retained GNU artifact hash match across all four jobs. Each job builds and installs LLVM, Clang, Flang, MLIR and runtimes, then compiles and inspects a RISC-V ELF executable with Clang 22.1.8.

| Measurement | GitHub | BoringCache |
|---|---:|---:|
| Cold build | 2h 39m 09s | 2h 39m 23s |
| Warm build | 53m 47.61s | 1h 16m 11s |
| Cold whole job | 2h 45m 22s | 2h 43m 33s |
| Warm whole job | 58m 52s | 1h 20m 52s |
| Cold compiler hits / misses | 1 / 5,051 | 1 / 5,051 |
| Warm compiler hits / misses | 5,051 / 1 | 5,051 / 1 |
| Cache cleanup operations | 0 | 0 |

Both warm jobs hit 99.98% of cacheable compilations. Each job also reports 343 precompiled-header calls that could not use ccache; linking and other uncached work remain. Cold build times were effectively equal. Differences in cold whole-job time mainly came from setup, so they do not demonstrate a cache speed advantage.

GitHub saved a 256.84 MB archive in a 5 s save step and restored it in 5 s. BoringCache wrote 256.37 MB of native cache payload during the cold build and read 256.37 MB warm, with no warm uploads. Its proxy shut down in 2 s cold and 1 s warm; these are finalization times, not the total time spent uploading during compilation.

The local GitHub cache occupied about 263 MiB, well below the 2 GB cap, and neither provider reported evictions. BoringCache retained only 36 KiB of local ccache metadata because compiler objects were remote. This proves remote reuse; it does not measure physical deduplication savings or reduced thrashing under storage pressure. Those remain relevant follow-up cases for the prospect.

This is one sample per provider and phase. The RISC-V executable was inspected, not run. GNU rebuilding, packaging, the full compiler test suite, other platform configurations, a later source revision and CI-to-local reuse were not measured.

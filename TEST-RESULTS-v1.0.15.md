# GET IT! v1.0.15 validation — 2026-10-23

| Check | Result |
|---|---|
| `npm run check` (Node syntax) | PASS |
| `npm test` (Linux container) | PASS — 83 tests, 0 failed, 0 skipped |
| Publisher checksum and missing-manifest rejection | PASS (fixture tests) |
| Optional release asset filename selection | PASS (fixture tests) |
| Complete portable runtime root discovery | PASS (fixture tests) |
| Installed executable discovery, `--version` | PASS (Linux fixture; not a Windows PE binary) |
| Existing real local HTTP media and FFmpeg test suite | PASS |
| React/Vite native build | NOT VERIFIED (npm packages unavailable locally) |
| Download official Windows aria2/gallery-dl/Streamlink executables | NOT VERIFIED (no external network access in test container) |
| Launch packaged Windows x64 installer | NOT VERIFIED (Windows host required) |
| macOS optional-binary auto-provisioning | NOT IMPLEMENTED |

All original 78 tests remain included. New tests cover checksum, asset selection, portable layout, and executable discovery. `provision-optional.mjs` requires real publisher SHA-256 metadata and version probing during the eventual Windows build; if either fails, the build deliberately stops.

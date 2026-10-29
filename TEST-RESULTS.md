# GET IT! v1.0.4 — Windows build regression fixes (2026-10-22)

Reported on Windows 10/11 x64 using Node v24.21.0/npm 11.19.0, earlier v1.0.2 build:
- `ERR_STREAM_DESTROYED` while pausing/resuming a direct HTTP transfer.
- Local FFmpeg MP3 integration job did not reach the expected state in the prior 12-second test timeout.

Corrective changes:
- Replaced manual HTTP response write-loop / immediate stream destruction with Node's `stream/promises.pipeline` using an AbortSignal, preserving partial bytes for range resumes. Pipeline manages pending stream write errors and stream cleanup on abort.
- Added a rapid pause/resume real HTTP integration regression test.
- Extended the FFmpeg integration wait to 90 seconds for slower Windows hardware, plus an immediate descriptive failure when the job itself fails. This does not alter actual converter speed.
- Approved known Electron, esbuild, and electron-winstaller install scripts via package.json `allowScripts` for recent npm releases.

Retested in this execution environment: Linux x64, Node.js v22.16.0, system FFmpeg/FFprobe.
- `npm run check`: PASS
- `npm test`: **25 passed / 0 failed**
- Repeated download-manager suite: **11 passed / 0 failed on each of 3 runs**

Not verified: installer build on Windows with Node v24.21.0 and npm v11.19.0; a running Electron GUI; live yt-dlp transfers; Windows SmartScreen and signature; macOS distribution. Building v1.0.4 still requires an internet-connected Windows build computer.

---

# GET IT! v1.0.3 playback compatibility verification — 2026-10-22

**PASS — 24/24 Node.js backend tests** (`npm test`) and backend syntax (`npm run check`). `src/App.jsx` parsed successfully with TypeScript JSX parser.

### What was actually tested

- Generated authorized local video samples with FFmpeg: H.264/AAC and legacy MPEG-4 Part 2/AAC.
- A compatible H.264/AAC MP4 was validated without altering the bytes.
- Legacy MPEG-4 video inside `.mp4` was detected, transcoded to H.264/AAC yuv420p, and inspected again with FFprobe.
- An actual local HTTP transfer containing legacy video was automatically repaired before the job became Completed.
- Deliberately invalid `.mp4` input was rejected by FFprobe and never marked Completed.
- Real **Repair playback** queued job produced a second compatible MP4 while preserving the original bytes.
- yt-dlp format selector unit tests verify AVC/AAC preference, height maximum rather than equality, and elimination of `bestvideo*`.
- Previously implemented download queue, pause/resume, cancellation, FFmpeg audio conversion, retry, history and progress tests still pass.

### Not verified

- A live third-party video source downloaded using a real yt-dlp executable.
- The React UI rendered in a running Electron desktop window.
- Windows and macOS packaged installers, SmartScreen behavior, Windows player behavior, code signing/notarization.
- Every possible video codec and corrupted video edge case.

**This archive is source code plus build scripts, not an `.exe` or `.dmg`.** The user must build the native installer on the matching operating system.

---

# GET IT! v1.0.2 progress-fix verification — 2026-10-22

**Result: PASS — 16/16 native Node.js tests; backend syntax check PASS; `App.jsx` syntax parsed successfully with the TypeScript JSX parser.**

New progress-specific checks:
- Real streamed HTTP video emitted intermediate progress, measured bytes/second and calculated ETA; it reached 100% only after the output was saved.
- yt-dlp progress parsing handles numeric and `NA` fields, estimated byte totals, source-provided transfer speed and ETA.
- Distinct video/audio streams get separate progress stage labels instead of misrepresenting stage percentage as a total-job percentage.
- Playlist progress is explicitly identified as current-transfer progress.
- Completed HTTP and FFmpeg jobs record actual output file sizes.

**Not verified:** live provider website retrieval with an actual yt-dlp executable, React/Vite/Electron GUI execution, Windows `.exe` installer, macOS `.dmg` installer, signing/notarization. Those require the appropriate dependencies and native build host.

---

# GET IT! functional test status — 2026-10-21

## Environment
- Linux container, Node.js 22.16.0
- System FFmpeg/FFprobe available
- npm registry unreachable from this container (`EAI_AGAIN` DNS failure)
- Electron, Vite, React, electron-builder and yt-dlp executables not installed in container

## Executed, verified
- `npm run check`: PASSED (native Electron backend syntax files)
- `npm test`: PASSED (9 of 9 Node tests)
  1. URL validation, reject `file:`/`javascript:` schemes and embedded credentials
  2. Real direct-video HTTP download and cryptographic byte-for-byte verification, persisted history, duplicate detection
  3. Actual HTTP byte-range resume after pause and file equality
  4. Real MP3 extraction with FFmpeg and probe of result
  5. Active download cancellation
  6. Two simultaneous downloads with same output title do not overwrite each other
  7. Interrupted job recovered across fresh Manager/Store initialization
  8. Cancelled FFmpeg operation cannot begin a fresh conversion
  9. Audio-only sources do not advertise video output formats

## Not verified / not delivered
- GUI build and actual Electron window launch (npm packages cannot be installed in this environment)
- End-to-end metadata lookup from real yt-dlp provider and playlist download
- Windows 10/11 installed/packaged `.exe` tested on native Windows hardware
- macOS Intel / Apple Silicon `.app` and `.dmg` built/tested on native Mac hardware
- Apple signing/notarization and Windows publisher signing
- OS startup auto-launch and notifications in real installed apps

This report deliberately distinguishes executable backend tests from installer and Electron UI verification.

## Build-fix follow-up — 2026-10-22 (source v1.0.1)

- Confirmed static build issue in v1.0.0: native provisioning spawned `npm.cmd` directly on Windows using `spawnSync`, which can fail with `EINVAL` on supported Node releases. Replaced by invoking npm CLI JS using `process.execPath` and a validated, installed npm CLI path. A dedicated unit test verifies the launch arguments without a shell.
- Retested after patch: **10 of 10** native Node tests passed on Linux and all backend/script syntax checks passed.
- The installer build remains **UNVERIFIED** here: npm packages were not cached (`ENOTCACHED`) and the runtime could not perform a successful dependency installation. Actual user build errors may have different causes; `BUILD-WINDOWS.bat` now writes `GET-IT-BUILD-LOG.txt` for diagnosis.

## v1.0.5 — New Download → Download now handoff

Verified on 2026-10-22 in the provided Linux Node 22 environment:

- `npm run check`: PASS (Electron backend, preload and packaging script syntax).
- `npm test`: PASS (31/31 tests, including six new tests for post-download routing and out-of-order job IPC).
- Actual HTTP video transfers, byte-range resume, FFmpeg conversion, cancellation, output verification, and history persistence were exercised in native backend tests.
- Fixed client-side routing for duplicate running/completed files and fast-finished jobs; added persistent IPC-error banner and React error boundary with log diagnostics.

**Limits:** The Electron GUI was not launched, React JSX could not be compiled here without missing npm packages, and Windows/macOS installers were not built or smoke-tested in this container. Windows installed-app testing is needed to confirm the user's reported click behavior is fully resolved.

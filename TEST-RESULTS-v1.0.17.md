# GET IT! v1.0.17 — Test results

## Previously reported failure
On Windows, v1.0.16 stopped during `BUILD-WINDOWS.bat` Step 4 because 3 of 84 tests failed (aria2 and Streamlink status timeouts, plus yt-dlp unreported output recovery), with 80 passed and 1 skipped.

## Repairs made
- Serialize test-file execution to reduce simultaneous FFmpeg processes and Windows disk contention.
- Keep mock download tests realistic but deterministic by copying previously generated, valid H.264/AAC MP4 and MPEG-TS fixtures instead of invoking FFmpeg encoders inside mock executables.
- Improve yt-dlp output recovery for job-token-stamped filenames on filesystems with skewed modification times; still require unique candidate and real media validation.
- Avoid six subprocess version probes in the missing-path mock test; this does not affect runtime engine availability detection.
- Close test HTTP connections explicitly during shutdown to avoid process hangs.
- Extend slow-machine integration test timeout and include job phase/error in timeout messages.

## Executed in Linux container
- `node --check electron/manager.cjs`: passed.
- `node --check tests/fixtures/multi-cli.cjs`: passed.
- `node --check tests/unreported-path.test.cjs`: passed.
- `node --test --test-concurrency=1 tests/multi-engine.test.cjs tests/unreported-path.test.cjs`: 11/11 passed, 0 skipped.
- `node --test --test-concurrency=1 tests/*.test.cjs tests/*.test.mjs`: 84/84 passed, 0 failed, 0 skipped, 33.8 seconds.
- `npm run check`: passed.

## Not verified
The new Windows build, downloaded official aria2/gallery-dl/Streamlink binaries, live network downloads, and installer itself have not been verified on the user's Windows machine. Build-time provisioning still requires internet connectivity and published SHA-256 verification.

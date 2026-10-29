# GET IT! v1.0.17 — Windows build functional-test repair

This release repairs the v1.0.16 build failure reported on Windows: 3 of 84 functional tests failed when media tests ran concurrently.

## Changes
- Run Node functional-test files sequentially (`--test-concurrency=1`) to prevent the Windows PC from running multiple FFmpeg- and FFprobe-intensive test files at the same time. All tests still run, with no skipped assertions introduced.
- Replace FFmpeg-invoking **test mock engines** with small prerecorded, real video and transport-stream fixture files. The download manager continues to verify actual playable media via FFprobe; the fake CLI creates real files without requiring an additional FFmpeg encoder under peak load. This does not alter production download engines.
- The yt-dlp mock's sample media is similarly prerecorded. Its test no longer probes unrelated tool executables, making the missing-after_move-path test deterministic.
- Permit recovery of the **current job's UUID-stamped media filename** irrespective of file modification timestamp, which may be skewed on external drives or Windows. Single-file and actual media/playback verification requirements are retained; unrelated output files and nonexistent paths are still rejected.
- Make HTTP test servers close existing test connections before cleanup to avoid keep-alive hangs.
- Expand timeout diagnostics for aria2/Streamlink integration tests and allow up to 60 seconds on slower Windows machines.

## Build
Extract the ZIP to a new directory and run `BUILD-WINDOWS.bat`. The build log is `GET-IT-BUILD-LOG.txt`. It will still fail on any genuine functional-test, engine-provisioning, or installer failure.

## Verification
See `TEST-RESULTS-v1.0.17.md` for local test outcome. Official Windows engine downloads and Windows installer are not tested by this Linux environment.

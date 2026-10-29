# GET IT! v1.0.11 — Test results

Executed in Linux container with Node.js v22.16.0 and FFmpeg/FFprobe installed.

- `npm run check`: **PASS** (backend and progress-view syntax).
- `npm test`: **61/61 PASS**, 0 failures, 0 skipped (run twice).
- Included integration tests: real local HTTP video transfer, pause/resume, FFmpeg conversion, media verification, output-path recovery and stage-progress measurements.
- New regressions: completed unverified record cannot claim 100%; retry, failed, interrupted and cancelled records do not reuse stale download percentages; pausing retains actual last measured percentage; unknown processing is indeterminate.

**Not tested:** Compiled React renderer in Electron (npm frontend dependencies not installed here), native Windows installer, native Mac DMG, live social-platform site transfers. This is a source release, not a signed or tested installer.

# GET IT! 1.0.6 — Progress audit and tests

Run environment: Linux container, Node.js v22.16.0, local FFmpeg/FFprobe, loopback HTTP server with authorized generated media. No internet media used.

Command: `npm run check && npm test`

- Backend syntax: passed.
- All 38 automated tests: PASSED, 0 failed, 0 skipped.
- Real HTTP file download: observed 0%, genuine intermediate percentages, 99% when bytes received, separate verification, 100% only when verified completion was emitted.
- Pause/resume real transfer: passed.
- Local FFmpeg video→MP3: progress capped at 99% until output verification; verified completion emits 100%.
- HTTP download followed by FFmpeg conversion: measured download stage, separate conversion stage, separate verification, 100% only on completed output.
- Playlist/yt-dlp stream labels: unit-tested for per-stream scope and not misreported as overall progress.
- Missing totals: tests confirm unknown percentages remain unknown/indeterminate.
- Invalid media: test confirms failed status instead of false completion.

Limitations: Native React/Electron GUI execution and Windows NSIS installer not tested in this container (Electron, React and Vite build dependencies unavailable). No live public-site yt-dlp stream download was performed; yt-dlp parsing and stage labels were tested using recorded progress strings. Windows release remains to be verified on a Windows machine.

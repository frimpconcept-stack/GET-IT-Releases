# GET IT! v1.0.11 — Progress state consistency update

- Real HTTP transfer bar continues to use measured downloaded bytes (not simulated percentages).
- yt-dlp progress remains explicitly *per stream*, never fabricated across multiple tracks or playlists.
- FFmpeg conversion, merger and playback verification remain separate stages; unknown progress stays indeterminate.
- Only a completed job with a recorded successful media verification shows **100%**.
- Retrying, failed, cancelled and interrupted jobs no longer show a stale live-download percentage.
- Paused transfers retain their previous measured percentage with an explicit Paused label.
- Preparing, merging, verification and retry stages show an animated indeterminate indicator, not an invented number.
- One pause/resume integration test now waits for real bytes to have reached disk before asserting that its partial file is non-empty.

Run `npm run check && npm test` from the project root. Then build on Windows or macOS using the existing scripts. Signed/notarized native installers are not included in the source ZIP; platform-specific verification remains necessary.

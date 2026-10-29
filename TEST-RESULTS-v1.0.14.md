# GET IT! v1.0.14 — verification report

## Completed locally
- `npm run check`: PASS (Electron/backend scripts and supporting modules).
- `node --test tests/*.test.cjs tests/*.test.mjs`: **78 passed, 0 failed, 0 skipped**.
- TypeScript's JSX parser: `src/App.jsx`, `src/main.jsx`, `src/RendererErrorBoundary.jsx` each **0 syntax diagnostics**.
- New regression suite: seven tests cover aria2 progress parsing; executable path validation; gallery/Streamlink metadata subprocesses; real saved gallery files and persistence; aria2 subprocess creating an FFprobe-verified playable MP4 without premature 100%; Streamlink subprocess generating an FFprobe-verified MPEG-TS; rejection of incorrect engine/link/format combinations and music catalogs.
- Previous 71 tests still pass, including yt-dlp flow, local HTTP downloads, FFmpeg, history and download progress.

## Not verified
- Official aria2c, gallery-dl, and Streamlink executable behavior against external websites (not installed in this environment).
- Real end-user permission/access and DRM scenarios for the new providers.
- Installed Windows .exe and macOS .dmg packages. No native installers were built here.
- React/Vite full production compile: **blocked** because offline npm cache lacks `@tailwindcss/vite`. JSX syntax parsing did pass; that is not a substitute for an Electron GUI smoke test.
- Live Streamlink Stop & save against an actual ongoing stream on Windows/macOS; a local finite stream fixture was verified.

## Known limitations
- aria2 can accelerate only servers supporting split/range requests. Not guaranteed faster than existing Node downloader.
- Gallery file verification is limited to existence and nonzero size, not format decoding for every image type.
- A live recording has unknown overall completion until the user stops it; the UI does not fabricate a percentage.
- Additional engine executables must be supplied or staged at build time, and their licenses followed; v1.0.14 does not automatically provision them.

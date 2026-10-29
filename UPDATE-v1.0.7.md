# GET IT! v1.0.7 — Social video and public audio support

## What changed

- **Generic yt-dlp extraction stays enabled**, so GET IT! does not restrict URLs to an arbitrary list of brands. The extractor determines actual source support at analysis time. Hostnames are only used for an informative label in the GUI.
- Analyzes audio-only track links correctly. If the source exposes audio but no video, the output selector offers MP3/M4A/WAV (with FFmpeg) and does **not** display fictional video qualities.
- Adds an online audio bitrate selector (96–320 kbps). This sets FFmpeg's encoding bitrate; it cannot improve the source recording's fidelity.
- Supports available video/audio selection for media pages, with MP4, MKV, WebM and audio formats, plus opt-in playlists where yt-dlp supports them. Quality choices originate from actual reported formats.
- Corrects WebM merge-output request (no longer requests MKV while displaying WebM).
- Produces more useful errors for unsupported URLs, account-only sources, network timeouts, geographical restrictions, rate limiting and DRM.
- Uses the Electron-bundled Node runtime for yt-dlp JavaScript extractors. This is intended to avoid requiring an additional Node installation on the consumer PC, but **must be verified on packaged Windows/macOS builds**. Up-to-date official yt-dlp builds include their required JS extraction components; support still depends on provider behavior.
- Provisioning on the **build PC** retries network failures up to three times and can reuse a previously SHA-256-verified yt-dlp binary. No disable-security or bypass options were added.

## Important limitations

**No downloader supports every service or every item.** Site support changes, and some social posts, music-streaming libraries and subscription-only content use DRM, login, paywalls, restricted content, or rate limiting. For example, Spotify / Apple Music streaming tracks must not be described as universally downloadable. GET IT! only downloads media that providers make available via supported, permitted access paths.

**Privacy:** GET IT! does not extract browser cookies or authenticated sessions automatically. Use only media you own or are authorized to download. No DRM, authentication or paywall bypass is implemented.

## Verified in this environment

- Backend tests, simulated extractor CLI integration, and local HTTP/FFmpeg tests pass.
- The simulated extractor tests exercise realistic social/video and audio download paths but **do not confirm that live Instagram, TikTok, YouTube, SoundCloud etc. downloads currently work.** Live platforms require permitted test links and network access.
- Node syntax checks and JSX parsing pass. The React production build and Electron installer could not be compiled in this environment because fetching npm dependencies stalled.
- Windows and macOS installation, notarization and app runtime are not verified for this version. Rebuild and test the application on the target operating system.

## macOS Intel instructions

On your Mac, unzip the new source ZIP into a new folder (don't overwrite `~/Desktop/GET-IT` while the previous build is running). Then:

```bash
cd ~/Desktop/GET-IT-v1.0.7/GET-IT
set -o pipefail
caffeinate -i bash BUILD-MAC.command 2>&1 | tee GET-IT-MAC-BUILD-LOG.txt
ls -lh release/*.dmg
```

If the project was extracted into a differently named folder, use that actual path. The installer will be named similarly to `release/GET-IT-x64.dmg`.

## Windows instructions

Unzip the source into a new folder, run `BUILD-WINDOWS.bat`, review `GET-IT-BUILD-LOG.txt`, and install the new `release/GET-IT-Setup.exe` only if the build succeeds. Source packages are not installers.

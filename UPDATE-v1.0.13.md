# GET IT! v1.0.13 — Universal Music Catalog Preview

This update builds on v1.0.12 and **does not change the proven download progress calculation or FFmpeg pipeline**.

## New working behaviors

- Spotify: recognizes standard official track/album/playlist/artist/episode/show URLs and retrieves title/cover artwork via the documented official Spotify oEmbed API, where available.
- Apple Music: recognizes official song/album/artist/playlist links and uses the public Apple iTunes catalog ID lookup for matching tracks/albums when available; otherwise it clearly marks metadata unavailable.
- Deezer, TIDAL and Amazon Music: identify recognized official catalog URLs and offer safe official page navigation (no claim of downloadable streams or online metadata for these services).
- Catalog preview is an independent UI type. It shows the service, available official metadata, a restriction notice, and an actionable **Open in [service]** button. It NEVER shows Download Now for a protected/catalog-only link.
- Electron IPC validates external catalog URLs against an allowlist of **official HTTPS domains and supported URL patterns**, rejecting lookalike sites, credentials, unexpected ports, unsupported paths and file URLs.
- The Node download manager independently rejects attempts to queue Spotify/Apple Music/catalog URLs, even if the renderer were bypassed.
- Metadata requests are confined to documented Spotify oEmbed or iTunes catalog endpoints; network timeouts and unavailable metadata degrade to a truthful official-link preview.

## Not included

- **Not** Spotify/Apple Music full audio extraction, DRM bypass, stream-ripping, login-cookie access, playlist audio copying, or subscription audio downloading.
- The previous upstream Audiomack JSON parser bug **is not fixed** by this update. v1.0.12 diagnostics and safe original-page navigation are preserved.
- aria2, gallery-dl and Streamlink **are not integrated** in this update.
- Native Windows installer and macOS app/DMG were **not built in this environment**; native build tooling requires network access to npm dependencies and must be tested on the respective OS.

## Build

Windows: extract to a fresh directory, run `BUILD-WINDOWS.bat`, review `GET-IT-BUILD-LOG.txt`, and install `release/GET-IT-Setup.exe` only if the build succeeds.

Mac: extract to a fresh directory, run `BUILD-MAC.command` using Intel/Apple Silicon macOS, and review `release/*.dmg` only after successful packaging. Code signing and notarization remain separate release requirements.

## Suggested tests on your PC

1. Analyze a Spotify track URL. Confirm official preview + **Open in Spotify**, without an MP3 download button.
2. Analyze `https://music.apple.com/us/song/slick/6786449714`. Confirm Apple Music preview or metadata-unavailable state, not a confusing yt-dlp Unsupported URL stack trace.
3. Analyze a permitted SoundCloud or Bandcamp media link. Confirm normal yt-dlp download choices still appear if the provider offers a downloadable stream.
4. Download a locally authorized sample MP4. Confirm real progress, FFmpeg stage, playback verification and 100% at job completion.
5. Verify both official-page navigation and URL validation. A lookalike URL such as `https://open.spotify.com.evil.test/...` must not be treated as Spotify.

Source test results are in `TEST-RESULTS-v1.0.13.md`.

# GET IT! v1.0.12 — Audiomack diagnostics and safe recovery UI

This update does **not** claim to fix the upstream yt-dlp Audiomack extractor.

## Changes
- Detect an Audiomack `Failed to parse JSON` error as a metadata extraction incompatibility, not DRM.
- Keep the full actionable analysis error visible until the URL is changed or analyzed again.
- Offer **Open original page in Audiomack**, handled through narrowly scoped Electron IPC after explicit user interaction.
- Restrict external navigation to official HTTPS Audiomack song/album pages; never automatically open links.
- Keep existing yt-dlp, FFmpeg, progress reporting, history and download behavior unchanged.

## Remaining work
The extractor upstream still uses a legacy Audiomack endpoint. Audiomack's documented API uses HTTPS with OAuth 1.0a and does not imply permission to obtain full tracks. A new extractor needs supported API access and authorized downloadable media. We do not bypass DRM, user access controls or service restrictions.

## Verification
Run `npm test`, `npm run check`, and `npm run build:web` where dependencies are available. Native installer builds require Windows/macOS testing.

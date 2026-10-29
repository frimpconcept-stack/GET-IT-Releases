# GET IT! v1.0.9 — Link Analyzer / DRM Error Fix

This update addresses link-analysis errors, **not DRM circumvention**.

## Changes

1. Fix overbroad mapping of warnings mentioning DRM to false protected-media errors; show the original extractor error details to help diagnose the underlying failure.
2. Prevent `has_drm=true` / `has_drm=maybe` metadata from being offered as playable MP4/MP3. Retain only unprotected formats where present.
3. Clarify unconfirmed vs confirmed DRM status in the UI.
4. Remove Electron `Error invoking remote method 'getit:analyze'` wrapper from the user-facing Analyze Link message.

## Test results

- 54 automated tests: PASS (Linux, Node 22, local FFmpeg/FFprobe).
- Backend syntax: PASS.
- No live social platform or commercial streaming links tested for this release.
- Windows `.exe` and macOS `.dmg`: NOT compiled/tested for v1.0.9 in this environment.

## Build

Windows: Extract ZIP, run `BUILD-WINDOWS.bat`, then inspect `release` for `GET-IT-Setup.exe`.
macOS: Extract ZIP on a Mac, run `BUILD-MAC.command`, then inspect `release/*.dmg`.
Do not claim success until native installation and an authorized real-media download are tested.

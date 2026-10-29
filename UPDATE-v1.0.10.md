# GET IT! v1.0.10 — Missing Output Path Recovery

## Problem addressed

An actual Windows activity log recorded `Downloader exited without returning an output file path` after several social-media downloads. The downloader process could exit with code 0 even though GET IT! had no valid `after_move:filepath` notification. The previous app assumed that a missing notification always meant no media was saved.

## Fix

- When yt-dlp exits successfully but does not report an existing output file, GET IT! searches **only** the chosen destination for a file named with that job's own unique ID. It does not consider unrelated downloads, old files, fragment files, or empty files.
- On exactly one matching candidate, GET IT! passes the recovered file to its normal FFprobe-based playback and codec verification. **100%/Completed is still reserved for verified output.**
- If no matching file is found, the download remains Failed with a specific explanation. No fake success is generated.
- `GETIT_FILE:NA` and nonexistent printed paths no longer count as output evidence.
- The application log records whether the output was recovered or no suitable file was found.
- Playlists still require yt-dlp to report final output paths; the app does not guess matches across multiple playlist items.

## Tests

- 58/58 local Node test cases passed, including four new offline executable integration tests for missing paths, stale paths, unrelated files, and exit-0/no-output behavior.
- Syntax checks passed.
- Real public-site compatibility and the Windows/Mac native installers are not verified in this environment.

## Recommended first test on Windows

1. Extract v1.0.10 into a NEW folder (do not merge source folders).
2. Run `BUILD-WINDOWS.bat` and install the newly produced installer only after the build succeeds.
3. Under Settings > Advanced update yt-dlp if needed; you already updated it on October 23 after the logged failures.
4. Retry the failed authorized video/track URL, then check Active Downloads/History and inspect the error details or saved file.
5. If the same link still fails, provide the direct public post URL and the NEW log lines. DRM-protected, private, unavailable, image-only, or unsupported media cannot be made downloadable by output path recovery.

## For Mac

Run `BUILD-MAC.command` from a new extracted project folder on your Mac. Installations must be tested natively; no DMG is included in this source archive.

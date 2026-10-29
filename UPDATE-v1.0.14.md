# GET IT! v1.0.14 — Multi-engine desktop integration

## Implemented

- **aria2:** A separate engine option for direct HTTP(S) media links with segmented downloading, actual aria2 console progress parsing (bytes, speed, ETA, percent), controlled output paths, pause/resume via aria2's `.aria2` recovery files when supported, cancel, retry, and FFprobe verification. Only the original media extension is offered.
- **gallery-dl:** Dedicated engine option with real extractor inspection (`-E`) and download (`--directory`, `--range 1-150`); files saved in an isolated folder per job. The UI shows indeterminate progress and a measured count/byte total as files appear. It verifies the output files exist and are nonempty before marking complete. The UI provides Open Folder. Unlike video downloads, image files are **not claimed to be playback-tested**.
- **Streamlink:** Dedicated live-stream option; enumerates available streams with `--json`, records selected stream to `.ts`, shows saved-byte growth without a fabricated duration/percent, and offers **Stop & save**. Completed recordings must pass FFprobe media inspection. Pause/resume is intentionally unavailable for live streams.
- **Desktop integration:** New engine selection in Analyze Link, status indicators and executable browse fields in Settings → Advanced, secure Electron IPC, existing download queue, persistence, cancel/retry, safe output naming, and no shell expansion.
- Existing yt-dlp, Spotify/Apple Music catalog-preview restrictions, FFmpeg conversion and verified-progress behavior remain in place.

## Mandatory optional-binary setup

**aria2, gallery-dl, and Streamlink are not downloaded automatically by this release.** To use an engine, install/provide a trusted binary first, then open GET IT! → Settings → Advanced → select the corresponding standalone executable → Save changes. The app probes `--version` and shows availability. Windows standalone releases do not require users to install Python.

To bundle portable binaries into the Windows EXE installer, place supported standalone executables in `GET-IT/vendor/win32-x64/` **before** running `BUILD-WINDOWS.bat`:

- `aria2c.exe`
- `gallery-dl.exe`
- `streamlink.exe` **and** any required adjacent runtime files for the selected portable distribution. A single extracted EXE is not enough if the publisher ships companion files; preserve the portable package layout and inspect its license.

To bundle macOS binaries, place compatible self-contained executables at `vendor/darwin-x64/` (Intel) or `vendor/darwin-arm64/` (Apple Silicon). macOS Streamlink/gallery-dl often depend on a separately packaged Python runtime. Do **not** assume a Homebrew script alone will run on someone else's Mac. Packages must include applicable license notices.

Verified upstream documentation:
- aria2: https://aria2.github.io/ , https://github.com/aria2/aria2/releases
- gallery-dl: https://github.com/mikf/gallery-dl/wiki/Installation
- Streamlink: https://streamlink.github.io/install , https://github.com/streamlink/windows-builds/releases

## Scope and safety

- This is not a universal streaming-service ripper. Spotify/Apple Music catalog previews remain metadata-only. No bypasses of DRM, access controls or paywalls.
- aria2 requires a **direct file URL**, not a YouTube/TikTok page. For those use yt-dlp.
- Gallery metadata varies by source; the app reports source recognition rather than claiming an image count that wasn't returned.
- Live stream recording may continue indefinitely until Stop & save or the source ends; there is no estimated completion percentage. `.ts` containers may require a capable player (such as VLC).
- Official gallery-dl and Streamlink standalone executables were **not** available in the testing environment. Engine-level end-to-end tests exercised simulated CLI programs that wrote actual local media/files and verified them. Live third-party platform downloads and Windows/macOS installer functionality remain unverified.

## Windows installation

1. Extract the source ZIP into a new folder.
2. Optionally stage verified portable engine binaries under `GET-IT/vendor/win32-x64/` as described above, including required companion files.
3. Run `GET-IT/BUILD-WINDOWS.bat`; monitor `GET-IT-BUILD-LOG.txt`.
4. When successful, install the EXE from `GET-IT/release/`.
5. Open Settings → Advanced, confirm that each engine is Available or browse to its binary, then Save changes.
6. Try a permitted direct file with aria2; a public gallery with gallery-dl; a permitted live stream with Streamlink. Confirm outputs, pause/resume where offered, stop/save recording, folder opening and history persistence.

macOS: build using `BUILD-MAC.command`, supply compatible native executables and any necessary runtime in `vendor/darwin-<arch>/`, and verify the DMG on a Mac. Unsigned/notarized distribution still requires work.

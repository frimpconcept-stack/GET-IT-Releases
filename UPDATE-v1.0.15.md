# GET IT! 1.0.15 — Windows installer engine bundling

## What changed

- **Windows x64 build now attempts to provision aria2, gallery-dl and Streamlink automatically.** `npm run package:win` includes `scripts/provision-optional.mjs` after yt-dlp/FFmpeg provisioning and before Electron Builder. The BUILD computer needs internet access to official GitHub/Codeberg releases, but an installed application should not need Python or a separate installer.
- The build retrieves the publisher release metadata, selects Windows x64 **portable** assets, and requires a publisher SHA-256 digest or SHA-256 checksum file. If no verifiable digest is available, packaging **stops** instead of bundling an unverified executable.
- Verified release archives are cached under `.build-cache/engine-assets/`; subsequent builds can reuse installed executables once their executable hash and `--version` check again. Set `GETIT_REFRESH_ENGINES=1` to intentionally recheck publishers for newer versions.
- aria2 archive companion libraries are preserved, gallery-dl is installed as a standalone executable, and Streamlink's whole portable archive (including its embedded Python runtime, modules and FFmpeg support files) is retained.
- The built app looks for `aria2/aria2c.exe`, `gallery/gallery-dl.exe`, and `streamlink/bin/streamlink.exe` in its packaged `resources/bin/win32-x64/` directory.
- The user interface now describes expected bundled engines and still allows a custom path in Settings → Advanced.
- Existing yt-dlp, FFmpeg, music catalog previews, progress reporting and verified completion remain unchanged.

## Building on Windows

1. Extract this ZIP into a *new directory*.
2. Keep Windows Security enabled. Make sure official `github.com`, `api.github.com`, and `codeberg.org` downloads are reachable.
3. Double-click `BUILD-WINDOWS.bat` (Node.js/npm required **on the build computer only**).
4. Step 5 will download/check yt-dlp, FFmpeg/FFprobe and then the three optional engines. Downloading Streamlink's portable distribution can take longer than a typical npm install. Monitor `GET-IT-BUILD-LOG.txt`.
5. If any engine fails checksum verification, version probing or download, the installer build **fails with an error**. This is deliberate. Resolve the specific error rather than disabling Defender or TLS security.
6. A successful build produces `release/GET-IT-Setup.exe`. Install and open Settings → Advanced. Check that all three engines say **Available** before testing permitted direct media, public galleries, and live streams.

### Important limitations

- The 83 local automated tests validate existing download logic, archive-selection/checksum handling and packaged executable path discovery. They **do not** constitute a successful Windows or macOS installer build. The official portable executables were not downloaded in this environment; publisher/API schema or release asset names might change. An official binary version check during Windows packaging is the release gate.
- **macOS builds still require manually supplied, self-contained optional engine runtimes.** Public macOS standalone packages are inconsistent (particularly for tools implemented in Python). The Mac `.dmg` does not automatically provision these three tools in 1.0.15. Do not claim all engines are included in a Mac build until verified on macOS.
- The new three engines are for permitted media only. Spotify/Apple Music subscription streams, DRM and access restrictions remain unsupported.
- Streamlink's portable archive includes its own embedded Python. Users of a packaged Windows installer do **not** install system Python. Review licenses and required source-offer obligations (gallery-dl and aria2 may be GPL; Streamlink and FFmpeg have separate licenses) before public redistribution.

## Troubleshooting

- If build log says `no release digest and no checksum manifest`, the publisher's current downloadable artifact could not be verified. The build refuses that artifact. Do not disable integrity verification to force packaging.
- If a publisher changes an archive filename/layout, the build prints its discovered asset names and stops. Use the official publisher's release page and update the asset-selection logic after confirming provenance.
- If GitHub/Codeberg times out, retry after connectivity is restored. Previously verified engines from a successful build can be reused offline, but a first build needs the original assets.
- If `GET IT! → Settings → Advanced` shows Not Detected after an installer succeeds, report the location and version under `resources/bin/win32-x64/` plus the GET-IT application activity log. An exe can exist but fail its `--version` check if runtime DLLs were not packaged properly.

Publisher sources: https://github.com/aria2/aria2/releases ; https://codeberg.org/mikf/gallery-dl/releases ; https://github.com/streamlink/windows-builds/releases .

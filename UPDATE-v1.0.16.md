# GET IT! v1.0.16 — Windows engine downloads corrected

**Purpose:** one-click download and packaging preparation for aria2, gallery-dl, and Streamlink, preserving yt-dlp, FFmpeg and the existing GUI.

## What changed

- `DOWNLOAD-AND-ADD-ENGINES.bat` obtains the three portable **Windows x64** engines on the user's PC, validates SHA-256 of each download, tests each executable via `--version`, and stages the files in `vendor/win32-x64`.
- Fixed gallery-dl source: use the maintainer's GitHub `gdl-org/builds` Windows `.exe` release (the source archive at `mikf/gallery-dl` is not a Windows standalone EXE).
- Fixed Streamlink release selection: the official portable asset uses a `...x86_64.zip` filename without the word `portable`.
- Fixed aria2 verification: the upstream release does not currently publish a SHA-256 digest in release asset metadata. Pin only the **aria2 1.37.0 Windows x64** artifact to the independently published ScoopInstaller/Main `aria2.json` SHA-256. This is a community package manifest checksum, **not a publisher signature**. Unknown archives are refused.
- Preserve Streamlink's executable next to its original portable runtime instead of moving it away from associated libraries.
- The installer build already runs the corrected provisioning before Electron Builder packages native tools.

## Verified versions / sources, October 23, 2026

| Tool | Release artifact | Integrity source |
|---|---|---|
| aria2 | `aria2-1.37.0-win-64bit-build1.zip` | ScoopInstaller/Main pinned SHA-256 `67d015...d9b288` |
| gallery-dl | `gallery-dl_windows.exe`, daily build `2026.10.23` | GitHub release asset SHA-256 `f38030...51d42d3` |
| Streamlink | `streamlink-8.6.2-2-py314-x86_64.zip` | GitHub release asset SHA-256 `12e0c8...c67ff2b3` |

The installer queries the newest release metadata. If a release changes, it selects a compatible asset and requires a trusted corresponding checksum; it refuses new aria2 artifacts until their SHA-256 is reviewed and pinned.

## Build and install on Windows 10/11 64-bit

1. Extract this ZIP into a new folder.
2. Double-click `DOWNLOAD-AND-ADD-ENGINES.bat` with an internet connection (this is optional; `BUILD-WINDOWS.bat` also provisions the engines).
3. Check `GET-IT-ENGINE-INSTALL-LOG.txt` for `SUCCESS`. The tools should be in `vendor/win32-x64/`.
4. Run `BUILD-WINDOWS.bat` to package the verified files into the installer. Check `GET-IT-BUILD-LOG.txt`.
5. Install `release/GET-IT-Setup.exe`, then open Settings → Advanced to check the engine versions and availability.

The user of the finished installer should not need Python or the engine downloads separately, assuming the build completes and the files are packaged correctly.

**Restrictions:** The server may temporarily be unavailable, some URLs may require sign-in, and protected/DRM media remains unsupported. Use only for permitted media. Note that gallery-dl, aria2, and Streamlink have their own third-party licenses; review them before redistribution.

## Testing limitations

The asset names and known SHA-256 values were checked against GitHub release metadata and ScoopInstaller/Main. The Node scripts passed local static and provisioning-selection tests. **Official Windows binaries cannot be downloaded into this environment**, and their launch and the native `.exe` build were **not** verified here. `DOWNLOAD-AND-ADD-ENGINES.bat` will perform the actual download and binary version checks on your Windows PC and abort if anything fails.

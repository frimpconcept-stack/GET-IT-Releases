# GET IT! v1.0.18 — Cloud builds from Windows to Windows and Mac

Based on the uploaded v1.0.17 project. No downloader UI or core transfer behavior was intentionally changed.

- Updated `.github/workflows/build-installers.yml` with a manual platform selector: `all`, `windows`, `mac`.
- Valid GitHub standard runner choices: Windows Server 2022 x64, macOS 15 Intel x64, macOS 15 Apple Silicon ARM64.
- Workflow verifies OS/CPU architecture, installs dependencies, stages yt-dlp and FFmpeg/FFprobe, runs syntax and functional tests, builds native installers, and uploads them as Actions artifacts (30-day retention).
- For Windows cloud builds, the native installer scripts also attempt to bundle verified aria2, gallery-dl and Streamlink as in v1.0.17. Mac optional engines are not yet automatically bundled.
- Added `scripts/verify-release.mjs` with minimum size and expected filename assertions, so missing installers cannot be silently treated as success.
- Added `CLOUD-BUILD-WINDOWS-AND-MAC.bat` for optionally creating a private GitHub repository, committing/pushing code, and triggering the workflow from Windows (requires Git and GitHub CLI). It asks before any upload.
- Added `BUILD-WINDOWS-AND-MAC-FROM-WINDOWS.md` for both GUI and command-line use.
- Added 6 tests for cloud configuration and release verification, and expanded `.gitignore` for common secrets.

## What is NOT completed

- No actual Windows .exe or macOS .dmg files are included in the source ZIP.
- Workflow execution on GitHub has not been performed from this environment, nor have installers been installed/tested on target PCs/Macs.
- macOS packages will be unsigned and not notarized; app installation may require manual trust confirmation.
- Real downloads and functionality with current official upstream tools require verification on end-user machines.

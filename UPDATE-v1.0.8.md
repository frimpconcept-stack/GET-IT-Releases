# GET IT! v1.0.8 — Windows installer test fix

## What went wrong in v1.0.7

On Windows during `BUILD-WINDOWS.bat` Step 4, **46 tests passed and 1 failed**:

```
real manager IPC-level workflow: simulated social and audio extractors produce verified media
Error: yt-dlp is not installed.
```

The test created a fake yt-dlp CLI as an **extensionless Unix shell/shebang executable**, then expected Windows to run it like a native program. Windows does not execute an extensionless shebang script as a native `.exe`, so the test reported a missing downloader even though real yt-dlp had not yet been provisioned. This was a *test-fixture portability bug*, not proof that live social-media downloads were broken. Real yt-dlp was designed to be downloaded in Step 5 of the Windows build, after tests.

## Fix

- The simulated CLI is now a `.cjs` fixture launched using `process.execPath` (the current Node executable), with the fixture script passed as an argument. This runs identically on Windows, macOS and Linux without a shell, local yt-dlp installation or disabling security.
- Manager metadata analysis and actual download child-process launches support an optional **internal engine argument prefix**, which the test uses to run its fixture via Node; installed builds continue to run the real yt-dlp executable directly.
- The same integration test still creates real media with FFmpeg and checks metadata, playable output, and completed jobs for simulated video and audio sources.
- The change does not alter the GUI, stored download history, yt-dlp production options, security settings, or media extraction behavior.

## Tested here

- `npm run check`: passed.
- `npm test`: **47 passed / 0 failed / 0 skipped** on Linux, including the previously failing simulated social/audio test.
- Windows `.exe` installer and macOS `.dmg`: **not built here**. The native Windows rebuild remains to be tested on a Windows PC.
- Live social-media downloads: **not verified**. A fake extractor tests the application integration path, not external provider availability.

## Build the Windows installer

1. Close GET IT! and extract the v1.0.8 ZIP into a **fresh directory**. Do not overwrite the source of a running installer.
2. Open `GET-IT` and double-click `BUILD-WINDOWS.bat`. Node.js and internet access are required **on the build computer**.
3. The log `GET-IT-BUILD-LOG.txt` will record all five stages. Expect 47 passing tests in Stage 4 if FFmpeg/FFprobe are available on PATH; local-media tests are skipped when those tools are absent.
4. If Step 5 succeeds, find `release/GET-IT-Setup.exe` and test the installed application. yt-dlp/FFmpeg should be bundled by the Step 5 packaging stage.
5. If it fails, send the **new log** from the v1.0.8 folder; the failing stage determines the next fix.

An installer produced by a previous source version is not updated by extracting a new ZIP. Rebuild and install to apply the new version.

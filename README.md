> **NEW v1.0.19 — GitHub Releases application updater:** GET IT! can check for published updates, show download progress, and restart to install them. An additional GitHub Actions workflow builds a Windows draft release. Public release-only repositories can distribute updates while keeping source private. Read [`GITHUB-AUTO-UPDATES.md`](GITHUB-AUTO-UPDATES.md). The initial updater-enabled installer must be installed manually once. macOS auto-updates still require signed builds and a dedicated publishing workflow.
> **NEW v1.0.18: Build Mac DMGs from your Windows PC using GitHub Actions.** Open `BUILD-WINDOWS-AND-MAC-FROM-WINDOWS.md`, then run `CLOUD-BUILD-WINDOWS-AND-MAC.bat` on Windows after installing Git and GitHub CLI. The GitHub workflow can build Windows, Mac Intel and Mac Apple Silicon. Mac optional engines are not yet bundled, and installers are unsigned.
> **Windows engine build update (v1.0.16):** To add aria2, gallery-dl and Streamlink, run `DOWNLOAD-AND-ADD-ENGINES.bat` (downloads and SHA-256 verifies the portable binaries) then run `BUILD-WINDOWS.bat` (includes the staged engines in the installer). See `UPDATE-v1.0.16.md`. The source ZIP itself does not contain the official binary executables: downloads happen on your Windows build machine.
GET IT! v1.0.15 — Windows automatic optional-engine provisioning
Latest: Windows build attempts to automatically package aria2, gallery-dl and Streamlink, including Streamlink portable runtime files. They are verified against upstream SHA-256 release hashes and checked using `--version` before packaging. The installer build intentionally fails if an engine cannot be downloaded or verified; no more silently missing optional engines. Read `UPDATE-v1.0.15.md` and `TEST-RESULTS-v1.0.15.md` first. macOS optional engines still require separate packaged runtimes.
Status: 83/83 automated tests pass on Linux. The actual Windows installer and official engine binaries have not been tested in this environment. Native builds are still required before distribution.
---
> **v1.0.13 music catalog update:** Spotify and Apple Music official metadata previews and catalog-only handling; Deezer/TIDAL/Amazon Music official-link recognition. Streaming links are not downloadable. See `UPDATE-v1.0.13.md` and `TEST-RESULTS-v1.0.13.md`.
> **v1.0.12 Audiomack note:** The app now diagnoses `Failed to parse JSON` from yt-dlp as an upstream Audiomack metadata error and provides a safe browser action. This does **not** make Audiomack audio downloadable. See `UPDATE-v1.0.12.md`.
GET IT! — v1.0.11 progress visibility update
Latest: Download-progress state consistency fixes: no stale progress during retries or failures; separate indeterminate preparing/merging/verification; paused jobs preserve measured progress; and 100% requires successful playback verification. See `UPDATE-v1.0.11.md`. Earlier downloader engines and platform support are unchanged. Additional aria2/gallery-dl/Streamlink integration is not included in this version.
GET IT! — Desktop Video & Audio Downloader
Latest source: v1.0.8 repairs a Windows-only failure in the simulated yt-dlp test fixture used by the installer builder. It retains v1.0.7 social-media/audio features. Read UPDATE-v1.0.8.md before building. This is source code, not a signed installer.
Project status: Electron / React / Vite desktop source implementation, with tested native transfer/conversion modules. This archive does not contain a built installer or a deployed application. Test results reflect the environment and workflows listed in `TEST-RESULTS.md`; Electron integration, real yt-dlp providers, signing and native install packages require a Windows or macOS build/test host.
GET IT! uses secure Electron IPC for its interface and Node.js download management. It handles direct HTTP(S) media and sites supported by yt-dlp where the video may lawfully be downloaded. It does not bypass DRM, paywalls, sign-in access controls or video-site restrictions.
Playback compatibility fix (v1.0.3) — Windows video issues
GET IT! v1.0.3 changes the output pipeline to help when a file is saved but does not play, has missing audio, or is choppy on older Windows PCs.
For MP4, yt-dlp preferentially selects H.264 video (AVC) and AAC/M4A audio when those source streams exist. When it must use another codec, GET IT! checks the actual resulting tracks with FFprobe and converts incompatible MP4 output to H.264/AAC (8-bit yuv420p) using FFmpeg. It also fixes MP4 metadata placement for easier playback/seeking.
Quality selection uses a maximum height, so a selected 720p output can use a lower quality if the exact 720p variant is unavailable.
Each media file is checked before marking the job Completed. Missing/corrupt media that FFprobe cannot read is reported as failed, not silently marked successful. FFprobe metadata validation does not guarantee every second of a file decodes correctly.
Completed video jobs have a functional Repair playback button. It creates a new MP4 with H.264/AAC, optionally scales down to fit within 1920×1080 (to reduce playback demands on low-end computers), and keeps the original. The repair runs through a real FFmpeg queue with cancellation and progress reporting.
The Completed screen displays verified video/audio codecs and whether compatibility conversion was performed.
Important: Videos downloaded by earlier GET IT! versions are not automatically changed during installation. Use Completed → Repair playback in v1.0.3 for an existing video, or redownload it. If an old record does not appear or its file has moved, re-download through the new app or convert it manually with FFmpeg.
Install on Windows: Close GET IT!, extract this archive to a NEW folder, double-click `BUILD-WINDOWS.bat`, then run `release/GET-IT-Setup.exe` if the build finishes successfully. If the build fails, open `GET-IT-BUILD-LOG.txt` to see the actual error. Source changes alone will not update a previously installed GET IT! executable.
Playback tip: On older 4 GB RAM machines, select MP4 at 720p or 1080p, not 4K. Verify playback in Windows Media Player or VLC. Extreme bitrates, broken original source media, or unsupported device drivers can still affect playback.
Verification scope: 24/24 Node backend tests pass using generated local video/HTTP files; JSX syntax parses. A native packaged Windows executable, installed GUI and external provider-specific yt-dlp playback have not been tested in this Linux environment.
Progress display corrections (v1.0.2)
This version corrects the desktop download progress UI and its backend data handling. Rebuild and reinstall the Windows installer to get these changes; replacing the source archive alone does not modify an already-installed executable.
Direct HTTP media: progress derives from bytes received and reported Content-Length, with measured transfer speed and estimated time remaining. A missing size/ETA now shows an indeterminate progress indicator rather than a fabricated percentage.
yt-dlp: the percentage reflects the current transfer, not a guaranteed end-to-end percentage across video+audio, playlists, merging, and transcoding. A second stream is labeled separately; playlist transfers are explicitly labeled as per-transfer progress.
FFmpeg: video/audio processing appears as a separate stage. Real FFmpeg conversion time reports an actual stage percentage when available; external yt-dlp post-processing without percentage information is indeterminate.
Completed jobs display 100% only after the output file exists, along with its verified on-disk size. Paused, cancelled, and failed jobs retain their job state.
Transfer event updates are throttled to reduce unnecessary UI rendering on low-RAM computers.
Windows update steps: Close GET IT!, extract the new source into a fresh folder, run `BUILD-WINDOWS.bat`, then run the newly built `release/GET-IT-Setup.exe`. Keep existing user data/history by reinstalling normally without deleting the profile. If the build fails, consult `GET-IT-BUILD-LOG.txt`. The corrected source has passed backend tests; no native GUI or Windows packaged executable has been verified here.
Requirements for building
Node.js 22 and npm.
Internet connectivity to obtain npm dependencies, yt-dlp, FFmpeg and FFprobe on the build machine.
Windows 10/11 x64 or current supported macOS Intel / Apple Silicon for the final application; native builds should be produced/tested on the intended OS.
macOS code signing and notarization require your Apple Developer credentials, certificates and a macOS runner. A normal CI artifact without signatures may trigger operating-system security warnings.
End users of a fully packaged installer do not need Python or a terminal. Bundled binaries are stored under `resources/bin/<platform>-<arch>/`.
Development
```bash
npm install
npm run check
npm test
npm run dev
```
`npm run dev` launches Vite and a real Electron window. Do not run the Vite development URL as a substitute for Electron; browser-only pages lack the secure `window.getit` IPC API.
For a local test with yt-dlp downloaded automatically for your OS:
```bash
node scripts/provision.mjs
npm run dev
```
`provision.mjs` needs an internet connection and checks yt-dlp's SHA-256 against the checksum published by the upstream project. It installs matching FFmpeg and FFprobe executable packages via npm. Supply independently approved binaries if your organization's licensing/security policy requires them.
Windows build failure and diagnostics
The previous 1.0.0 archive had a confirmed Windows-only packaging bug: `scripts/provision.mjs` called `spawnSync('npm.cmd', ...)` without the shell required by current Node on Windows. In 1.0.1, the provisioner executes npm's JavaScript CLI directly with `process.execPath` and never launches `npm.cmd` from a child process. An additional test exercises this implementation. This fixes that identified issue but does not establish that an installed Windows GUI or installer has been tested.
Double-click `BUILD-WINDOWS.bat` inside the extracted `GET-IT` folder. The script runs setup, syntax checks, tests, native binary provisioning and installer packaging and writes `GET-IT-BUILD-LOG.txt` beside the script. If it fails, send that log or its last 65 lines. A working internet connection is required on the build computer. If you see `ETIMEDOUT`, `EAI_AGAIN`, `ECONNRESET`, `403`, `404` or TLS errors, the corresponding endpoint may be unavailable or filtered. Never turn off system certificate verification to bypass these errors.
Build native installers
On Windows x64:
```powershell
npm install
npm run package:win
```
On macOS Intel:
```bash
npm install
npm run package:mac-intel
```
On macOS Apple Silicon:
```bash
npm install
npm run package:mac-arm
```
The intended output folder is `release/`. Windows uses an NSIS installer `GET-IT-Setup.exe`; macOS uses separate architecture-specific outputs such as `GET-IT-x64.dmg` and `GET-IT-arm64.dmg`, with `.app` inside the DMGs. These names describe configured targets, not files currently supplied.
GitHub Actions build (no coding required after uploading source)
A manual CI build is included at `.github/workflows/build-installers.yml`. Upload this source to a GitHub repository, open Actions → Build GET IT! installers → Run workflow, and retrieve each completed artifact from the workflow. It builds Windows x64, macOS Intel and macOS Apple Silicon on native hosted runners. The CI workflow's signing is intentionally disabled until you configure trusted certificates and credentials. Add signing/notarization secrets before distributing to end users.
User workflow
Launch the installed app and go to New Download.
Paste a permitted direct video URL or supported public video-page link.
Click Analyze link and review title, quality, actual available formats and destination.
Choose a format and quality. Click Download now. Progress and estimated time update from download events, not a timer.
Find your transfer in Active, Completed, or History. Pause/Resume for direct links when possible; website downloads on Windows cannot be paused mid-transfer and can be cancelled then retried instead. The source server controls whether the partial data can be reused.
For local files, open Video to Audio, choose the video and desired MP3/M4A/WAV output, and select Extract audio.
To change downloads folder, default formats, concurrency or retry policy, use Settings.
Modules
Path	Purpose
`electron/main.cjs`	Secure main process and IPC handlers; native folder picker, notifications and opening files
`electron/preload.cjs`	Narrow Electron context bridge
`electron/manager.cjs`	Real HTTP transfers, yt-dlp invocation, queue, pause/cancel/retry, progress and history
`electron/progress.cjs`	Typed yt-dlp progress parsing, missing metrics and stream-phase tracking
`electron/media.cjs`	FFmpeg conversion, progress and duration probing
`electron/engines.cjs`	Tool resolution, executable version checks and SHA-256-verified yt-dlp update
`electron/store.cjs`	JSON preferences/history and bounded activity log saved in the OS per-user app-data location
`src/App.jsx`, `src/style.css`	Dark/light React GUI with desktop dialogs and linked action buttons
`scripts/provision.mjs`	Downloader and FFmpeg/FFprobe dependencies for installer builds
`scripts/npm-runner.mjs`	Cross-platform npm JS CLI launcher (avoids Windows `.cmd` EINVAL errors)
`scripts/build-mac.mjs`	Native-architecture macOS package script
`tests/manager.test.cjs`	Local real-download transfer tests using an authorized FFmpeg-created video
Limitations and reliability details
Source quality depends on provider. Formats listed for an analyzed site are derived from metadata, but provider delivery/DRM/availability can change after analysis.
Direct media is identified primarily from its filename extension; extensionless URLs that serve video may need upstream yt-dlp support.
File sizes/ETA depend on the server's headers; unknown sizes show a neutral indicator rather than fabricated progress.
Playlist downloads are grouped as a single history entry with a count of finished files; individual per-item queues inside that playlist are managed by yt-dlp.
`--recode-video` may use substantial CPU for transcoding; 4GB RAM machines should limit concurrency.
Only English UI is included. Additional language choices are not exposed as working translations.
Metadata fetch and downloads for real video platforms have not been end-to-end verified in this offline container because yt-dlp is not available here. Test permitted URLs on the target OS before release.
For publisher reputation, sign Windows installers and sign/notarize Mac installers. Without valid signing, the OS can warn users.
Licensing
GET IT! source is MIT. Electron and other npm dependencies have their own licenses. yt-dlp and FFmpeg have different licenses; distributing FFmpeg binaries may incur LGPL/GPL and codec-license obligations depending on the build. Review the actual binary provenance, build configuration and redistributable licensing before public deployment. Do not include protected third-party media in app testing or release artifacts.
No-terminal build shortcuts
For developers on Windows who have Node.js installed, double-click `BUILD-WINDOWS.bat`. On macOS, the `BUILD-MAC.command` script runs the checks and packages the architecture of the current Mac (subject to macOS script security prompts). These are build-machine tools, not end-user installation requirements.

v1.0.4 Windows build notes
This release uses `stream.pipeline` to safely abort active disk writes on pause/cancel and prevent delayed `ERR_STREAM_DESTROYED` errors. The Windows FFmpeg integration test now allows up to 90 seconds and reports the last job phase or actual backend error on failure. The `allowScripts` policy explicitly permits known Electron/esbuild/installer dependency scripts on npm versions that require approval.
On a Windows 10/11 x64 build computer, unzip this version into a new folder and run `BUILD-WINDOWS.bat`. The application is not automatically built by downloading this source archive. Keep Windows Security enabled, verify any downloaded native tools, and inspect `GET-IT-BUILD-LOG.txt` if anything fails.

v1.0.5 — Download Now navigation and visibility fix
The Download now button now opens the download record returned by the real Electron backend:
New requests appear on Active Downloads immediately, with their actual queue status.
If the file finishes too quickly to stay in the Active filter, its completed card remains visible in Active Downloads until you navigate elsewhere, including Open File and Open Folder actions.
If the same file is already downloaded, the app opens Completed Downloads and does not silently stay on the New Download page.
Duplicate transfers already running open Active Downloads; download failures show a persistent inline error below the media controls.
Electron job updates received before the queue acknowledgement take precedence, preventing a completed job being overwritten with a stale queued status.
Unexpected React rendering errors display a recoverable error page instead of an empty black view, and write a diagnostic entry to GET IT!'s application log.
Verify on Windows
Extract into a new directory. Run `BUILD-WINDOWS.bat` and install the newly produced `release/GET-IT-Setup.exe` (the existing executable is not updated by simply extracting the ZIP).
Analyze an authorized media URL, select MP4 and click Download now exactly once. Confirm Active Downloads shows the new job and its real progress; after it finishes, verify Open File works.
Return to New Download, analyze and submit the same URL and options; GET IT! should open the existing item in Completed Downloads instead of leaving you on the form.
If a download fails, inspect the red error banner (while still on New Download) or the failed record in Active Downloads and its specific error.
In Settings → Advanced → View application logs, check any Renderer errors if a display failure occurred.
The Electron interface and Windows installer cannot be executed in the provided Linux environment without the npm packages. The passing Node tests validate download functionality and routing logic, not the installed Windows GUI.
GET IT! 1.0.6 — Actual progress reporting
The progress bar is stage-specific and based on real measurements. The native HTTP stage uses received bytes and a known Content-Length. The FFmpeg stage uses media timestamps and probed duration. yt-dlp reports per-stream progress (audio/video can be separate transfers), and playlists can contain multiple transfers. The app clearly labels stream/playlist percentages and does not pretend they represent the entire job. Unknown total size or processing duration displays an animated indeterminate bar instead of made-up percentages.
0% means the transfer has not begun, intermediate percentages come from incoming bytes or video processing, and 100% + Completed is emitted only after the saved file was checked with FFprobe and any required format repair succeeded. A transfer finishing is not the same as the completed job; download, conversion and verification are separate stages. Completed outputs must exist on disk. A very short download may legitimately jump between measured values because the network transfer finishes faster than the UI can render; it does not insert fake numbers.
`npm test` now includes the renderer's standalone progress-view tests (`.test.mjs`) as well as all existing backend integration tests. On a Windows build PC use `BUILD-WINDOWS.bat`, then test `New Download → Analyze → Download Now` with an authorized URL and check the installed app's Active/Completed pages. This source release's Linux test results do not prove the Windows installer or native Electron UI are functional until tested on Windows.

GET IT! v1.0.9 — Link analysis / DRM diagnostic corrections
An `Analyze Link` failure may originate from yt-dlp rather than Electron IPC. v1.0.9 displays a readable extractor error instead of a generic `Error invoking remote method` wrapper.
Error classification now examines the most relevant extractor error rather than unrelated warnings mentioning DRM. The original error detail is included to help troubleshoot unsupported links, authentication requirements, network failures and true DRM protection.
Media with only confirmed protected streams is not offered as an MP4 download because its metadata contains an `mp4` extension. Mixed streams advertise only formats supported by DRM-free tracks.
GET IT! does not decrypt DRM, bypass a paywall or obtain private media without authorization. Use official platform download options for protected media.
To investigate a blocked link, update yt-dlp from Settings → Advanced, retry a public permitted media URL and compare error details. An actual error that reports DRM means GET IT! cannot download that protected stream.
Tests: 54/54 passed on the local Linux backend. Windows/macOS installers and live external platform links remain unverified for this build.

GET IT! v1.0.10 — yt-dlp reported-output recovery
Read `UPDATE-v1.0.10.md`. This version adds strict output recovery for jobs whose unique named file was saved but yt-dlp omitted its `after_move` file-path line. No download is called complete until verified with FFprobe, and no DRM bypass is supported. A valid social link can still be unsupported by the current yt-dlp extractor.

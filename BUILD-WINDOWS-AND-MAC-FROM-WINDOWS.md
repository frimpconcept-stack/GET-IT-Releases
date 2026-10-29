# Build GET IT! for Windows and macOS — from a Windows PC

This source project includes GitHub Actions workflow `.github/workflows/build-installers.yml`.
You **do not need a Mac on your desk**: GitHub builds macOS installers on its own Mac runners. The Windows PC uploads/triggers the build and downloads its artifacts. These are **unsigned builds** until Apple signing credentials are configured.

## Quick way: use the Windows helper (private GitHub repo)

1. Install [Git for Windows](https://git-scm.com/downloads/win) and [GitHub CLI](https://cli.github.com/). Have a GitHub account.
2. Extract the GET IT! source ZIP to a new folder and open `GET-IT`.
3. Open **Command Prompt** and run `gh auth login` (complete GitHub authentication).
4. Double-click `CLOUD-BUILD-WINDOWS-AND-MAC.bat`. Review and approve its *private* repository creation/upload prompt. **It will initialize a Git repository and may commit/push code.** Only run it in a folder containing files you are comfortable uploading; check `.gitignore` and review local changes first.
5. Choose `A` for all, `M` for both Mac editions, or `W` for Windows only.
6. Open GitHub → your repo → **Actions → Build GET IT! installers** → latest run. After a successful run, scroll down to **Artifacts** and download the installer set(s).
7. GitHub sends you an artifact ZIP. Extract it on Windows; inside will be the `.dmg` and `.zip` (Mac) or `.exe` (Windows) installers. Copy the Intel `.dmg` to an Intel Mac or the Apple Silicon `.dmg` to an M-series Mac.

If `git commit` reports *Please tell me who you are*, set your Git name and email using the standard `git config --global user.name ...` and `git config --global user.email ...` commands and rerun the script. If GitHub does not recognize a newly pushed workflow immediately, open the Actions page and try its **Run workflow** control.

## Build with the GitHub website instead

Create a **private** GitHub repository, upload/push the full `GET-IT` folder **contents** (including the hidden `.github/workflows/build-installers.yml`), then open:

**Actions → Build GET IT! installers → Run workflow → target `all` / `mac` / `windows` → Run workflow**.

Be sure the workflow file is on your repository's default branch for the manual Run workflow control to appear.

## Expected output files

| GitHub artifact | Output inside | Device |
| --- | --- | --- |
| `GET-IT-Windows-x64` | `GET-IT-Setup.exe` | Windows 10/11 x64 |
| `GET-IT-macOS-Intel` | `GET-IT-x64.dmg`, `GET-IT-x64.zip` | Intel 64-bit Mac |
| `GET-IT-macOS-Apple-Silicon` | `GET-IT-arm64.dmg`, `GET-IT-arm64.zip` | M-series Apple Silicon Mac |

Each build runs source checks and functional tests before packaging. The workflow fails if the expected installer files are absent or implausibly small. Build success **does not prove** that the native app opens, downloads from real services, or passes notarization. Test the installed app on the actual target machine.

## Current limitations

- **No macOS code signing or Apple notarization.** macOS Gatekeeper may warn when you open an unsigned DMG/app. Only install if you trust the source and build. Distribution to others requires appropriate signing/notarization.
- **Mac optional engines (aria2, gallery-dl, Streamlink) are not automatically provisioned.** The Mac build packages yt-dlp plus FFmpeg/FFprobe; the Windows build attempts to include the three optional engines after downloading and verifying them. Optional engine status can be inspected in app Settings.
- Cloud builds **require internet access**, GitHub Actions availability and available account billing/usage quota. Private macOS and Windows hosted-runner minutes count toward GitHub plan allowances and can incur charges; check account settings.
- Windows and Mac use the same React/Electron source but **build separately on their native operating systems**. Do not rename a Windows `.exe` to `.dmg`.
- The workflow does not upload installers to a public GitHub release; outputs are retained for **30 days as Actions artifacts**.

## Troubleshooting

If a job fails, select its step under GitHub Actions to view the **complete build log**. Some dependency errors arise from GitHub release downloads, release checksums or unavailable npm packages. If it fails at `Check FFmpeg and FFprobe`, at `Test download manager and media files`, or at `Build Windows installer or Mac DMG`, copy that step's log when requesting a repair. The workflow also tries to upload diagnostics as a separate artifact.

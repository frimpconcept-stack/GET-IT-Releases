# GET IT! — GitHub Releases automatic application updates (v1.0.19)

This project implements an app updater distinct from **Install / update yt-dlp**. GET IT! checks published GitHub Releases after startup and every six hours, then offers **Settings > GET IT! software updates > Download update > Restart and install**. No update downloads or installs without a user action. The app does not update while run with `npm run dev`.

## 1. Choose where the public updates will live

**Option A — public source repository:** Source and releases are in the same public GitHub repository. The release workflow uses GitHub's normal built-in token. Do not choose this if your source code needs to be private.

**Option B — private source repository, public release-only repository (recommended for private commercial source):** Keep the actual GET IT! source repository private. Create another *public* GitHub repository, namely `frimpconcept-stack/GET-IT-Releases`, with a README. Only `.exe`, `.blockmap` and `latest.yml` go there. In the **source** repository, open Settings > Secrets and variables > Actions:

1. Add repository **variable** `GETIT_UPDATE_REPOSITORY` with value `frimpconcept-stack/GET-IT-Releases` (optional: the workflow also defaults to this exact repository).
2. Add repository **secret** `RELEASES_TOKEN`, a fine-grained GitHub token allowed to write **Contents** in the public release repository. The source repo Actions workflow uses it to create draft releases there. Restrict the token to only that repo. Do not commit it and never send it to customers.
3. Keep the source repository's Actions enabled. Repository secret access and workflow permissions must be sufficient to create releases.

GitHub Releases in **private** repositories cannot serve the normal public auto-updater without an end-user token. This package does not embed a token, deliberately.

## 2. Initialize the public release repository, then upload GET IT! source

The release repository is verified public but initially **empty**, with no commits, branches, or published releases. Initialize it using GitHub **Add a README** (or push a simple README to `main`) before releasing a version; GitHub needs a commit to base a release tag on. **Do not put private application source code in the public release repository.**

The GitHub connection used in this session has read-only access to `frimpconcept-stack/GET-IT-Releases`; initialization and release publishing must be performed by an account authorized to push to that repository.

### Source repository

On Windows, install Node.js 22, Git and GitHub CLI (`gh`). Extract this ZIP and open PowerShell in the `GET-IT` folder. Set your actual Git identity (the previous cloud-build attempt failed without it):

```powershell
git config --global user.name "YOUR GIT NAME"
git config --global user.email "YOUR VERIFIED GITHUB EMAIL"
gh auth login
```

For a **new private source repo**, run:

```powershell
git init
git add .
git commit -m "Add GitHub Releases app updates v1.0.19"
gh repo create GET-IT --private --source . --remote origin --push
```

For an **existing** source repo, use the normal `git add`, `git commit`, `git push` workflow, preserving your current `origin` remote. Do not create another repo or overwrite the remote. Before tagging, verify `.github/workflows/publish-updates.yml` is committed.

## 3. Publish the first updater-enabled release

For a separate public release repo, set the Actions variable and token secret as described above **before** creating the tag.

```powershell
# In your source repository's folder
git tag v1.0.19
git push origin v1.0.19
```

The `Publish GET IT! update to GitHub Releases (Windows)` GitHub Action will:

- Build on the native Windows runner, provisioning real downloader/media engines.
- Check backend tests and build the NSIS installer.
- Embed the **explicit release repository** URL into the installed app, and generate `latest.yml` / the installer blockmap.
- Reject a private release repository; upload the release files to a **draft** GitHub Release in the public repo.

Open the public release repo > **Releases** and validate the draft. Confirm `GET-IT-Setup.exe`, `latest.yml` and any blockmap were uploaded and that the metadata matches the installer. **Publish** the draft when you are ready. The upload is not published automatically.

### Install the first updater-enabled version once

Install GET IT! **v1.0.19** from the published Windows installer. Older builds (v1.0.18 and earlier) do **not** contain the auto-updater, so they cannot automatically upgrade themselves to v1.0.19. Do not uninstall GET IT!'s profile or delete your history.

## 4. Publish the next update and test end-to-end

Change `package.json` `version` from `1.0.19` to `1.0.20`, commit and push the change to the private source repository, then:

```powershell
git tag v1.0.20
git push origin v1.0.20
```

After successful CI, review and publish the `v1.0.20` draft release in the public releases repository. In the already-installed **v1.0.19** app, open **Settings > GET IT! software updates**, choose **Check for updates**, then **Download update** and **Restart and install**. The app will also check automatically at startup and about every six hours. Test the update on a clean Windows PC before distributing it broadly.

## 5. Manual packaging with GitHub update support

If you build locally rather than through Actions, set the correct public release repository before packaging:

```powershell
npm install
node scripts/configure-update-repo.mjs frimpconcept-stack/GET-IT-Releases
npm run package:win
```

The installer and `latest.yml` will be generated in `release/`. `npm run package:win` deliberately uses `--publish never`: it will **not** upload files on its own. You must attach the installer, blockmap and matching metadata together to a **published** GitHub Release using the correct version tag. Do **not** edit `latest.yml` to guess cryptographic checksums.

## Platform and safety notes

- **Windows:** Native updater supports electron-builder **NSIS**, which this project uses. Publishers should sign installer builds; unsigned installations may show Windows SmartScreen warnings. This CI workflow does not configure code signing. Test before release.
- **macOS:** The app updater code supports macOS, but auto-updating macOS releases **requires Apple code signing**, and Mac release packages require the correct signed ZIP and update metadata (`latest-mac.yml`) alongside DMG. This source archive only automates Windows **update publishing**; the existing workflow still creates unsigned macOS installer artifacts for testing. Do not advertise working auto-update on macOS until signing, publishing and installed-app tests pass.
- **Security:** The updater validates metadata/checksums using `electron-updater`, but integrity checks alone are not publisher identity verification. Configure platform code signing and protect your GitHub account, release repository, Actions secrets and release permissions. Prefer protected tags, carefully review drafts and avoid unverified release binaries.
- **Public vs private:** Never package `GH_TOKEN` / `RELEASES_TOKEN` inside the app. `GH_TOKEN` is only a CI credential for uploading release assets.
- **Versioning:** Use a new version and a matching `vX.Y.Z` tag for each release. Draft and prerelease entries are not normal stable updates.
- **Testing status:** Source checks and Node tests can be run without publishing. Actual installed-app update/installer and signing behavior must be tested on Windows/macOS; this project archive is not a finished installer.

Reference: https://www.electron.build/v26/docs/features/auto-update/

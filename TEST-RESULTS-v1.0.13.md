# GET IT! v1.0.13 — Test report

Execution environment: Linux, Node.js 22.16.0, system FFmpeg/FFprobe. Tests use generated local media and/or simulated extractor input, not real third-party social media downloads.

- `npm run check`: PASSED (Node.js backend syntax checks including `electron/music.cjs`).
- `npm test`: PASSED 71/71 tests, 0 failures, 0 skipped.
- JSX parsing: PASSED using TypeScript's `ScriptKind.JSX` parser (0 parse diagnostics). This is **not a Vite production build**.
- Spotify official link parsing and query tracking removal: PASSED.
- Spotify oEmbed payload handling with an injected deterministic fixture: PASSED.
- Apple iTunes catalog lookup with an injected deterministic fixture: PASSED.
- Deezer/TIDAL/Amazon Music catalog-only handling: PASSED.
- Security (lookalike hosts, non-HTTPS links, credentials, unexpected ports): PASSED.
- Block catalog-only links from entering backend download queue: PASSED.
- Network failure / oversized metadata response handling: PASSED.
- Existing direct HTTP download and native FFmpeg tests: PASSED on generated local media.
- `npm install --ignore-scripts --no-audit --no-fund`: BLOCKED by `getaddrinfo EAI_AGAIN registry.npmjs.org`, so no dependency installation, Vite bundle or Electron packages produced in this environment.
- Live Spotify/Apple Music API calls: NOT TESTED on a reachable network. Fixture-tested only; metadata access can fail and degrade to official-link view.
- Installed GUI tested on Windows/macOS: NOT TESTED.
- Windows `.exe` / macOS `.dmg`: NOT BUILT.

The updated code continues to require explicit permission for downloading protected or copyrighted media and does not attempt DRM bypass.

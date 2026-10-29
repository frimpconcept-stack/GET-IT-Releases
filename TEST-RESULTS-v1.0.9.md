# GET IT! v1.0.9 — Test report

- `npm test`: **54 tests passed; 0 failed; 0 skipped** in Linux test environment with local FFmpeg/FFprobe.
- `npm run check`: PASS.
- New regression checks include: DRM-only streams cannot be exposed as MP4; uncertain DRM tagged streams receive cautious messaging; playable unprotected audio remains selectable when video is DRM-only; DRM warnings do not override the actual non-DRM error; original DRM errors preserve useful detail; Electron wrapper messages are removed for user-facing errors.
- The tests do **not** prove real social service availability, permissions, DRM status of a specific link, macOS DMG behavior or Windows installer behavior.
- React production bundling remains unverified because UI dependencies are not installed in this environment.

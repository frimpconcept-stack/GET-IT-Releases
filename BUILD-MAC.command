#!/bin/bash
set -e
cd "$(dirname "$0")"
if ! command -v node >/dev/null; then
  echo 'Node.js 22 is required on this BUILD computer. See https://nodejs.org/'
  read -r -p 'Press Enter to close...'
  exit 1
fi
npm install --no-audit --no-fund
npm run check
npm test
if [ "$(uname -m)" = 'arm64' ]; then
  npm run package:mac-arm
else
  npm run package:mac-intel
fi
echo 'Build finished. Review release/ for the DMG and ZIP.'
read -r -p 'Press Enter to close...'

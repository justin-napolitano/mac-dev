# ----- repair-brewed-git.sh -----
set -euo pipefail

# 1) Detect brew prefix and pin brew to system git/curl for this repair
if [ -x /opt/homebrew/bin/brew ]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi
BREW_BIN="${BREW_PREFIX}/bin/brew"

export HOMEBREW_GIT_PATH="/usr/bin/git"
export HOMEBREW_CURL_PATH="/usr/bin/curl"
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ENV_HINTS=1

# 2) Make sure brew can update even if repos were funky
"${BREW_BIN}" update || "${BREW_BIN}" update-reset

# 3) Reinstall curl first (keg-only) so git can link to it
"${BREW_BIN}" reinstall curl

# 4) Reinstall git from bottle (fast) so its git-remote-https links brewed libcurl
#    If you want to be extra sure, add: --force-bottle
"${BREW_BIN}" reinstall git --force-bottle

# 5) Optional: ensure curl's bin shows up first in PATH (binary side, not strictly required)
if ! grep -q "${BREW_PREFIX}/opt/curl/bin" "$HOME/.zshrc" 2>/dev/null; then
  echo "export PATH=\"${BREW_PREFIX}/opt/curl/bin:\$PATH\"" >> "$HOME/.zshrc"
fi
export PATH="${BREW_PREFIX}/opt/curl/bin:$PATH"

# 6) Verify linkage: git-remote-https should point to brewed libcurl, not /usr/lib/libcurl.4.dylib
GIT_PREFIX="$("${BREW_BIN}" --prefix git)"
GIT_REMOTE_HTTPS="${GIT_PREFIX}/libexec/git-core/git-remote-https"

echo "=== otool -L ${GIT_REMOTE_HTTPS} (first lines) ==="
otool -L "${GIT_REMOTE_HTTPS}" | sed -n '1,8p'
echo "==============================================="

# 7) Soft pass/fail message
if otool -L "${GIT_REMOTE_HTTPS}" | grep -q "${BREW_PREFIX}/opt/curl/lib/libcurl.4.dylib"; then
  echo "✅ Brewed git now links brewed libcurl. You're fixed."
  exit 0
fi

echo "⚠️  Still seeing system /usr/lib/libcurl.4.dylib. Trying source build..."
# Fallback: build git from source so it **must** link to brewed curl on your machine
HOMEBREW_GIT_PATH="/usr/bin/git" HOMEBREW_CURL_PATH="/usr/bin/curl" \
  "${BREW_BIN}" reinstall git --build-from-source

echo "=== otool -L (post source-build) ==="
otool -L "${GIT_REMOTE_HTTPS}" | sed -n '1,8p'

if otool -L "${GIT_REMOTE_HTTPS}" | grep -q "${BREW_PREFIX}/opt/curl/lib/libcurl.4.dylib"; then
  echo "✅ Fixed after source build."
else
  echo "❌ Still wrong linkage. As a last resort:"
  echo "   - Ensure PATH starts with ${BREW_PREFIX}/bin"
  echo "   - Temporarily: export DYLD_FALLBACK_LIBRARY_PATH='${BREW_PREFIX}/opt/curl/lib'"
  echo "   - Then retry brew commands."
  exit 1
fi


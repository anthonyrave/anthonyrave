#!/bin/bash

# Team installation script for Git pre-push hook with PHPStan
# This script sets up the pre-push hook for the entire development team

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$SCRIPT_DIR")"
HOOKS_DIR="$REPO_ROOT/.git/hooks"
PRE_PUSH_HOOK="$HOOKS_DIR/pre-push"

echo "🚀 Setting up Git pre-push hook with PHPStan integration"
echo "Repository: $REPO_ROOT"
echo

# Check if we're in a git repository
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo "❌ Error: Not in a Git repository!"
    echo "   Please run this script from within your Git repository."
    exit 1
fi

# Check if make is available
if ! command -v make >/dev/null 2>&1; then
    echo "⚠️  Warning: 'make' command not found!"
    echo "   The pre-push hook requires make to be installed."
    echo "   Please install make for your system:"
    echo "   - Ubuntu/Debian: sudo apt-get install make"
    echo "   - macOS: xcode-select --install"
    echo "   - Windows: Install via chocolatey, scoop, or WSL"
    echo
fi

# Check if composer is available
if ! command -v composer >/dev/null 2>&1; then
    echo "⚠️  Warning: 'composer' command not found!"
    echo "   PHPStan requires Composer to be installed."
    echo "   Please install Composer from https://getcomposer.org/"
    echo
fi

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Check if pre-push hook already exists
if [ -f "$PRE_PUSH_HOOK" ]; then
    echo "📄 Existing pre-push hook found."
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Installation cancelled."
        exit 1
    fi
    echo "🔄 Backing up existing hook as pre-push.backup"
    cp "$PRE_PUSH_HOOK" "$PRE_PUSH_HOOK.backup"
fi

# Create the pre-push hook
cat > "$PRE_PUSH_HOOK" << 'EOF'
#!/bin/sh

# Git pre-push hook for PHPStan static analysis
# This hook runs PHPStan via make command before allowing code to be pushed
# 
# Called by "git push" after it has checked the remote status, but before anything
# has been pushed. If this script exits with a non-zero status nothing will be pushed.
#
# Hook parameters:
# $1 -- Name of the remote to which the push is being done
# $2 -- URL to which the push is being done
#
# To bypass this hook temporarily, use: git push --no-verify

remote="$1"
url="$2"

echo "🔍 Running PHPStan static analysis before push..."
echo "Remote: $remote"
echo "URL: $url"
echo

# Check if make command is available
if ! command -v make >/dev/null 2>&1; then
    echo "❌ Error: 'make' command not found!"
    echo "   Please install make or ensure it's in your PATH."
    echo "   To bypass this check temporarily, use: git push --no-verify"
    exit 1
fi

# Check if Makefile exists
if [ ! -f "Makefile" ]; then
    echo "❌ Error: Makefile not found in repository root!"
    echo "   PHPStan analysis requires a Makefile with 'phpstan' target."
    echo "   To bypass this check temporarily, use: git push --no-verify"
    exit 1
fi

# Check if phpstan target exists in Makefile
if ! grep -q "^phpstan:" Makefile; then
    echo "❌ Error: 'phpstan' target not found in Makefile!"
    echo "   Please add a 'phpstan' target to your Makefile."
    echo "   To bypass this check temporarily, use: git push --no-verify"
    exit 1
fi

echo "📋 Running: make phpstan"
echo "----------------------------------------"

# Run PHPStan via make command
if make phpstan; then
    echo "----------------------------------------"
    echo "✅ PHPStan analysis passed! Push proceeding..."
    echo
    exit 0
else
    exit_code=$?
    echo "----------------------------------------"
    echo "❌ PHPStan analysis failed with exit code $exit_code"
    echo
    echo "🚫 Push rejected due to static analysis errors!"
    echo
    echo "Please fix the issues reported by PHPStan before pushing."
    echo
    echo "💡 Options:"
    echo "   1. Fix the reported issues and try pushing again"
    echo "   2. Run 'make phpstan' locally to see the full output"
    echo "   3. To bypass this check temporarily: git push --no-verify"
    echo "      (⚠️  Use bypass only in emergencies!)"
    echo
    exit $exit_code
fi
EOF

# Make the hook executable
chmod +x "$PRE_PUSH_HOOK"

echo "✅ Pre-push hook installed successfully!"
echo
echo "📦 Next steps:"
echo "   1. Install dependencies: make install"
echo "   2. Test the hook: make phpstan"
echo "   3. Try pushing to trigger the hook"
echo
echo "🔧 Hook location: $PRE_PUSH_HOOK"
echo
echo "💡 To temporarily bypass the hook, use: git push --no-verify"
echo "   (Use this only in emergencies!)"
echo
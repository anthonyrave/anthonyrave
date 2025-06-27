# Git Pre-Push Hook with PHPStan Static Analysis

This repository includes a Git pre-push hook that automatically runs PHPStan static analysis before allowing code to be pushed. This ensures code quality and catches potential issues before they reach the remote repository.

## 🎯 Features

- **Automatic PHPStan Analysis**: Runs PHPStan via make command before every push
- **Clear Error Messages**: Provides detailed feedback when analysis fails
- **Emergency Bypass**: Allows bypassing the hook when necessary
- **Team Installation**: Easy setup script for entire development teams
- **Robust Error Handling**: Handles missing dependencies gracefully

## 📋 Prerequisites

Before using this pre-push hook, ensure you have:

1. **Make** - Build automation tool
   - Ubuntu/Debian: `sudo apt-get install make`
   - macOS: `xcode-select --install`
   - Windows: Install via chocolatey, scoop, or WSL

2. **Composer** - PHP dependency manager
   - Install from [getcomposer.org](https://getcomposer.org/)

3. **PHP 8.0+** - Required for PHPStan

## 🚀 Quick Setup

### Automatic Installation (Recommended)

Run the team installation script:

```bash
./install-hooks.sh
```

This script will:
- Install the pre-push hook
- Check for required dependencies
- Provide guidance for missing tools
- Backup any existing hooks

### Manual Installation

1. Copy the pre-push hook:
   ```bash
   cp .git/hooks/pre-push.sample .git/hooks/pre-push
   ```

2. Make it executable:
   ```bash
   chmod +x .git/hooks/pre-push
   ```

3. Install dependencies:
   ```bash
   make install
   ```

## 🔧 Usage

### Normal Operation

Once installed, the hook runs automatically on every `git push`:

```bash
git push origin main
```

Output example:
```
🔍 Running PHPStan static analysis before push...
Remote: origin
URL: https://github.com/user/repo.git

📋 Running: make phpstan
Installing dependencies...
Running PHPStan static analysis...
✅ PHPStan analysis passed! Push proceeding...
```

### When Analysis Fails

If PHPStan finds issues:

```
❌ PHPStan analysis failed with exit code 1
🚫 Push rejected due to static analysis errors!

Please fix the issues reported by PHPStan before pushing.

💡 Options:
   1. Fix the reported issues and try pushing again
   2. Run 'make phpstan' locally to see the full output
   3. To bypass this check temporarily: git push --no-verify
      (⚠️  Use bypass only in emergencies!)
```

### Manual Analysis

You can run PHPStan manually at any time:

```bash
# Run PHPStan analysis
make phpstan

# Install/update dependencies
make install

# View all available commands
make help
```

## 🆘 Emergency Bypass

In urgent situations, you can bypass the hook:

```bash
git push --no-verify
```

**⚠️ Warning**: Use this only in emergencies! Always fix issues and re-push properly ASAP.

## 🛠 Configuration

### PHPStan Configuration

Edit `phpstan.neon` to customize analysis:

```yaml
parameters:
    level: 5                          # Analysis level (0-9)
    paths:
        - src                         # Directories to analyze
    checkMissingIterableValueType: false
    reportUnmatchedIgnoredErrors: false
```

### Makefile Targets

The `Makefile` includes these targets:

- `make phpstan` - Run PHPStan analysis
- `make install` - Install dependencies
- `make test` - Run all tests including PHPStan
- `make clean` - Clean generated files
- `make help` - Show available commands

## 🔄 Team Workflow

### For New Team Members

1. Clone the repository
2. Run the installation script: `./install-hooks.sh`
3. Install dependencies: `make install`
4. Start developing with automatic quality checks!

### For Existing Projects

1. Add the pre-push hook files to your repository
2. Update your `Makefile` to include a `phpstan` target
3. Add `phpstan.neon` configuration
4. Run `./install-hooks.sh` on each development machine

## 🐛 Troubleshooting

### Common Issues

**"make command not found"**
```bash
# Install make for your system
sudo apt-get install make  # Ubuntu/Debian
# or
xcode-select --install     # macOS
```

**"composer command not found"**
- Install Composer from [getcomposer.org](https://getcomposer.org/)

**"Makefile not found"**
- Ensure you're in the repository root
- Check that `Makefile` exists and contains `phpstan` target

**"Dependencies not installed"**
```bash
make install
```

### Hook Not Working

1. Check hook is executable:
   ```bash
   ls -la .git/hooks/pre-push
   ```

2. Verify hook content matches expected script

3. Test manually:
   ```bash
   .git/hooks/pre-push origin https://github.com/user/repo.git
   ```

### Disable Hook Temporarily

```bash
# Rename to disable
mv .git/hooks/pre-push .git/hooks/pre-push.disabled

# Restore to re-enable
mv .git/hooks/pre-push.disabled .git/hooks/pre-push
```

## 📊 Integration with CI/CD

This pre-push hook complements CI/CD pipelines by catching issues early:

1. **Local Development** → Pre-push hook catches issues
2. **CI/CD Pipeline** → Additional checks and tests
3. **Production** → Clean, analyzed code

## 🤝 Contributing

When contributing to projects with this hook:

1. Always run `make phpstan` before committing
2. Fix any reported issues
3. Only use `--no-verify` in genuine emergencies
4. Document any new PHPStan rules or exceptions

## 📝 License

This pre-push hook implementation is provided as-is for development teams to improve code quality through automated static analysis.
# tpatrouillat/tap — Homebrew formulae

Personal Homebrew tap. Install any formula in this tap with:

```bash
brew install tpatrouillat/tap/<formula-name>
```

## Formulae

### `claude-usage-tracker`

macOS menu bar app showing your Claude Code 5-hour, weekly, Sonnet, and Opus usage limits in real time. [Project repo →](https://github.com/tpatrouillat/claude-usage-tracker)

```bash
brew install tpatrouillat/tap/claude-usage-tracker
claude-usage-tracker                                    # launch
brew services start claude-usage-tracker                # auto-start at login
```

Until v1.0.0 is tagged, install from the `main` branch:

```bash
brew install --HEAD tpatrouillat/tap/claude-usage-tracker
```

## Releasing a new formula version

When you tag a new release in `claude-usage-tracker`:

```bash
./bin/update-sha256.sh claude-usage-tracker v1.0.0
git commit -am "claude-usage-tracker: v1.0.0"
git push
```

Users then get the new version with `brew upgrade claude-usage-tracker`.

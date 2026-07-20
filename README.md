# tpatrouillat/tap — Homebrew formulae

Personal Homebrew tap. Install any formula in this tap with:

```bash
brew install tpatrouillat/tap/<formula-name>
```

## Formulae

### `tokease`

macOS menu bar app showing your Claude 5-hour and weekly limits in real time, as two rings. Zero config with the Claude desktop app, optional Claude Code statusline capture for reset countdowns. Never reads your token. [Project repo →](https://github.com/tpatrouillat/tokease)

```bash
brew install tpatrouillat/tap/tokease
tokease                                    # launch
brew services start tokease                # auto-start at login
```

Until v1.0.0 is tagged, install from the `main` branch:

```bash
brew install --HEAD tpatrouillat/tap/tokease
```

## Releasing a new formula version

When you tag a new release in `tokease`:

```bash
./bin/update-sha256.sh tokease v1.0.0
git commit -am "tokease: v1.0.0"
git push
```

Users then get the new version with `brew upgrade tokease`.

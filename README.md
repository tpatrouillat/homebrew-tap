# tpatrouillat/tap — Homebrew formulae

Personal Homebrew tap. Install any formula in this tap with:

```bash
brew install tpatrouillat/tap/<formula-name>
```

## Formulae

### `tokease`

macOS menu bar app showing your Claude 5-hour and weekly limits as two rings. Readings refresh every 5 to 15 minutes while the Claude desktop app runs, and a reading older than 20 minutes is flagged rather than shown as live. Requires a Claude Pro or Max plan. Zero config with the Claude desktop app, optional Claude Code statusline capture for reset countdowns. Never reads your token. [Project repo →](https://github.com/tpatrouillat/tokease)

```bash
brew install tpatrouillat/tap/tokease
tokease                                    # launch
brew services start tokease                # auto-start at login
```

To track the development branch instead of the latest release:

```bash
brew install --HEAD tpatrouillat/tap/tokease
```

## Releasing a new formula version

When you tag a new release in `tokease`:

```bash
./bin/update-sha256.sh tokease vX.Y.Z
git commit -am "tokease: vX.Y.Z"
git push
```

Users then get the new version with `brew upgrade tokease`.

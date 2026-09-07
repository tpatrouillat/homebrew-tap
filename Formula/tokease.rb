class Tokease < Formula
  desc "Menu bar app showing your Claude Pro/Max 5-hour and weekly limits (token-free)"
  homepage "https://github.com/tpatrouillat/tokease"
  url "https://github.com/tpatrouillat/tokease/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "7812fa41022db6abc72518f5a8194926eeb3c3b24118c25dd900e93bb531f6ee"
  license "MIT"
  head "https://github.com/tpatrouillat/tokease.git", branch: "main"

  depends_on macos: :monterey
  # 3.12 (not 3.13): safer wheels for rumps 0.4.0 / Pillow; the code targets py3.10+.
  depends_on "python@3.12"

  def install
    # Allowlist: do not ship tests/, docs/, venv/, graphify-out/...
    # uninstall.sh ships so brew users can clean ~/.tokease + statusline wiring
    # (brew uninstall alone only removes the Cellar files).
    libexec.install "tracker.py", "assets", "statusline", "uninstall.sh"
    venv = libexec/"venv"
    system formula_opt_bin("python@3.12")/"python3.12", "-m", "venv", venv

    # Hash-pinned: pip checks each wheel's sha256 against these before installing,
    # so PyPI serving a different artifact under the same version can't slip in
    # silently. Two Pillow hashes cover both macOS wheel architectures (arm64 +
    # x86_64); pyobjc-core/pyobjc-framework-Cocoa ship one universal2 wheel each.
    # Regenerate with `pip install <pkg>==<version> --dry-run --report -` on both
    # a Python 3.12 venv and cross-check the other arch's wheel via
    # `curl https://pypi.org/pypi/<pkg>/<version>/json`.
    (buildpath/"tokease-formula-requirements.txt").write <<~REQ
      rumps==0.4.0 \\
          --hash=sha256:17fb33c21b54b1e25db0d71d1d793dc19dc3c0b7d8c79dc6d833d0cffc8b1596
      Pillow==12.3.0 \\
          --hash=sha256:ffd0c5368496f41b0944be820fcb7a838aa6e623d250b01acf2643939c3f99d7 \\
          --hash=sha256:ba09209fbe443b4acccebe845d8a138b89a8f4fbaeedd44953490b5315d5e965
      pyobjc-framework-Cocoa==12.2.2 \\
          --hash=sha256:e106f395531e67694376b0f1184612cbeea3ec8b9bf56b55ef41d026171d2a2d
      pyobjc-core==12.2.2 \\
          --hash=sha256:122e6ad302a2abf5d4d4adb0156db751600ddf2768441696cba17b31323085e7
    REQ
    system venv/"bin/pip", "install", "--quiet", "--require-hashes", "-r",
           buildpath/"tokease-formula-requirements.txt"

    (bin/"tokease").write <<~SH
      #!/bin/bash
      exec "#{venv}/bin/python" "#{libexec}/tracker.py" "$@"
    SH
  end

  service do
    run [opt_bin/"tokease"]
    run_at_load true
    keep_alive false
  end

  def caveats
    <<~EOS
      Start the app:
        brew services start tokease

      Requires a Claude Pro or Max plan: Free and Team/Enterprise accounts
      expose no quota feeds, so Tokease has nothing to display there.

      Zero config: if the Claude desktop app is running, Tokease auto-detects
      the quota history it refreshes every 5 to 15 minutes.

      Optional, for reset countdowns: wire the Claude Code (>= 2.1.x)
      statusline capture once with
        #{opt_libexec}/statusline/install-statusline.sh
      Statusline data appears after the first Claude reply in a session.

      To remove everything later (data + statusline wiring, then the app):
        bash #{opt_libexec}/uninstall.sh && brew uninstall tokease
    EOS
  end

  test do
    assert_path_exists bin/"tokease"
    assert_path_exists libexec/"tracker.py"
    assert_path_exists libexec/"statusline/tokease-statusline.py"
    # No Intel CI runner for this tap: this is what actually catches a wrong
    # x86_64 wheel hash on a real Intel install, not just a file existing.
    system libexec/"venv/bin/python3", "-c", "import rumps, PIL"
  end
end

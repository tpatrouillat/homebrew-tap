class Tokease < Formula
  desc "Menu bar app showing your Claude Pro/Max 5-hour and weekly limits (token-free)"
  homepage "https://github.com/tpatrouillat/tokease"
  url "https://github.com/tpatrouillat/tokease/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "fdf17e4a2326d78f81cad832b6d9846f9471d80e3e4fbb5e9ff40c30ed50ac02"
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
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", venv
    system venv/"bin/pip", "install", "--quiet", "rumps==0.4.0", "Pillow>=10.0.0"

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
      the quota history it refreshes about every 5 minutes.

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
  end
end

class ClaudeUsageTracker < Formula
  desc "macOS menu bar app showing your Claude Code usage limits"
  homepage "https://github.com/tpatrouillat/claude-usage-tracker"
  url "https://github.com/tpatrouillat/claude-usage-tracker/archive/refs/tags/v1.0.0.tar.gz"
  # Update after tagging v1.0.0: see ../bin/update-sha256.sh
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"
  head "https://github.com/tpatrouillat/claude-usage-tracker.git", branch: "main"

  depends_on macos: :monterey
  depends_on "python@3.13"

  def install
    libexec.install Dir["*"]
    venv = libexec/"venv"
    system Formula["python@3.13"].opt_bin/"python3.13", "-m", "venv", venv
    system venv/"bin/pip", "install", "--quiet", "rumps==0.4.0"

    (bin/"claude-usage-tracker").write <<~SH
      #!/bin/bash
      exec "#{venv}/bin/python" "#{libexec}/tracker.py" "$@"
    SH
  end

  service do
    run [opt_bin/"claude-usage-tracker"]
    run_at_load true
    keep_alive false
  end

  test do
    assert_path_exists bin/"claude-usage-tracker"
  end
end

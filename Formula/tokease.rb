class Tokease < Formula
  desc "macOS menu bar app showing your Claude Code rate limits (statusline, token-free)"
  homepage "https://github.com/tpatrouillat/tokease"
  # NOTE: v1.0.0 is NOT tagged yet — it ships only after the user E2E test passes
  # (cf. PLAN-TEST-E2E). The url/sha256 below are placeholders; until then, install
  # from main with: brew install --HEAD tpatrouillat/tap/tokease
  url "https://github.com/tpatrouillat/tokease/archive/refs/tags/v1.0.0.tar.gz"
  # TODO: regenerate sha256 + tag v1.0.0 via ../bin/update-sha256.sh AFTER E2E validation
  # (cf. PLAN-TEST-E2E). Do NOT publish a real sha256 / tag before the test passes.
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"
  head "https://github.com/tpatrouillat/tokease.git", branch: "main"

  depends_on macos: :monterey
  # 3.12 (pas 3.13) : roues rumps 0.4.0 / Pillow plus sûres ; le code cible py3.10+.
  depends_on "python@3.12"

  def install
    # Liste blanche : ne pas embarquer tests/, docs/, venv/, graphify-out/…
    libexec.install "tracker.py", "assets", "statusline"
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

  test do
    assert_path_exists bin/"tokease"
  end
end

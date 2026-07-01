class LogseqNightlyDownloadStrategy < CurlDownloadStrategy
  ASSETS_URL = "https://github.com/logseq/logseq/releases/expanded_assets/nightly".freeze

  def initialize(url, name, version, **meta)
    arch = url[%r{/Logseq-darwin-(arm64|x64)-latest\.dmg\z}, 1]
    if arch.nil?
      raise CurlDownloadStrategyError.new(url, "Cannot determine Logseq architecture from placeholder URL.")
    end

    html = ::Utils::Curl.curl_output("--fail", "--location", ASSETS_URL).stdout
    asset_regex = %r{
      href="(/logseq/logseq/releases/download/nightly/Logseq-darwin-#{arch}-[^"]*nightly\.\d{8}\.dmg)"
    }x
    href = html[asset_regex, 1]
    raise CurlDownloadStrategyError.new(ASSETS_URL, "Cannot find Logseq nightly macOS #{arch} DMG.") if href.nil?

    super("https://github.com#{href}", name, version, **meta)
  end
end

cask "logseq@nightly" do
  arch arm: "arm64", intel: "x64"

  version :latest
  sha256 :no_check

  url "https://github.com/logseq/logseq/releases/download/nightly/Logseq-darwin-#{arch}-latest.dmg",
      using: LogseqNightlyDownloadStrategy
  name "Logseq Nightly"
  desc "Nightly DB build of the Logseq desktop app"
  homepage "https://github.com/logseq/logseq"

  conflicts_with cask: "logseq"
  depends_on macos: :monterey

  app "Logseq.app"

  zap trash: [
    "~/Library/Application Support/Logseq",
    "~/Library/Logs/Logseq",
    "~/Library/Preferences/com.electron.logseq.plist",
    "~/Library/Saved Application State/com.electron.logseq.savedState",
  ]

  caveats <<~EOS
    This installs Logseq's unstable DB/nightly build. Back up graphs before
    opening them with this version.

    To include this moving nightly cask when running plain `brew upgrade`, add
    this to your shell profile:

      export HOMEBREW_UPGRADE_GREEDY_CASKS="logseq@nightly"

    If you already use HOMEBREW_UPGRADE_GREEDY_CASKS, add logseq@nightly to
    its space-separated cask list.
  EOS
end

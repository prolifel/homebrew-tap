class Klipi < Formula
  desc "Lightweight clipboard manager for macOS"
  homepage "https://github.com/prolifel/klipi"
  url "https://github.com/prolifel/klipi/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "06de60e9d68e3a819dbdef93da7fdd33671b449f81df2bb91c930facf976ecdb"
  license "MIT"
  head "https://github.com/prolifel/klipi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on xcode: ["15.0", :build]

  def install
    xcodebuild "-project", "Klipi.xcodeproj",
           "-scheme", "Klipi",
           "-configuration", "Release",
           "-derivedDataPath", "build",
           "CODE_SIGN_IDENTITY=-",
           "CODE_SIGNING_REQUIRED=NO",
           "CODE_SIGNING_ALLOWED=NO"

    app_bundle = buildpath/"build/Build/Products/Release/Klipi.app"
    prefix.install app_bundle

    (bin/"klipi-uninstall").write <<~BASH
      #!/bin/bash
      set -e
      echo "Removing Klipi from Applications..."
      rm -f /Applications/Klipi.app
      echo "Running brew uninstall..."
      brew uninstall prolifel/tap/klipi
      echo "Klipi has been uninstalled."
    BASH
  end

  def postflight
    return unless File.exist?(prefix/"Klipi.app")

    app_link = "/Applications/Klipi.app"
    rm(app_link)
    ln_sf(prefix/"Klipi.app", app_link)
  rescue
    # to caveat
  end

  def caveats
    s = "Klipi has been installed to #{prefix}/Klipi.app\n\n"

    if File.symlink?("/Applications/Klipi.app")
      s += "A symlink has been created in /Applications.\n\n"
    else
      s += "#{Tty.yellow}Could not create symlink in /Applications.#{Tty.reset}\n"
      s += "To add to Applications manually, run:\n"
      s += "  ln -sf #{prefix}/Klipi.app /Applications/Klipi.app\n\n"
    end

    s += "#{Tty.green}==> IMPORTANT: Grant Input Monitoring permission!#{Tty.reset}\n"
    s += "    Without this permission, Klipi cannot monitor keyboard shortcuts.\n\n"
    s += "    Steps to enable:\n"
    s += "      1. Open System Settings → Privacy & Security → Input Monitoring\n"
    s += "      2. Click the + button\n"
    s += "      3. Navigate to /Applications/Klipi.app and select it\n"
    s += "      4. Restart Klipi\n\n"
    s += "To uninstall: run #{Tty.blue}klipi-uninstall#{Tty.reset}\n"
    s
  end

  test do
    assert_path_exists prefix/"Klipi.app"
  end
end

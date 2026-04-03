cask "klipi" do
  version "1.0.13"
  sha256 "<REPLACE_WITH_ACTUAL_SHA256>"

  url "https://github.com/prolifel/klipi/releases/download/v\#{version}/Klipi-\#{version}.dmg"
  name "Klipi"
  desc "Lightweight clipboard manager for menu bar"
  homepage "https://github.com/prolifel/klipi"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Klipi.app"

  caveats do
    s = "Klipi has been installed to \#{appdir}/Klipi.app\n\n"

    if File.symlink?("/Applications/Klipi.app")
      s += "A symlink has been created in /Applications.\n\n"
    else
      s += "\e[33mCould not create symlink in /Applications.\e[0m\n"
      s += "To add to Applications manually, run:\n"
      s += "  ln -sf \#{appdir}/Klipi.app /Applications/Klipi.app\n\n"
    end

    s += "\e[32m==> IMPORTANT: Grant Input Monitoring permission!\e[0m\n"
    s += "    Without this permission, Klipi cannot monitor keyboard shortcuts.\n\n"
    s += "    Steps to enable:\n"
    s += "      1. Open System Settings → Privacy & Security → Input Monitoring\n"
    s += "      2. Click the + button\n"
    s += "      3. Navigate to /Applications/Klipi.app and select it\n"
    s += "      4. Restart Klipi\n\n"
    s += "To uninstall: run \e[34mklipi-uninstall\e[0m\n"
    s
  end

  postflight do
    app_link = "/Applications/Klipi.app"
    FileUtils.rm_f(app_link)
    FileUtils.ln_sf(appdir/"Klipi.app", app_link)
  end

  uninstall quit: "com.klipi.app"

  uninstall_script: {
    executable: "klipi-uninstall",
    script: <<~BASH
      #!/bin/bash
      set -e
      echo "Removing Klipi from Applications..."
      rm -f /Applications/Klipi.app
      echo "Running brew uninstall..."
      brew uninstall --cask prolifel/homebrew-tap/klipi
      echo "Klipi has been uninstalled."
    BASH
  }

  zap trash: [
    "~/Library/Application Support/Klipi",
    "~/Library/Preferences/com.klipi.app.plist",
  ]
end

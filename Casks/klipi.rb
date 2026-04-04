cask "klipi" do
  version "1.0.16"
  sha256 "e4746ab45ea29db24fb4ea5e42d26df3d5e97b341cbd84a75cd3486c586fc29b"

  url "https://github.com/prolifel/klipi/releases/download/v#{version}/Klipi-v#{version}.dmg"
  name "Klipi"
  desc "Lightweight clipboard manager for menu bar"
  homepage "https://github.com/prolifel/klipi"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Klipi.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-rd", "com.apple.quarantine", "#{appdir}/Klipi.app"],
                   sudo: true
  end

  uninstall quit: "com.klipi.app"

  zap trash: [
    "~/Library/Application Support/Klipi",
    "~/Library/Preferences/com.klipi.app.plist",
  ]

  caveats do
    s = "Klipi has been installed to #{appdir}/Klipi.app\n\n"

    s += "\e[32m==> IMPORTANT: Grant Input Monitoring permission!\e[0m\n"
    s += "    Without this permission, Klipi cannot monitor keyboard shortcuts.\n\n"
    s += "    Steps to enable:\n"
    s += "      1. Open System Settings → Privacy & Security → Input Monitoring\n"
    s += "      2. Click the + button\n"
    s += "      3. Navigate to /Applications/Klipi.app and select it\n"
    s += "      4. Restart Klipi\n\n"
    s
  end
end

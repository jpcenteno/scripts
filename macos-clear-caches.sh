#! /bin/sh

## Schedules a Launch Agent that clears the cache once per week.
## Usage:
## macos-clear-cache install   -- Set's up a job that clears cache on mondays.
## macos-clear-cache uninstall -- Removes the job if installed.

set -eu

agent_name="jpcenteno.clear_mac_caches"
agent_filename="${HOME}/Library/LaunchAgents/${agent_name}.plist"

__install() {
    cat <<EOF > "${agent_filename}"
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>${agent_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>rm</string>
            <string>-rf</string>
            <string>${HOME}/Library/Caches</string>
        </array>
        <key>StartCalendarInterval</key>
        <dict>
            <key>Weekday</key>
            <integer>1</integer> <!-- Every Monday -->
            <key>Hour</key>
            <integer>12</integer>
            <key>Minute</key>
            <integer>0</integer>
        </dict>
    </dict>
    </plist>
EOF

    launchctl load "${agent_filename}"
    launchctl start "${agent_name}"
}


__uninstall() {
    launchctl remove "${agent_name}"
    rm -rf "${agent_filename}"
}

__help() {
    cat <<EOF
Schedules a Launch Agent that clears the cache once per week.
Usage:
macos-clear-cache install   -- Set's up a job that clears cache on mondays.
macos-clear-cache uninstall -- Removes the job if installed.
EOF
    exit 1
}

case "${1:-}" in
    install ) __install;;
    uninstall ) __uninstall;;
    *) __help;;
esac

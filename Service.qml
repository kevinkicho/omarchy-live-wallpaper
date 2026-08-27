import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  // Injected by omarchy-shell (the first-party service loader).
  property var shell: null

  readonly property string launcher: "$HOME/.config/omarchy/plugins/live-ttfx-wallpaper/bin/omarchy-launch-wallpaper-screensaver"

  function runCommand(process, command) {
    if (process.running)
      return false
    process.command = ["bash", "-lc", command]
    process.running = true
    return true
  }

  // Start only when nothing is already on the background layer so enabling
  // the plugin does not flicker a wallpaper that Hyprland autostart already
  // launched.
  function startIfNeeded() {
    runCommand(launchProcess, "pgrep -f '[o]rg.omarchy.wallpaper-screensaver' >/dev/null || " + root.launcher)
  }

  function restart() {
    runCommand(launchProcess, root.launcher)
  }

  function start() {
    runCommand(launchProcess, root.launcher)
  }

  function stop() {
    runCommand(stopProcess, root.launcher + " --stop")
  }

  Process {
    id: launchProcess
  }

  Process {
    id: stopProcess
  }

  Process {
    id: statusProcess
    command: ["bash", "-lc", "if pgrep -f '[o]rg.omarchy.wallpaper-screensaver' >/dev/null; then echo running; else echo stopped; fi"]
    stdout: StdioCollector {
      id: statusStdout
      waitForEnd: true
    }
  }

  Component.onCompleted: {
    startIfNeeded()
    if (!statusProcess.running)
      statusProcess.running = true
  }

  IpcHandler {
    target: "live-ttfx-wallpaper"

    function status(): string {
      return statusStdout.text ? String(statusStdout.text).trim() : "unknown"
    }

    function refresh(): string {
      if (!statusProcess.running)
        statusProcess.running = true
      return "ok"
    }

    function start(): string {
      root.start()
      return "ok"
    }

    function restart(): string {
      root.restart()
      return "ok"
    }

    function stop(): string {
      root.stop()
      return "ok"
    }
  }
}

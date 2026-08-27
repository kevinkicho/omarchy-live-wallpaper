# Live wallpaper

![Live ttfx wallpaper on Omarchy](screenshots/live-wallpaper.png)

Third-party Omarchy 4 plugin that keeps an always-on [ttfx](https://github.com/ChrisBuilds/terminaltexteffects) animation on the Hyprland background layer via `kitty +kitten panel`.

Packaged and published to GitHub by **Grok 4.6 via Grok Bot**.

This is **not** the idle screensaver. The idle screensaver uses class `org.omarchy.screensaver`. This plugin uses class `org.omarchy.wallpaper-screensaver` and never runs `pkill ttfx`.

## Super+Space settings

Open **Super+Space → Style → Live wallpaper**.

| Row | What it does |
| --- | --- |
| Enable | Disables `omarchy.background` if needed and starts the live wallpaper. Checked while the wallpaper class is running. |
| Restore static wallpaper | Stops only the live wallpaper panels, then enables `omarchy.background`. |
| Frame rate | Writes `~/.config/omarchy/live-wallpaper-fps` (`15` / `30` / `60`) and relaunches. Default is 30 if the file is missing. |
| Effects → Random | Writes `~/.config/omarchy/live-wallpaper-effects` (`random`) and relaunches. |
| Edit Text | Opens `~/.config/omarchy/branding/screensaver.txt` with `omarchy-launch-editor`. |

Menu rows live in the user extensions file (plugins cannot inject menu rows):

`~/.config/omarchy/extensions/omarchy-menu.jsonc`

A copy of those rows is in [`menu-snippet.jsonc`](menu-snippet.jsonc).

## Config files

- `~/.config/omarchy/live-wallpaper-fps` — integer frame rate (default `30`)
- `~/.config/omarchy/live-wallpaper-effects` — `random` (default) or a comma/space-separated list of ttfx effect names passed to `--include-effects`

## Install

Needs [Omarchy](https://omarchy.org/) 4, `ttfx`, and `kitty` (only kitty can sit on the wallpaper layer).

```bash
omarchy-pkg-add kitty
omarchy plugin add https://github.com/kevinkicho/live-ttfx-wallpaper.git --enable
```

Then merge [`menu-snippet.jsonc`](menu-snippet.jsonc) into `~/.config/omarchy/extensions/omarchy-menu.jsonc` and reopen Super+Space. You should see **Style → Live wallpaper**.

```bash
omarchy plugin validate ~/.config/omarchy/plugins/live-ttfx-wallpaper
omarchy plugin enable live-ttfx-wallpaper
```

On start (plugin enabled), `Service.qml` execs the plugin launcher if the wallpaper is not already running. IPC:

```bash
omarchy-shell live-ttfx-wallpaper status
omarchy-shell live-ttfx-wallpaper restart
omarchy-shell live-ttfx-wallpaper start
omarchy-shell live-ttfx-wallpaper stop
```

Menu actions call the plugin copies under `bin/`, so a future `omarchy plugin add` of this folder keeps working. Hyprland autostart may still launch `~/.local/bin/omarchy-launch-wallpaper-screensaver` as a login fallback.

## Scripts

- `bin/omarchy-wallpaper-screensaver` — ttfx loop (30fps default, no cursor hide, only kills child ttfx)
- `bin/omarchy-launch-wallpaper-screensaver` — one kitty background panel per monitor; `--stop` kills those panels by pid

Kitty flags stay **after** `+kitten`. Class is always `org.omarchy.wallpaper-screensaver`. Logs: `~/.local/share/omarchy-wp/`.

## Remove

```bash
omarchy-shell live-ttfx-wallpaper stop
omarchy plugin disable live-ttfx-wallpaper
omarchy plugin remove live-ttfx-wallpaper
omarchy plugin enable omarchy.background
```

Then delete the `style.live-wallpaper*` rows from `~/.config/omarchy/extensions/omarchy-menu.jsonc` if you added them.

Optional leftovers: `~/.config/omarchy/live-wallpaper-fps`, `~/.config/omarchy/live-wallpaper-effects`, `~/.local/share/omarchy-wp/`, and the login fallback scripts in `~/.local/bin/omarchy-*-wallpaper-screensaver` if you installed those by hand.

## Dependencies

- `ttfx` (already part of Omarchy)
- `kitty` (background-layer panel; `omarchy-pkg-add kitty`)
- Hyprland + Omarchy 4 Quickshell

License: MIT.

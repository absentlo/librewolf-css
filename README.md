# Graphite LibreWolf

A minimal gray theme and customizable new tab page for LibreWolf, built for low-spec PCs: no animations, no background code, and no network use unless you turn it on.

> **Version 0.5: early testing.** Expect rough edges and changes.

![LibreWolf with the Graphite theme and start page](screenshots/start-page.png)

![The customize panel](screenshots/customize.png)

## Install

You need LibreWolf opened at least once, plus [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) (on Arch: `sudo pacman -S ttf-jetbrains-mono-nerd`).

**1. Install the theme**

```sh
git clone https://github.com/absentlo/librewolf-css.git
cd librewolf-css
./install.sh
```

Restart LibreWolf. The script backs up your existing `user.js` and `chrome` folder first. With several profiles it asks which one to use, and `about:profiles` shows the one in use.

**2. Install the start page**

The add-on is signed by Mozilla, so it needs no changes in `about:config`.

1. Download `graphite-start.xpi` from the newest version on [Releases](https://github.com/absentlo/librewolf-css/releases).
2. Open `about:addons`, click the gear, and choose **Install Add-on From File**.
3. Pick the file and click **Add**.

**3. Customize it**

Open a new tab and click the pencil in the bottom-right corner.

For private windows too: in `about:addons`, open **Graphite Start** and set **Run in Private Windows** to **Allow**.

> **Firefox:** the add-on needs version 140 or newer, but only LibreWolf 159 has been tested.

## What the pencil panel does

- **Sections:** show or hide the logo, clock, date, search, pages and weather.
- **Clock:** 12 or 24 hour, three sizes, your time zone, and your name in the greeting.
- **Search:** six engines, each with its logo in gray.
- **Weather:** your city in °C or °F, with icons for the conditions and for day or night.
- **Wallpaper:** your own image, with a darkness slider. It's resized to 1920 px wide to keep new tabs fast, and animated images become still.
- **My pages and Most visited:** gray logos, custom names and logo-only buttons. Set how many show per page, then browse with the arrows, the mouse wheel or the left and right keys.
- **Backup:** export and import all of this as one file.

## New profile? Your theme is gone

Your theme lives **inside the profile folder**, and a new profile starts empty. To bring everything back:

1. In the old profile, open the panel and click **export**.
2. Open the new profile once, close it, and run `./install.sh`.
3. Install the start page again (step 2 above), then click **import**.
4. Tick **Weather**, **Page icons** and **Most visited** again, since permissions don't carry over.

The backup holds your wallpaper and page addresses in plain text, so keep it private.

Don't copy a whole profile folder: the browser can end up pointing at the copy instead of your real profile.

## Change things

- **Colors:** the variables at the top of `userChrome.css` and of `startpage/newtab.css`.
- **Font:** `--g-font` in `userChrome.css`.
- **Window buttons:** on a tiling window manager such as i3 or sway, uncomment the marked block in `userChrome.css` to hide them.
- **Preferences:** `user.js` has a comment on every setting. If you delete a line, also reset that setting in `about:config`.
- **Video:** `user.js` turns off AV1, which helps most older PCs. If your GPU decodes AV1, delete that line and reset the setting.
- **The start page's code:** raise `version` in `startpage/manifest.json` and run `./install.sh --build-addon` (needs `zip`). Your build is unsigned, so installing it needs `xpinstall.signatures.required` set to `false` in `about:config`, which lets LibreWolf install any unsigned add-on.

**Before updating the add-on,** keep a normal website tab open. Updating closes the start page's tabs, and if they're the only ones open, the window closes too.

## Privacy

These are all off until you turn them on, and LibreWolf asks your permission first for Weather and Page icons.

| Option | What it contacts | What that sees |
|---|---|---|
| Weather | [Open-Meteo](https://open-meteo.com/) | Your IP address and city, at most every 30 minutes |
| Page icons | DuckDuckGo's icon service | Your IP address and the site's name, once per site |
| Most visited | Nothing | Your history is read locally, with your permission |

Searches go to the engine you pick. Nothing else on the page uses the network.

## Problems

- **No theme:** check that `toolkit.legacyUserProfileCustomizations.stylesheets` is `true` and that you installed into the profile in use.
- **Something broke after a browser update:** updates can rename what the theme targets. Set `devtools.chrome.enabled` to `true`, then press `Ctrl+Alt+Shift+I` to inspect the browser.
- **Wrong time:** type your zone in **Time zone**, such as `Europe/Berlin`.
- **A setting keeps coming back:** `user.js` reapplies at every start, so change it there.

## Uninstall

Remove the add-on from `about:addons`, which deletes its settings. Then delete `user.js` and `chrome` from the profile folder, or restore your `.bak-` copies, and reset any settings you want back in `about:config`.

## License

MIT, see [LICENSE](LICENSE). The logos and some icons belong to others, see [THIRD-PARTY-NOTICES](THIRD-PARTY-NOTICES).

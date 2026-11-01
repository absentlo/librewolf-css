# Graphite LibreWolf: developer mini guide

## Where things live

| Path | What it is | Needs signing? |
|---|---|---|
| `profile/user.js` | Browser settings | No |
| `profile/chrome/*.css` | Theme for the browser and `about:` pages | No |
| `startpage/` | The new tab add-on | **Yes** |
| `dist/` | Built add-on, ignored by git | n/a |
| `screenshots/` | Photos for the README | No |

The browser uses copies in your profile, so edits in the repo do nothing until you install them.

## 1. Make a test profile (once)

This keeps your real profile safe:

```sh
mkdir -p ~/graphite-dev/profile
```

## 2. Edit and try it

**Theme or settings:** close the test window, then run:

```sh
./install.sh --profile ~/graphite-dev/profile
librewolf --new-instance --profile ~/graphite-dev/profile
```

Repeat this after each change.

**Add-on:** in the test window, open `about:debugging`, go to **This LibreWolf/Firefox** and click **Load Temporary Add-on**, then pick `startpage/manifest.json`. It needs no signing and disappears when the browser restarts.

## 3. Publish

**Only the theme, settings or README changed:**

```sh
git add -A
git commit -m "What changed"
git push origin main
```

You don't need Mozilla for this. Theme users get it with `git pull` and `./install.sh`.

**The add-on changed:**

1. Raise `version` in `startpage/manifest.json`.
2. Commit, tag and push:
   ```sh
   git add -A
   git commit -m "Release vX.Y.Z"
   git tag vX.Y.Z
   git push origin main --tags
   ```
3. Build and check it. The one Android warning is fine:
   ```sh
   ./install.sh --build-addon --profile ~/graphite-dev/profile
   npx addons-linter dist/graphite-start.xpi
   ```
4. Upload `dist/graphite-start.xpi` as a new version on the [Mozilla developer page](https://addons.mozilla.org/developers/addons). Answer **No** to the source code question.
5. Download the signed file with right-click and **Save Link As**, and name it exactly `graphite-start.xpi`.
6. Check it. The first command should print a number above 0, and the second the new version:
   ```sh
   unzip -l graphite-start.xpi | grep -c META-INF
   unzip -p graphite-start.xpi manifest.json | grep '"version"'
   ```
7. Create the `vX.Y.Z` GitHub release and attach that file.
8. Install it in your own browser from `about:addons`, with a normal website tab open.

## 4. Sync your dotfiles (your PC only)

Copy the changes into your real profile first, because `dotfiles-sync` reads your live files, including `~/.config/graphite-startpage`. Then:

```sh
dotfiles-sync
cd ~/dotfiles
git add librewolf startpage
git commit -m "What changed"
git push origin main
```

## Rules that prevent problems

- **Version numbers:** Mozilla accepts each number only once, so any later change needs a new one.
- **Signing:** the file in `dist/` is unsigned until you replace it. Always attach Mozilla's signed copy to releases, including when you make a new release for a theme-only change.
- **Rebuilding:** `--build-addon` overwrites whatever is in `dist/`, including a signed file.
- **Settings:** if you delete a line from `user.js`, also reset that setting in `about:config`, because the old value stays in the profile.
- **Back up first:** removing the add-on deletes its settings, so click **export** in the panel beforehand. Updating it should keep them.
- **Profile folders:** don't copy a whole profile, because the browser can start pointing at the copy.
- **Browser updates:** they can rename what the CSS targets. To inspect the browser, set `devtools.chrome.enabled` to `true` and press `Ctrl+Alt+Shift+I`.

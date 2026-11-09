# Various snippets

## lazygit

- Fix the ? shown on the branch on lazygit on the dotfiles bare repo

```sh
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch origin
git branch --set-upstream-to=origin/main main
```

## Lutris + Warcraft III: Reforged on Arch Linux (Flatpak / Pure 64-Bit)

> **Future Note / Validation Check:**
> Before following this guide years down the road, paste this text to Gemini to check:
>
> 1. If Battle.net still suffers from the Wine `crypt32` / VPN bug or if standard Wine runners run it natively now.
> 2. If modern Flatpak / Arch session managers still require manual `$XDG_DATA_DIRS` exports for user-level flatpaks.
> 3. If Lutris or Battle.net installer scripts changed runner defaults.

---

### Step 0: Clean Slate (Purge Old Native / Pacman Artifacts)

Run this only if cleaning up a previous native `pacman` installation to ensure no stale prefixes or dead desktop entries remain:

```bash
# 1. Remove previous Wine prefixes and game installations
rm -rf ~/Games/battlenet ~/Games/warcraft-iii

# 2. Wipe old native Lutris configs, databases, and Lutris-specific cache
rm -rf ~/.config/lutris ~/.local/share/lutris ~/.cache/lutris

# 3. Clean up stale .desktop launchers and icons from native runs
rm -f ~/.local/share/applications/*lutris*
rm -f ~/.local/share/applications/*battle-net*
rm -f ~/.local/share/applications/*warcraft*
rm -f ~/.local/share/icons/hicolor/*/apps/*lutris*
rm -f ~/.local/share/icons/hicolor/*/apps/*battle-net*
rm -f ~/.local/share/icons/hicolor/*/apps/*warcraft*

# 4. Optional: Purge unused runners/wrappers if not using Steam
rm -rf ~/.local/share/umu
# (Do NOT touch ~/.local/share/Steam or ~/.steam if you play Steam games!)

```

---

### Step 1: Install Flatpak & Add Flathub

Keep Arch pure 64-bit without enabling `[multilib]`:

```bash
sudo pacman -S flatpak
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

```

_Verification:_ Run `flatpak remotes` — ensure `flathub` appears in the user list.

---

### Step 2: Configure Desktop Integration for Fuzzel (`$XDG_DATA_DIRS`)

Launchers like `fuzzel` inspect `$XDG_DATA_DIRS` to populate their menu. User-level Flatpak desktop files live in `~/.local/share/flatpak/exports/share/applications`.

To make Flatpak desktop entries visible across your entire session, pick **one** of the methods below:

#### Option A: Via `uwsm` (Recommended for Wayland sessions)

All session environment variables in `uwsm` belong in `~/.config/uwsm/env`:

```bash
# Append to ~/.config/uwsm/env
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}:${HOME}/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share"

```

#### Option B: Via Fish Shell (`~/.config/fish/config.fish`)

If setting it inside Fish, export and append to the list variable:

```fish
set -gx --append XDG_DATA_DIRS $HOME/.local/share/flatpak/exports/share /var/lib/flatpak/exports/share

```

_Immediate Desktop Cache Refresh:_

```bash
update-desktop-database ~/.local/share/flatpak/exports/share/applications

```

---

### Step 3: Install Lutris & ProtonUp-Qt via Flatpak

```bash
flatpak install --user flathub net.lutris.Lutris net.davidotek.pupgui2 -y

```

_Verification:_ Launch both tools once to confirm the sandbox runs:

```bash
flatpak run net.lutris.Lutris
flatpak run net.davidotek.pupgui2

```

---

### Step 4: Install a Modern GE Runner (Bypass `crypt32` Bug)

Battle.net frequently trips over an upstream Wine `crypt32` certificate bug (causing false _"Please check your network / VPN"_ errors). Running GE-Proton or Wine-GE prevents this.

1. Launch **ProtonUp-Qt**:

```bash
flatpak run net.davidotek.pupgui2

```

1. Under **Install for:**, select **Lutris (Flatpak)** (points to `~/.var/app/net.lutris.Lutris/data/lutris/runners/wine`).
2. Click **Add version**.
3. Choose **GE-Proton** (or **Wine-GE**) and select the latest build.
4. Click **Install**, wait for the download to finish, then close the window.

_Verification:_

```bash
ls ~/.var/app/net.lutris.Lutris/data/lutris/runners/wine
# Should display the GE-Proton directory

```

---

### Step 5: Install Battle.net & Warcraft III: Reforged

1. Open **Lutris**.
2. Click **+** (top-left) → search for **Battle.net** → click **Install**.
3. Keep default path `~/Games/battlenet` (Flatpak Lutris has native read/write access to `~/Games`).
4. **CRITICAL STEP:** When the Battle.net login window appears on screen, **do not log in yet**. Close the installer window cleanly so Lutris can finalize its prefix scripts.
5. Click **Close** on the Lutris completion dialog.
6. In Lutris, right-click **Battle.net** → **Configure** → **Runner options**:

- Set **Wine version** to the **GE-Proton** runner installed in Step 4.

1. Click **Save**.
2. Launch Battle.net from Lutris, log in, navigate to **Warcraft III: Reforged**, and install/locate the game.

---

### Flatpak Storage Override (Non-Standard Drives)

If your games live on an external drive or secondary partition outside `~/Games`, punch a hole in Flatpak's sandbox:

```bash
flatpak override --user --filesystem=/path/to/mountpoint net.lutris.Lutris

```

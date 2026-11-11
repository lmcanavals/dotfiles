---
name: qs-dev
description: "Trigger this skill whenever the user asks to manage, inspect, or modify their dotfiles, interact with the lmcanavals/dotfiles repository via gh, lint QML code, or force a hot reload in Quickshell."
version: 1.0.0
---

# Objective

Provide accurate Git commands, GitHub CLI operations, QML linting syntax, and Quickshell development workarounds tailored precisely to the user's bare repository architecture and workspace bugs.

# Instructions

1. **Dotfiles Git Targeting:** When generating or running any `git` command for system configurations or dotfiles, explicitly prepend or append the bare repository environment arguments. Use the format `git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME <command>`.
2. **GitHub CLI Interactivity:** When generating or running any `gh` command (issues, pull requests, project tracking), always append the explicit repository context flag: `--repo lmcanavals/dotfiles`.
3. **QML Bug Correction:** When executing or suggesting `qmllint` passes, always manually include all local module definitions via `-i` flags and the lookups via `-I .` to bypass the tool's false-positive import bug.
4. **Quickshell Reloading Action:** When requested to refresh or force a reload of the Quickshell UI canvas, do not suggest `touch shell.qml`. Instead, write a script or instruct the user to append a minor, non-functional text comment to the end of `shell.qml` and save it.

# Constraints

- **Do not** write plain, uncontextualized `git` commands; they will fail due to the bare repository setup.
- **Do not** run `qmllint` across the workspace without explicitly providing the path inclusions (e.g., `-i Core/qmldir -i Services/qmldir -I . **/*.qml`).
- **Do not** leave the forced-reload comments staged in Git suggestions; remind the user to discard or unstage the temporary comment line before committing changes.

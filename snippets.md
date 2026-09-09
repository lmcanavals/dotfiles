# Various snippets

- Fix the ? shown on the branch on lazyvim on the dotfiles bare repo

```sh
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch origin
git branch --set-upstream-to=origin/main main
```

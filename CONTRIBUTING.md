# Contributing

Merci de contribuer !

## Pré-requis
- Neovim >= 0.11
- Bash (Linux / macOS)
- Git, curl
- Optionnel (recommandé) : node, python3, ripgrep (`rg`), `fd`

## Développement local
1. Fork + clone
2. Crée une branche : `git checkout -b feat/ma-feature`
3. Lance les checks :
   - `./install.sh --dry-run --yes`
   - `./healthcheck.sh`
4. Ouvre une PR

## Conventions
- 1 sujet = 1 commit
- Messages de commit : `type(scope): message` (ex: `fix(none-ls): guard eslint_d nil`)
- Lua : format via `stylua`
- Shell : lint via `shellcheck`
- Markdown : `markdownlint`

## Signer ses commits
Optionnel, mais apprécié : `git config commit.gpgsign true`

# ROADMAP

Objectif : proposer une configuration Neovim **réutilisable en équipe**, facile à installer, documentée,
et proche d’une expérience IntelliJ (navigation, refactor, debug, tests, DevOps).

> Dates indicatives (adaptées aux contributions OSS). Les items peuvent bouger selon les retours.

## 2026 Q1 — Stabilisation “team-ready”
- [ ] Générer et versionner un `lazy-lock.json` reproductible (process documenté + CI).
- [ ] CI “smoke test” : démarrage headless + `:checkhealth` + vérification des dépendances (Linux).
- [ ] Matrix CI sur Neovim (min version supportée + latest stable).
- [ ] Mode “minimal install” (sans DAP/AI) + profil “full IDE”.
- [ ] Normalisation des conventions (structure `lua/config/*`, keymaps, options, autocmds).
- [ ] Commande `:IdeDoctor` (diagnostic projet) : versions, binaires externes, LSP actifs, etc.

## 2026 Q2 — Debug & Tests “IntelliJ parity”
- [ ] DAP : presets par langage (Go/Java/Python/Node/PHP), templates de configs, docs.
- [ ] Test runner unifié (JUnit/PyTest/PHPUnit/Jest) + UI (résultats, rerun, debug test).
- [ ] Gestion “Run/Debug configurations” (profils enregistrables par projet).
- [ ] Amélioration refactors : rename, code actions, imports (focus Java/TS/Python).

## 2026 Q3 — DevOps & Platform engineering
- [ ] Profils DevOps : Terraform, Ansible, Helm, Kustomize, YAML/JSON schema, Kubernetes.
- [ ] Intégration Docker/Compose : commandes projet, logs, attach.
- [ ] Devcontainer (VSCode compatible) / Nix optionnel pour environnements reproductibles.
- [ ] Documentation “workflows” : onboarding, conventions, troubleshooting.

## 2026 Q4 — AI & “Vibe Coding” (optionnel, opt-in)
- [ ] Guide d’intégration d’agents (Claude Code / autres) : prompts, workflows, sécurité.
- [ ] Commandes Neovim pour lancer/contrôler l’agent (sans imposer un fournisseur).
- [ ] Templates “SaaS starter workflow” : structure, tests, CI, release.

## En continu
- [ ] Bugs & régressions : triage, labels, “good first issue”.
- [ ] Docs : GIFs/vidéos courtes (Telescope, refactor, debug, tests).
- [ ] Bench & perf (startup time, LSP responsiveness).
- [ ] Compatibilité multi-OS (macOS, WSL) selon contributions.

## Comment contribuer
- Consulte `CONTRIBUTING.md` pour la convention de commits, la CI et les bonnes pratiques.

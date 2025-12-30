# Politique de versioning (SemVer) — Neovim IntelliJ-like IDE

Ce dépôt suit **Semantic Versioning 2.0.0** : `MAJOR.MINOR.PATCH`.

Comme il s'agit d’une **configuration Neovim** (pas une librairie), les notions de “breaking change” sont définies
de façon pragmatique pour les utilisateurs.

## Définition des ruptures (MAJOR)

On incrémente **MAJOR** (ex: `1.x.x` → `2.0.0`) si au moins un point est vrai :

- Changement incompatible de **structure** de config (`nvim/`, modules Lua, noms/chemins de fichiers, conventions).
- Changement incompatible des **raccourcis** (keymaps) “principaux” ou suppression de fonctionnalités sans alternative.
- Changement de **plugin manager** ou refonte majeure du bootstrap (Lazy/Mason/etc.).
- Changement des **pré‑requis** (ex: Neovim min version, Node/Python requis, OS supporté).
- Changement du comportement par défaut qui casse des workflows (format-on-save, diagnostics, LSP attach, etc.).

## Évolutions compatibles (MINOR)

On incrémente **MINOR** (ex: `1.2.0` → `1.3.0`) pour :

- Ajout de fonctionnalités (nouveaux plugins, nouvelles commandes, nouvelles intégrations) **sans casser l’existant**.
- Améliorations UX (UI, Telescope, Trouble, Aerial, DAP…) compatibles.
- Ajout de supports de langages / tooling (LSP/DAP/linters/formatters) sans retirer les précédents.
- Ajout de CI, docs, templates, scripts (si non breaking).

## Correctifs (PATCH)

On incrémente **PATCH** (ex: `1.2.3` → `1.2.4`) pour :

- Bugfix, hardening, sécurité, perf.
- Ajustements de docs.
- Mise à jour de versions de plugins **sans changement de comportement attendu**.
- Correctifs d’install/scripts (`--dry-run`, détection dépendances, etc.).

## Pré-releases & branches

- Les versions pré‑release utilisent : `-rc.1`, `-beta.1`, etc. (ex: `1.1.0-rc.1`).
- `main` reste stable ; les gros chantiers passent par branches + PR.

## Compatibilité Neovim

- Toute release annonce explicitement la **version minimum** de Neovim supportée.
- Une hausse du minimum Neovim suit généralement une **MAJOR** (ou une **MINOR** si non-breaking prouvé).

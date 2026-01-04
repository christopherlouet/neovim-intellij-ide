# 🚀 Guide de prise en main — Neovim IntelliJ IDE

Guide de démarrage rapide pour utiliser votre nouvelle configuration Neovim comme un IDE complet.

---

## 📖 Table des matières

- [Démarrage rapide](#-démarrage-rapide)
- [Interface utilisateur](#-interface-utilisateur)
- [Raccourcis essentiels](#-raccourcis-essentiels)
- [Navigation dans le code](#-navigation-dans-le-code)
- [Édition et refactoring](#-édition-et-refactoring)
- [LSP et diagnostics](#-lsp-et-diagnostics)
- [Git](#-git)
- [Debug et Tests](#-debug-et-tests)
- [Terminal et Docker](#-terminal-et-docker)
- [Astuces et productivité](#-astuces-et-productivité)

---

## 🎯 Démarrage rapide

### Avant de commencer : comprendre Vim

Si vous découvrez Neovim/Vim, voici les **concepts essentiels** à connaître :

#### Les modes de Vim

Vim utilise différents modes pour éditer du texte. C'est **différent** des éditeurs traditionnels !

| Mode | Touche | Description |
|------|--------|-------------|
| **Normal** | `Esc` | Mode par défaut - pour naviguer et exécuter des commandes |
| **Insertion** | `i` | Mode édition - pour taper du texte (comme un éditeur classique) |
| **Visuel** | `v` | Mode sélection - pour sélectionner du texte |
| **Commande** | `:` | Mode commande - pour exécuter des commandes Vim |

**Règle d'or** : Restez en mode **Normal** par défaut. Passez en mode **Insertion** (`i`) uniquement pour taper du texte, puis revenez en mode **Normal** (`Esc`).

#### Déplacements de base en mode Normal

| Touche | Action |
|--------|--------|
| `h` `j` `k` `l` | Gauche, Bas, Haut, Droite |
| `w` | Mot suivant |
| `b` | Mot précédent |
| `0` | Début de ligne |
| `$` | Fin de ligne |
| `gg` | Début du fichier |
| `G` | Fin du fichier |

#### Édition de base

| Touche | Action |
|--------|--------|
| `i` | Insérer avant le curseur |
| `a` | Insérer après le curseur |
| `o` | Nouvelle ligne en dessous |
| `O` | Nouvelle ligne au dessus |
| `x` | Supprimer le caractère |
| `dd` | Supprimer la ligne |
| `yy` | Copier la ligne |
| `p` | Coller |
| `u` | Undo |
| `Ctrl+r` | Redo |

> 💡 **Astuce** : En cas de doute, appuyez sur `Esc` plusieurs fois pour revenir en mode Normal, puis tapez `:q!` pour quitter sans sauvegarder.

### Premier lancement

```bash
# Lancer Neovim
nvim

# Ou ouvrir un fichier directement
nvim mon-fichier.js
```

Au premier démarrage :

1. Les plugins se synchronisent automatiquement (via Lazy.nvim)
2. **Patientez 20-30 secondes** pendant l'installation — une fenêtre s'affiche avec la progression
3. Une fois terminé, **quittez** Neovim (`:qa`) et **relancez-le**
4. Au second lancement, tout devrait être opérationnel ✨

> ⚠️ **Note** : Si des messages apparaissent au démarrage, appuyez simplement sur `Entrée` pour les valider.

### Vérification de l'installation

Vérifiez que tout fonctionne correctement :

```vim
:checkhealth          " Diagnostic complet du système
:Lazy                 " Voir les plugins installés (appuyez sur 'q' pour quitter)
:Mason                " Voir les outils LSP disponibles (appuyez sur 'q' pour quitter)
```

**Indicateurs que tout va bien** :

- ✅ La barre du bas (statusline) affiche des informations
- ✅ Les numéros de ligne sont visibles à gauche
- ✅ `:checkhealth` ne montre pas d'erreurs critiques

### En cas de problème

Si vous rencontrez des erreurs au démarrage ou des comportements étranges :

```bash
# Nettoyage rapide du cache
./clean-restart.sh

# Nettoyage complet avec réinstallation
./clean-restart.sh --deep -y
```

Ce script nettoie proprement le cache et les fichiers temporaires sans toucher à votre configuration.

---

## 🎨 Interface utilisateur

### Composants principaux

- **Statusline (bas)** : Lualine — affiche le mode, la branche Git, les diagnostics LSP
- **Bufferline (haut)** : Onglets pour naviguer entre fichiers ouverts
- **NvimTree** : Explorateur de fichiers (à gauche)
- **Which-key** : Aide contextuelle des raccourcis (apparaît automatiquement après `<leader>`)

### Ouvrir l'explorateur de fichiers

```vim
<leader>e    " Toggle NvimTree
```

---

## ⌨️ Raccourcis essentiels

> **Note** : `<leader>` = `Espace` par défaut

### Général

| Raccourci | Action |
|-----------|--------|
| `<leader>w` | Sauvegarder le fichier |
| `<leader>q` | Quitter |
| `:qa` | Quitter tous les buffers |
| `:qa!` | Quitter sans sauvegarder (force) |
| `<leader>e` | Toggle explorateur de fichiers |
| `<Esc>` | Nettoyer la recherche / fermer popup |

> 💡 **Pour les débutants** : Pour sauvegarder et quitter rapidement, tapez `<leader>w` puis `:qa`

### Gestion des buffers (onglets)

| Raccourci | Action |
|-----------|--------|
| `<S-h>` ou `[b` | Buffer précédent |
| `<S-l>` ou `]b` | Buffer suivant |
| `<leader>bd` | Fermer le buffer courant |
| `<leader>bD` | Fermer le buffer (force) |
| `<leader>bo` | Fermer tous les autres buffers |
| `<leader>bp` | Épingler/Désépingler le buffer |
| `<leader>br` | Fermer les buffers à droite |
| `<leader>bl` | Fermer les buffers à gauche |

### Recherche (Telescope)

| Raccourci | Action |
|-----------|--------|
| `<leader>ff` | Rechercher des fichiers |
| `<leader>fg` | Rechercher dans le contenu (grep) |
| `<leader>fb` | Rechercher dans les buffers ouverts |
| `<leader>fh` | Rechercher dans l'historique |
| `<leader>fw` | Rechercher le mot sous le curseur |

---

## 🧭 Navigation dans le code

### LSP (Language Server Protocol)

| Raccourci | Action |
|-----------|--------|
| `gd` | Aller à la définition |
| `gD` | Aller à la déclaration |
| `gi` | Aller à l'implémentation |
| `gr` ou `gR` | Trouver les références |
| `K` | Afficher la documentation (hover) |
| `<C-k>` | Signature de la fonction |
| `[d` | Diagnostic précédent |
| `]d` | Diagnostic suivant |

### Structure du code

| Raccourci | Action |
|-----------|--------|
| `<leader>cs` | Afficher les symboles (Trouble) |
| `<leader>o` | Toggle Aerial (outline/structure) |

### Diagnostics (Trouble)

| Raccourci | Action |
|-----------|--------|
| `<leader>xx` | Toggle diagnostics du projet |
| `<leader>xX` | Toggle diagnostics du buffer |
| `<leader>xL` | Liste de localisation |
| `<leader>xQ` | Quickfix list |
| `[q` | Diagnostic précédent |
| `]q` | Diagnostic suivant |

---

## ✏️ Édition et refactoring

### Édition de base

| Raccourci | Action |
|-----------|--------|
| `<leader>rn` | Renommer le symbole (LSP rename) |
| `<leader>rN` | Renommer avec preview (IncRename) |
| `<leader>ca` | Actions de code (Code Actions) |
| `gcc` | Commenter/décommenter la ligne |
| `gc` (en visuel) | Commenter la sélection |

### Refactoring avancé

| Raccourci (visuel) | Action |
|-----------|--------|
| `<leader>re` | Extract function |
| `<leader>rf` | Extract function to file |
| `<leader>rv` | Extract variable |
| `<leader>ri` | Inline variable |

### Paires et surround

| Raccourci | Action |
|-----------|--------|
| `ys{motion}{char}` | Entourer avec des caractères |
| `ds{char}` | Supprimer les caractères entourants |
| `cs{old}{new}` | Changer les caractères entourants |

**Exemples** :

- `ysiw"` : entourer le mot avec des guillemets
- `ds"` : supprimer les guillemets
- `cs"'` : changer `"` en `'`

---

## 🔍 LSP et diagnostics

### Formatage

Le formatage se fait automatiquement à la sauvegarde (via none-ls).

Pour formater manuellement :

```vim
:lua vim.lsp.buf.format()
```

### Installer des outils (LSP, formatters, linters)

```vim
:Mason                    " Ouvrir le gestionnaire Mason
:MasonInstallDevTools     " Installer tous les outils recommandés
```

### Outils recommandés

**JavaScript/TypeScript** :

- `ts_ls` (LSP)
- `eslint_d` (linter)
- `prettier` (formatter)

**Autres langages** :

- HTML : `html`, `cssls`, `tailwindcss`
- JSON : `jsonls`
- Docker : `dockerls`
- Bash : `bashls`
- Prisma : `prismals`

---

## 🌿 Git

### Gitsigns (indicateurs de changements)

| Raccourci | Action |
|-----------|--------|
| `]c` | Hunk suivant |
| `[c` | Hunk précédent |
| `<leader>hs` | Stage le hunk |
| `<leader>hr` | Reset le hunk |
| `<leader>hu` | Undo stage hunk |
| `<leader>hp` | Preview le hunk |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff |

### Neogit (interface Git complète)

```vim
<leader>gg    " Ouvrir Neogit
```

Dans Neogit :

- `s` : stage
- `u` : unstage
- `c` : commit
- `P` : push
- `F` : pull
- `?` : aide

### Diffview

```vim
<leader>gd    " Ouvrir Diffview
```

---

## 🐛 Debug et Tests

### Debug (nvim-dap)

| Raccourci | Action |
|-----------|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Breakpoint conditionnel |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dr` | REPL |
| `<leader>dl` | Run last |
| `<leader>du` | Toggle UI |
| `<leader>dt` | Terminate |

### Tests (Neotest)

| Raccourci | Action |
|-----------|--------|
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run file tests |
| `<leader>ta` | Run all tests |
| `<leader>ts` | Toggle summary |
| `<leader>to` | Toggle output panel |

---

## 💻 Terminal et Docker

### Terminal (ToggleTerm)

| Raccourci | Action |
|-----------|--------|
| `<leader>tf` | Toggle terminal flottant |
| `<leader>th` | Toggle terminal horizontal |
| `<leader>tv` | Toggle terminal vertical |
| `<C-\>` | Toggle dans le terminal |

### Docker (Telescope)

```vim
<leader>fd    " Rechercher dans Docker (containers, images, volumes)
```

---

## 💡 Astuces et productivité

### Which-key : découvrir les raccourcis (votre meilleur ami !)

**C'est la fonctionnalité la plus importante pour débuter !**

Appuyez sur `<Espace>` (la touche leader) et **attendez 1 seconde** → une fenêtre popup affiche **tous les raccourcis disponibles**.

**Comment l'utiliser** :

1. Appuyez sur `Espace`
2. Regardez les options qui s'affichent
3. Appuyez sur la lettre correspondante (ex: `f` pour "Find")
4. Une nouvelle fenêtre s'ouvre avec les sous-commandes disponibles
5. Choisissez l'action souhaitée

**Exemple concret** :

- Tapez `Espace` → vous voyez `f` = Find
- Tapez `f` → vous voyez `ff` = Find files, `fg` = Grep, etc.
- Tapez `f` → la recherche de fichiers s'ouvre

**Groupes de commandes** :

- `<leader>b` : **B**uffer (gestion des onglets)
- `<leader>c` : **C**ode (actions sur le code)
- `<leader>d` : **D**ebug (débogage)
- `<leader>f` : **F**ind/File (recherche)
- `<leader>g` : **G**it (contrôle de version)
- `<leader>h` : Git **h**unks (changements Git)
- `<leader>q` : **Q**uit/Session (quitter/sessions)
- `<leader>r` : **R**efactor (refactorisation)
- `<leader>s` : **S**earch (recherche avancée)
- `<leader>t` : **T**est/Terminal (tests et terminal)
- `<leader>u` : **U**I (interface)
- `<leader>x` : Diagnostics (erreurs et warnings)

> 💡 **Astuce** : Vous ne savez plus quoi faire ? Appuyez sur `Espace` et explorez les options !

### Sessions (auto-session)

Vos sessions sont sauvegardées automatiquement par projet.

| Raccourci | Action |
|-----------|--------|
| `<leader>qs` | Sauvegarder la session |
| `<leader>qr` | Restaurer la session |
| `<leader>qd` | Supprimer la session |

### Notifications

| Raccourci | Action |
|-----------|--------|
| `<leader>un` | Fermer toutes les notifications |
| `<leader>snh` | Historique des messages (Noice) |
| `<leader>snl` | Dernier message |
| `<leader>snd` | Dismiss messages |

### Indent guides

Les guides d'indentation sont affichés automatiquement pour faciliter la lecture du code.

### Aerial (vue structure)

Aerial affiche la structure du fichier (fonctions, classes, etc.) :

```vim
<leader>o    " Toggle Aerial
```

### Recherche de projets

Le plugin `project.nvim` détecte automatiquement les projets (Git, package.json, etc.).

```vim
<leader>fp    " Rechercher dans les projets récents
```

---

## 🔧 Commandes utiles

### Lazy.nvim (gestionnaire de plugins)

```vim
:Lazy                 " Ouvrir l'interface Lazy
:Lazy sync            " Synchroniser tous les plugins
:Lazy update          " Mettre à jour les plugins
:Lazy clean           " Nettoyer les plugins inutilisés
:Lazy profile         " Profiler le temps de chargement
```

### Mason (gestionnaire d'outils)

```vim
:Mason                    " Ouvrir l'interface Mason
:MasonInstall <tool>      " Installer un outil
:MasonUninstall <tool>    " Désinstaller un outil
:MasonUpdate              " Mettre à jour tous les outils
:MasonInstallDevTools     " Installer tous les outils recommandés
```

### Treesitter (coloration syntaxique)

```vim
:TSUpdate             " Mettre à jour les parsers
:TSInstall <lang>     " Installer un parser
:TSBufToggle highlight " Toggle highlight
```

### Santé du système

```vim
:checkhealth          " Vérifier l'état général
:checkhealth lazy     " Vérifier Lazy.nvim
:checkhealth mason    " Vérifier Mason
:checkhealth lsp      " Vérifier LSP
```

---

## 🎓 Workflow recommandé

### Votre premier fichier (pas à pas)

**Objectif** : Ouvrir un fichier, le modifier, le sauvegarder et quitter.

1. **Lancer Neovim**

   ```bash
   nvim test.js
   ```

2. **Vous êtes en mode Normal** (c'est normal !)
   - Appuyez sur `i` pour passer en **mode Insertion**
   - Tapez du texte : `console.log("Hello Neovim!")`
   - Appuyez sur `Esc` pour revenir en **mode Normal**

3. **Sauvegarder**
   - En mode Normal, tapez `Espace` puis `w`
   - Vous voyez `[written]` en bas → c'est sauvegardé ✅

4. **Quitter**
   - Tapez `:qa` puis `Entrée`

**Bravo !** 🎉 Vous venez d'utiliser Neovim comme un pro.

### Pour commencer un projet

1. **Ouvrir le projet**

   ```bash
   cd mon-projet
   nvim .
   ```

   > 💡 Le `.` ouvre Neovim dans le répertoire actuel

2. **Explorer les fichiers**
   - `Espace` + `e` pour ouvrir l'explorateur de fichiers (NvimTree)
   - Utilisez `j` et `k` pour naviguer (ou les flèches)
   - Appuyez sur `Entrée` pour ouvrir un fichier
   - `Espace` + `e` pour fermer l'explorateur

   **Alternative rapide** :
   - `Espace` + `f` + `f` → recherche floue de fichiers (tapez le nom du fichier)

3. **Vérifier les outils installés**

   ```vim
   :Mason
   ```

   Installez les outils pour votre langage (ex: `ts_ls` pour TypeScript)

4. **Vérifier les diagnostics**

   ```vim
   :checkhealth
   ```

### Éditer du code

1. **Naviguer vers une fonction/classe**
   - `<leader>fw` : rechercher le symbole
   - `gd` : aller à la définition
   - `gr` : trouver toutes les références

2. **Refactorer**
   - `<leader>rn` : renommer
   - `<leader>ca` : actions de code disponibles
   - Sélectionner du code (visuel) → `<leader>re` : extraire fonction

3. **Corriger les erreurs**
   - `<leader>xx` : voir tous les diagnostics
   - `]d` / `[d` : naviguer entre les erreurs
   - `<leader>ca` sur une erreur : voir les quick fixes

### Débugger

1. **Placer des breakpoints**

   ```vim
   <leader>db
   ```

2. **Lancer le debug**

   ```vim
   <leader>dc
   ```

3. **Naviguer**
   - `<leader>di` : step into
   - `<leader>do` : step over
   - `<leader>dO` : step out

### Utiliser Git

1. **Voir les changements**

   ```vim
   <leader>gg    " Neogit
   ```

2. **Naviguer dans les hunks**

   ```vim
   ]c / [c
   ```

3. **Stage et commit**
   - Dans Neogit : `s` (stage), `c` (commit)

---

## 📚 Ressources supplémentaires

- **Documentation Neovim** : `:help`
- **Documentation d'un plugin** : `:help <nom-du-plugin>`
- **Keymaps** : `:WhichKey` ou simplement `<leader>`
- **Migration IntelliJ** : voir `INTELLIJ_MIGRATION.md` (après `./intellij-migrate.sh`)

---

## ❓ Questions fréquentes

### Je suis bloqué en mode Insertion, comment revenir en mode Normal ?

Appuyez sur `Esc` ou `Ctrl+c`. Vous êtes maintenant en mode Normal (le curseur devient un rectangle).

### Comment quitter Neovim ?

- En mode Normal : tapez `:qa` puis `Entrée`
- Pour forcer (sans sauvegarder) : `:qa!` puis `Entrée`
- Pour sauvegarder et quitter : `Espace` + `w` puis `:qa`

### J'ai tapé une commande par erreur et il y a un message bizarre

Appuyez sur `Esc` plusieurs fois, puis tapez `:messages` pour voir l'historique des messages.

### Les touches fléchées fonctionnent-elles ?

Oui ! Mais nous recommandons d'apprendre `h j k l` pour plus d'efficacité.

### Comment copier/coller depuis l'extérieur de Neovim ?

- **Copier** : Sélectionnez du texte en mode Visuel (`v`) puis `Espace` + `y`
- **Coller** : En mode Normal ou Insertion, utilisez `Ctrl+Shift+v`
- Le clipboard système est activé par défaut dans cette config

### Comment changer le leader ?

Éditer `nvim/lua/config/options.lua` :

```lua
vim.g.mapleader = " "  -- Changer l'espace par votre touche préférée
```

### Comment désactiver le formatage auto ?

Éditer `nvim/lua/plugins/formatting.lua` et commenter la section `format_on_save`.

### Comment ajouter un nouveau langage ?

1. `:Mason` → installer le LSP server
2. Éditer `nvim/lua/plugins/lsp.lua` :

   ```lua
   vim.lsp.config("mon_langage_ls", {})
   ```

### Le LSP ne démarre pas ?

```vim
:LspInfo           " Vérifier l'état du LSP
:LspLog            " Voir les logs
```

### Où apprendre Vim plus en profondeur ?

- **Tutoriel intégré** : Tapez `vimtutor` dans votre terminal (30 min, très recommandé !)
- **Aide intégrée** : `:help` dans Neovim
- **Vim Adventures** : <https://vim-adventures.com/> (jeu pour apprendre Vim)
- **OpenVim** : <https://www.openvim.com/> (tutoriel interactif)

---

## 🎉 Vous êtes prêt

Vous avez maintenant toutes les clés pour utiliser Neovim comme un IDE professionnel.

### 📋 Checklist du débutant

Avant de vous lancer dans un vrai projet, assurez-vous de maîtriser :

- [ ] Les 3 modes principaux : Normal (`Esc`), Insertion (`i`), Visuel (`v`)
- [ ] Se déplacer avec `h j k l` ou les flèches
- [ ] Ouvrir l'aide avec `Espace` (which-key)
- [ ] Sauvegarder avec `Espace` + `w`
- [ ] Quitter avec `:qa`
- [ ] Ouvrir l'explorateur de fichiers avec `Espace` + `e`
- [ ] Rechercher un fichier avec `Espace` + `f` + `f`
- [ ] Annuler avec `u` et refaire avec `Ctrl+r`

### 🎯 Prochaines étapes

Une fois à l'aise avec les bases :

1. **Explorez Which-key** : `Espace` → découvrez toutes les fonctionnalités
2. **Configurez vos langages** : `:Mason` → installez les LSP pour vos langages
3. **Pratiquez les raccourcis** : Plus vous utilisez Vim, plus vous serez rapide
4. **Personnalisez** : Éditez les fichiers dans `nvim/lua/` selon vos besoins

### 💬 Besoin d'aide ?

- **Coincé ?** Appuyez sur `Esc` plusieurs fois → tout s'arrête
- **Message d'erreur ?** Lisez-le calmement → souvent la solution est dans le message
- **Commande oubliée ?** `Espace` → Which-key vous guide

**N'oubliez pas** :

- `<leader>` (Espace) pour découvrir les raccourcis
- `:checkhealth` pour diagnostiquer
- `:Lazy` et `:Mason` pour gérer vos outils
- `vimtutor` dans le terminal pour un tutoriel complet

**Bon code !** 🚀

> 💡 **Conseil final** : Neovim a une courbe d'apprentissage, mais après quelques jours de pratique, vous serez **beaucoup plus rapide** qu'avec un éditeur classique. Persévérez !

# PlumeMD

[![CI](https://github.com/gwenn-ha-dev/PlumeMD/actions/workflows/ci.yml/badge.svg)](https://github.com/gwenn-ha-dev/PlumeMD/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
![Platform](https://img.shields.io/badge/Platform-macOS%2014%2B-black?logo=apple)
![Swift 6](https://img.shields.io/badge/Swift-6-orange?logo=swift)

*🇬🇧 [English](./README.md) · 🇫🇷 Français*

Éditeur de documents Markdown natif macOS, avec rendu live et export PDF. App orientée document : vos fichiers restent les vôtres, sur disque, en Markdown.

## Fonctionnalités

- **Orienté document** (`DocumentGroup`) — ouvre, édite et enregistre de simples fichiers `.md`.
- **Rendu live** avec un système typographique (`DesignTokens`).
- **Export PDF** avec pagination correcte.
- Aucun enfermement : ce que vous enregistrez est le Markdown que vous avez écrit.

## Installation

```sh
git clone https://github.com/gwenn-ha-dev/PlumeMD.git
cd PlumeMD
make build
```

## Comment ça marche

Le nom porte son format : *Plume* pour l'écriture, *MD* pour Markdown.

## Construction

| Commande | Ce qu'elle fait |
|---|---|
| `make build` | Compilation release, tout avertissement est une erreur |
| `make test` | Lance la suite de tests |
| `make run` | Lance l'app |
| `make icon` | Régénère `Resources/AppIcon.icns` |
| `make package` | Produit un bundle distribuable dans `build/` |
| `make lint` | Vérifie la conformité à la charte |
| `make help` | Liste toutes les cibles |

## Dépendances

Aucune — frameworks Apple uniquement.

## Licence

MIT © 2026 gwenn-ha-dev — voir [LICENSE](./LICENSE).

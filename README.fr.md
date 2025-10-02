# FrankenPHP avec WordPress

🇫🇷 Version française | [🇬🇧 English version](README.md)

Ce projet configure WordPress avec FrankenPHP en utilisant SQLite comme base de données, ce qui permet une installation légère et rapide sans nécessiter MySQL/MariaDB.

## Prérequis

- Linux, macOS ou WSL (Windows Subsystem for Linux)
- curl
- Accès aux droits administrateur pour l'installation globale (optionnel)

## Installation

### Option 1 : Installation manuelle de FrankenPHP

```bash
curl https://frankenphp.dev/install.sh | sh
sudo mv frankenphp /usr/local/bin/
```

### Option 2 : Installation automatique (recommandée)

```bash
sh install-wordpress.sh
```

Ce script installe automatiquement FrankenPHP et configure WordPress avec SQLite.

## Utilisation

### Servir WordPress (mode production)

```bash
./frankenphp php-server -r wordpress/
```

Accédez ensuite à votre site sur **http://localhost**

### Servir WordPress en mode développement (watch mode)

Le mode watch recharge automatiquement les modifications de fichiers :

```bash
./frankenphp php-server -r wordpress/ --watch
```

### Servir WordPress avec Caddyfile personnalisé

Pour une configuration avancée avec Caddy :

```bash
./frankenphp run
```

Cette commande utilise le fichier `Caddyfile` présent dans le répertoire pour configurer le serveur.

## Caractéristiques

- ✅ **Pas de base de données externe requise** : utilise SQLite
- ✅ **Serveur PHP moderne** : basé sur FrankenPHP
- ✅ **Rechargement automatique** : mode watch pour le développement
- ✅ **Configuration flexible** : supporte les Caddyfiles personnalisés
- ✅ **Léger et rapide** : installation minimale

## Structure du projet

```
.
├── README.md              # Version anglaise
├── README.fr.md           # Version française
├── install-wordpress.sh   # Script d'installation automatique
├── Caddyfile             # Configuration Caddy (optionnel)
├── wordpress/            # Répertoire WordPress
└── frankenphp            # Exécutable FrankenPHP
```

## Dépannage

### Le serveur ne démarre pas

Vérifiez que le port 80 n'est pas déjà utilisé :

```bash
lsof -i :80
```

Pour utiliser un port différent :

```bash
./frankenphp php-server -r wordpress/ -l :8080
```

### Permission refusée

Si vous obtenez une erreur de permission, rendez FrankenPHP exécutable :

```bash
chmod +x frankenphp
```

## Ressources

- [Documentation FrankenPHP](https://frankenphp.dev/)
- [WordPress avec SQLite](https://www.alexandergoller.com/journal/15074/wordpress-sqlite-db-integration/)
- [Documentation Caddy](https://caddyserver.com/docs/)

## Licence

Ce projet utilise WordPress (GPL v2+) et FrankenPHP (MIT).

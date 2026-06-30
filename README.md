Voici un fichier `README.md` concis et structuré qui documente tes choix et l'architecture de ton projet.

```markdown
# ☁️ Projet Cloud-1 : Déploiement Automatisé

Ce projet déploie automatiquement une stack web complète et sécurisée (WordPress, phpMyAdmin, MariaDB) sur une instance Cloud via Ansible et Docker, en respectant la règle d'isolation : 1 processus = 1 conteneur.

---

## 🏗️ Choix d'Infrastructure et Architecture

### 1. Automatisation : Ansible
* **`deploy.yml`** : Script unique qui gère le provisioning de A à Z (installation de Docker, création des répertoires, copie des configurations, génération des certificats SSL auto-signés et lancement des conteneurs).
* **Avantage** : Reproductibilité totale sur n'importe quelle VM vierge Ubuntu.

### 2. Conteneurisation : Docker Compose
* **Isolation réseau** : Création d'un réseau bridge dédié (`inception_network`).
* **Sécurité** : Les conteneurs `mariadb`, `wordpress` et `phpmyadmin` n'exposent **aucun port** vers l'extérieur. Ils communiquent uniquement en interne.
* **Persistance** : Utilisation de volumes Docker locaux (`wp_data`, `db_data`) pour garantir la sauvegarde des données (fichiers du site et base de données) en cas de redémarrage de la machine.

### 3. Point d'entrée : Nginx (Reverse Proxy)
* **Ports exposés** : Seul le conteneur Nginx est accessible de l'extérieur (ports 80 et 443).
* **Sécurité TLS** : Redirection automatique du trafic HTTP (80) vers HTTPS (443). Le trafic est chiffré via des certificats SSL générés à la volée.
* **Routage intelligent** : 
  * Redirige les requêtes PHP vers le conteneur `wordpress` via FastCGI (port 9000).
  * Gère le sous-dossier `/phpmyadmin/` en réécrivant l'URL avant de la transférer au conteneur `phpmyadmin` (port 80).

---

## 🚀 Comment déployer le projet

### Prérequis
* Une machine locale avec `ansible` d'installé.
* Une VM cible vierge (ex: Scaleway) accessible en SSH (clé publique configurée).

### Instructions

1. **Configurer l'inventaire**
   Éditez le fichier `hosts.ini` avec l'adresse IP de votre VM :
   ```ini
   [cloud_server]
   VOTRE_IP_PUBLIQUE ansible_user=root

```

2. **Configurer les variables d'environnement**
Créez un fichier `.env` à la racine du projet contenant vos identifiants :
```env
MYSQL_ROOT_PASSWORD=mot_de_passe_root
MYSQL_DATABASE=wordpress
MYSQL_USER=utilisateur
MYSQL_PASSWORD=mot_de_passe

```


3. **Lancer le déploiement**
Exécutez la commande suivante depuis votre machine locale :
```bash
ansible-playbook -i hosts.ini deploy.yml

```# CLOUD-1

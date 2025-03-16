# CLOUD-1

---

```markdown
# Projet Cloud-1 : Déploiement automatisé de WordPress sur GCP avec Terraform

Ce projet consiste à déployer une infrastructure Docker pour héberger un site WordPress avec PHPMyAdmin et une base de données MySQL sur Google Cloud Platform (GCP). L'objectif est d'automatiser le déploiement en utilisant Terraform pour l'Infrastructure as Code (IaC) et Docker-compose pour la gestion des conteneurs.

---

## **Prérequis**

Avant de commencer, assurez-vous d'avoir les outils suivants installés :

1. **Compte GCP** : Créez un compte GCP et activez les crédits gratuits.
2. **Terraform** : Installez Terraform sur votre machine locale.
3. **Google Cloud SDK** : Installez et configurez `gcloud` pour interagir avec GCP.
4. **Docker** : Installez Docker pour gérer les conteneurs localement.
5. **Git** : Installez Git pour gérer votre dépôt de code.
6. **Clé SSH** : Générez une clé SSH si vous n'en avez pas déjà une.

---

## **Étapes du projet**

### **1. Configuration de l'environnement GCP**

#### **1.1. Authentification avec GCP**
Authentifiez-vous sur GCP en utilisant Google Cloud SDK :

```bash
gcloud auth login
```

#### **1.2. Configuration du projet GCP**
Définissez le projet GCP que vous allez utiliser :

```bash
gcloud config set project VOTRE_PROJET_GCP
```

---

### **2. Création de l'infrastructure avec Terraform**

#### **2.1. Initialisation de Terraform**
Clonez ce dépôt et initialisez Terraform dans le dossier du projet :

```bash
git clone https://github.com/votre-repo/cloud1-project.git
cd cloud1-project/terraform
terraform init
```

#### **2.2. Déploiement de l'infrastructure**
Appliquez la configuration Terraform pour créer les ressources GCP (VM, disque persistant, règles de pare-feu) :

```bash
terraform apply
```

Terraform affichera un résumé des ressources à créer. Confirmez en tapant `yes`.

---

### **3. Configuration de la VM et déploiement des conteneurs**

#### **3.1. Connexion à la VM**
Une fois la VM créée, connectez-vous à celle-ci en utilisant SSH :

```bash
ssh -i ~/.ssh/id_rsa votre-utilisateur@IP_DE_LA_VM
```

#### **3.2. Installation de Docker et Docker-compose**
Sur la VM, installez Docker et Docker-compose :

```bash
sudo apt update
sudo apt install -y docker.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

#### **3.3. Copie du fichier Docker-compose**
Copiez le fichier `docker-compose.yml` sur la VM :

```bash
scp -i ~/.ssh/id_rsa ../docker-compose.yml votre-utilisateur@IP_DE_LA_VM:/home/votre-utilisateur/
```

#### **3.4. Démarrage des conteneurs**
Démarrez les conteneurs WordPress, PHPMyAdmin et MySQL :

```bash
cd /home/votre-utilisateur
docker-compose up -d
```

---

### **4. Configuration de HTTPS (optionnel)**

#### **4.1. Installation de Nginx et Certbot**
Installez Nginx et Certbot pour configurer HTTPS :

```bash
sudo apt install -y nginx certbot python3-certbot-nginx
```

#### **4.2. Configuration du reverse proxy**
Configurez Nginx pour rediriger le trafic HTTP vers HTTPS :

```bash
sudo nano /etc/nginx/sites-available/wordpress
```

Ajoutez la configuration suivante :

```nginx
server {
    listen 80;
    server_name votre-domaine.com;

    location / {
        proxy_pass http://localhost:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

#### **4.3. Obtention du certificat TLS**
Obtenez un certificat TLS gratuit avec Let's Encrypt :

```bash
sudo certbot --nginx -d votre-domaine.com
```

---

### **5. Tests et validation**

#### **5.1. Accès au site WordPress**
Ouvrez votre navigateur et accédez à `http://IP_DE_LA_VM` ou `https://votre-domaine.com` pour vérifier que WordPress est accessible.

#### **5.2. Accès à PHPMyAdmin**
Accédez à PHPMyAdmin via `http://IP_DE_LA_VM:8080` ou `https://votre-domaine.com:8080`.

#### **5.3. Vérification de la persistance des données**
Redémarrez la VM et vérifiez que les données (articles, utilisateurs, etc.) sont toujours présentes.

---

### **6. Nettoyage des ressources**

#### **6.1. Destruction de l'infrastructure Terraform**
Pour éviter des frais inutiles, détruisez les ressources GCP après avoir terminé le projet :

```bash
cd cloud1-project/terraform
terraform destroy
```

Confirmez en tapant `yes`.

---

## **Conclusion**

Ce projet vous a permis de déployer une infrastructure cloud automatisée pour héberger un site WordPress avec PHPMyAdmin et une base de données MySQL. Vous avez utilisé Terraform pour l'IaC, Docker-compose pour la gestion des conteneurs, et Let's Encrypt pour sécuriser les communications avec HTTPS.

```


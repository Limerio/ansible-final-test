# Déploiement Applicatif automatisé

## Contexte professionnel

Vous venez d’être recruté comme DevOps junior dans une entreprise d’hébergement de
sites web. Votre première mission consiste à automatiser le déploiement d’un site
WordPress avec une base MariaDB, sur des serveurs Linux (Ubuntu et Rocky Linux)
dans un environnement conteneurisé.
Pour garantir la qualité et la reproductibilité des déploiements, l’équipe technique a
choisi d’utiliser Ansible.
Un script shell vous est fourni par un collègue. Votre objectif est de le transformer en un
rôle Ansible propre, maintenable et idempotent, puis de le publier sur Ansible Galaxy.

## Objectif de la mission

1. Créer un rôle Ansible complet à partir du script [install_wordpress.sh](Install_wordpress.sh).

2. S’assurer qu’il fonctionne aussi bien sur Ubuntu que Rocky Linux.

3. Organiser le rôle de façon réutilisable, avec :

- Variables configurables - Fichiers découpés (handlers, tasks, vars, defaults, etc.)
- Un ou plusieurs handlers
- Des conditions (when) et boucles (loop) si nécessaire

4. Écrire un README clair expliquant le rôle, les variables et l’exécution.

5. Tester votre rôle via un playbook d'exemple.

6. Publier le rôle sur Ansible Galaxy.

## Critères d'évaluation

- Structure du rôle
- Adaptation du script
- Idempotence
- Variables
- Boucles / Conditions
- Handlers
- Documentation
- Publication Galaxy
- Playbook test fonctionnel
- Qualité du code

## Livrables attendus

- A envoyer par mail le lien vers le rôle sur https://galaxy.ansible.com.

## Conseils pédagogiques

- Commencez par bien comprendre les étapes du script.
- Testez votre rôle sur au moins 1 conteneur Debian et 1 Rocky Linux.
- Faites attention aux différences : apache2 vs httpd, apt vs dnf, systemctl vs service.
- Utilisez notify et des handlers dès que vous modifiez une config Apache/MariaDB.

## Les choses à savoir

Démarrer MariaDB en arrière-plan dans un conteneur :

```bash
mysqld_safe --datadir=/var/lib/mysql &
```

Démarrer Apache2 dans un conteneur Ubuntu :

```bash
service apache2 start
```

Démarrer httpd dans un conteneur Rocky :

```bash
/usr/sbin/httpd -DFOREGROUND
```

---

## Documentation du rôle

### Rôle

Ce rôle Ansible déploie **WordPress** avec **Apache** (ou httpd sur Rocky/RHEL) et **MariaDB** sur des hôtes Linux (Ubuntu/Debian et Rocky/RedHat). Il est conçu pour fonctionner sur des serveurs classiques et dans des conteneurs (avec ou sans systemd).

**Étapes réalisées par le rôle :**

1. **Préparation** (`prep.yml`) — Mise à jour des dépôts (apt/dnf) selon la famille OS.
2. **Paquets** (`packages.yml`) — Installation d’Apache/httpd, PHP, MariaDB, wget, unzip.
3. **Nettoyage** (`clean-up.yml`) — Suppression du `index.html` par défaut d’Apache.
4. **Démarrage** (`start.yml`) — Démarrage d’Apache et MariaDB (systemd ou commande directe en conteneur).
5. **Sécurisation MariaDB** (`secure-mariadb.yml`) — Mot de passe root, suppression des utilisateurs anonymes et de la base `test`, flush des privilèges.
6. **Base de données** (`create-database.yml`) — Création de la base WordPress, de l’utilisateur dédié et des droits.
7. **Téléchargement WordPress** (`download-wordpress.yml`) — Téléchargement et extraction de WordPress dans `/var/www/html`.
8. **Configuration** (`create-configuration.yml`, `configure-wordpress.yml`) — Génération de `wp-config.php` et du virtual host Apache à partir des templates.

**Structure du rôle :**

- `defaults/main.yml` — Variables par défaut (surchargeables).
- `vars/main.yml` — Variables communes.
- `vars/Debian.yml` et `vars/RedHat.yml` — Variables spécifiques à chaque famille d’OS.
- `tasks/main.yml` — Point d’entrée ; inclut les fichiers de tâches listés ci-dessus.
- `templates/` — `wp-config.php.j2`, `wordpress-vhost.conf.j2`.

### Variables

**Variables par défaut** (`defaults/main.yml` — à surcharger en priorité) :

| Variable | Description | Défaut |
|----------|-------------|--------|
| `wordpress_db_name` | Nom de la base WordPress | `wordpress` |
| `wordpress_db_user` | Utilisateur MySQL pour WordPress | `example` |
| `wordpress_db_password` | Mot de passe de cet utilisateur | `examplePW` |
| `mysql_root_password` | Mot de passe root MySQL/MariaDB | `examplerootPW` |
| `wordpress_download_url` | URL du ZIP WordPress | `https://wordpress.org/latest.zip` |
| `wordpress_install_dir` | Répertoire d’installation web | `/var/www/html` |
| `wordpress_admin_email` | E-mail admin WordPress | `admin@localhost` |
| `wordpress_table_prefix` | Préfixe des tables WP | `wp_` |

**Variables définies par OS** (dans `vars/Debian.yml` et `vars/RedHat.yml`) — exemples : noms des paquets Apache/PHP/MariaDB, service httpd (`apache2` vs `httpd`), chemins de configuration, utilisateur/groupe web (`www-data` vs `apache`). Elles sont chargées automatiquement selon `ansible_facts['os_family']`.

Pour un déploiement réel, redéfinir au minimum dans le playbook ou dans un fichier de variables (ou via Ansible Vault) : `wordpress_db_user`, `wordpress_db_password`, `mysql_root_password`.

### Exécution

**Prérequis :** Ansible 2.12+, accès SSH (ou connexion locale) aux hôtes cibles.

**Option 1 — Playbook fourni** (depuis la racine du projet) :

```bash
# Fichier d’inventaire (ex. inventory.yml ou hosts)
# [all]
# host1 ansible_host=...
# host2 ansible_host=...

ansible-playbook -i inventory playbook.yaml
```

**Option 2 — Utiliser le rôle depuis un playbook externe** (par exemple si le rôle est dans `roles/` ou installé via Galaxy) :

```yaml
- name: Deploy WordPress
  hosts: wordpress_servers
  roles:
    - role: chemin_vers_role_ou_nom_galaxy
      vars:
        wordpress_db_user: mon_user
        wordpress_db_password: "{{ vault_wp_db_password }}"
        mysql_root_password: "{{ vault_mysql_root_password }}"
```

**Exemple d’inventaire minimal :**

```ini
[all]
ubuntu-server ansible_host=192.168.1.10 ansible_user=ubuntu
rocky-server  ansible_host=192.168.1.11 ansible_user=rocky
```

**Conseil :** Tester sur au moins un conteneur Debian/Ubuntu et un Rocky Linux ; en conteneur sans systemd, le rôle utilise des commandes de démarrage alternatives (apachectl, mariadbd).

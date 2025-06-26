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

1. Créer un rôle Ansible complet à partir du script install_wordpress.sh. 

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


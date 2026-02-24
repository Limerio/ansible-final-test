# Variables
COMPOSE = docker compose

# Démarrer l’environnement
start:
	@echo " Demarrage environnement de travail..."
	@$(COMPOSE) up -d

# Arrêter l’environnement
stop:
	@echo "Arret environnement de travail..."
	@$(COMPOSE) down -v

# Redémarrer (arrêt + démarrage)
restart: stop start

# Afficher les logs
logs:
	@$(COMPOSE) logs -f

# Liste des conteneurs
list:
	@$(COMPOSE) ps

# Aide
help:
	@echo "Commandes disponibles :"
	@echo "  make start      Lancer environnement de travail"
	@echo "  make stop       Arreter environnement de travail"
	@echo "  make restart    Redemarrer environnement de travail"
	@echo "  make logs       Voir les logs environnement de travail"
	@echo "  make list       Voir les conteneurs actifs environnement de travail"

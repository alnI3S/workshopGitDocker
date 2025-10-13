# Docker : La conteneurisation pour un développement efficace

## 1️⃣ Avantages de Docker

- **Environnements reproductibles**: Les conteneurs s’exécutent de manière identique sur toutes les machines.
- **Isolation**: Chaque projet a son propre environnement, sans conflits de dépendances.
- **Portabilité**: Facile à partager et déployer, du développement à la production.
- **Efficacité**: Utilisation optimisée des ressources par rapport aux machines virtuelles.
- **Collaboration**: Permet de travailler avec plusieurs conteneurs interconnectés sur un même réseau.

## 2️⃣ Préparation d’un Dockerfile

- Présentation des instructions de base pour créer une image Docker.
- Utilisateur non root
- Exemple d'un `Dockerfile`
- Création d'un image Docker: `docker build --rm --tag <nom_image:tag> <chemin_Dockerfile> <chemin_dossier>`

## 3️⃣ Arguments courants pour lancer un conteneur

- Présentation des argument courants pour lancer un conteneur.
- Exemple: lancement d'un conteneur: `docker run --rm -it --env DISPLAY=$DISPLAY --volume /tmp/.X11-unix image_docker:tag`

- Partager: Sauvegarde l'image sur Docker Hub.

## 4️⃣ VSCode et Docker : Développer dans un conteneur

- Configuration avec l’extension "**Dev Containers**"
- Avantages :
    - Environnement de développement **consistant** pour toute l’équipe.
    - Extensions VSCode installées **directement dans le conteneur**.
    - Possibilité de préconfigurer des outils et dépendances pour chaque projet.

## Résumé des points clés
# TP3 Docker : La conteneurisation pour un développement efficace

## 1️⃣ Docker
Vérification de l'installation de Docker avec ces commandes:
```
# vérifer la version:
docker --version

# lister les images Docker disponibles:
docker images

# lister les réseaux de Docker
docker network ls

# lancer un container avec l'image de base ubuntu
docker run -it --rm ubuntu:latest bash
```
Maintenant vous êtes dans le containeur Ubuntu, essayez cette commande:
```
cat /lib/os-release

exit
```
**Notes**:
- L'argument `--rm` est utile pour quitter le conteneur et le supprimer automatiquement après la sortie. Sinon il faut stopper et supprimer avec les commandes `docker stop <container_id>` et `docker rm <container_id>`.

- Sans l'argument `-it` le conteneur s'exécute en arrière-plan et ne permet pas d'interagir avec lui via un terminal interactif.

- La commande `docker ps -a` liste les conteneurs en cours d'exécution.

## 2️⃣ Préparation d’un Dockerfile
On va commencer par un exemple simple avec l'iamge de base `Ubuntu:22.04` avec:
- installation du package `x11-apps` pour tester une application graphique,
- l'ajout d'un utilisateur non-root,
- Copy d'in script bash `entrypoint.sh` pour personnaliser le démarrage du conteneur. Ce fichier doit être créé dans le même répertoire que le Dockerfile pour cet exemple.

1) Créez le fichier `entrypoint.sh` avec ce contenu:
```
#!/bin/bash

if [ -n "${LOCAL_USER_ID}" ]; then
echo "Starting with UID: $LOCAL_USER_ID"
usermod -u $LOCAL_USER_ID user
# add other customization linux commandes here
fi
```
2) Créez le fichier Dockerfile qui permet de créer notre image Docker. Voici son contenu:

```
# image de base
FROM    ubuntu:22.04

# installer des packages d'Ubuntu
RUN apt update && apt install -qqy x11-apps \
    python3 python3-pip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# install jupyter lab
RUN pip install jupyterlab

# ajout d'un utilisateur non-root
RUN useradd --shell /bin/bash -u 1001 -c "" -m user

# personnalisation avec LOCAL_USER_ID comme utilisateur non-root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x  /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# commande par défaut
CMD ["/bin/bash"]
```

**Note**: On peut aussi créer directement le fichier `entrypoint.sh` dans le Dockerfile au lieu d'utiliser le mot cle `COPY`. On remplace alors la section correspondante:
```
# personnalisation avec LOCAL_USER_ID comme utilisateur non-root
RUN echo '#!/bin/bash\n\
if [ -n "${LOCAL_USER_ID}" ]; then\n\
echo "Starting with UID: $LOCAL_USER_ID"\n\
usermod -u $LOCAL_USER_ID user\n\
fi\n\
exec /bin/bash' > /entrypoint.sh && \
chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
```

### Les instructions de base pour créer un Dockerfile.

|   Instruction             |Description         |
|----------------|-------------------------------|
|**FROM**	|	Définit l’image de base (ex: `FROM ubuntu:22.04`). |
|**ENV**	|	Définit des variables d’environnement (ex: `ENV PATH="/usr/local/bin:${PATH}"`). |
|**ARG**	|	Définit des variables de build (ex: `ARG USER_ID=1000`). |
|**RUN**	|	Exécute des commandes pendant le build (ex: `RUN apt-get update`).	|
| **COPY**	|	Copie des fichiers depuis le host vers l’image (ex: `COPY app.js /app/`). |
|**USER**	|	Définit l’utilisateur pour exécuter les commandes (ex: `USER appuser`).	|
|**ENTRYPOINT**	|	Définit la commande principale du conteneur (ex: `ENTRYPOINT ["node", "app.js"]`).	|
|**CMD**	|	Définit les arguments par défaut pour ENTRYPOINT (ex: `CMD ["--help"]`).	|

Vous trouvez le document de référence Docker [ici](https://docs.docker.com/reference/).

**Remarque**:

- `ENTRYPOINT` et `CMD` peuvent être utilisés ensemble : `ENTRYPOINT` définit l’exécutable, `CMD` ses arguments par défaut.
- `ARG` est utilisé pendant le build, tandis que `ENV` persiste dans le conteneur final.

### Recherche d'image de base
Pour votre projet plus complexe par exemple vous voulez une image avec: `ubuntu22.04`, `cuda12.2` et `pytorch`alors vous pouvez rechercher une image de base sur [Docker Hub](https://hub.docker.com/) ou avec une recherche internet comme : `docker hub ubuntu 22.04 cuda12.2 pytorch`.

Le [**Multi-stage builds**](https://docs.docker.com/build/building/multi-stage/) permet d'optimiser la taille de l'image. Voici un [exemple](https://github.com/Genesis-Embodied-AI/Genesis/blob/main/docker/Dockerfilehttps://github.com/Genesis-Embodied-AI/Genesis/blob/main/docker/Dockerfile) de Dockerfile, aidez-vous d'une assistante IA pour comprendre son contenu.

### Build: Créer une image à partir d'un Dockerfile
Voici une commande pour créer une image Docker:
```
docker build --rm --tag <image_name:tag_name> --file <path_to_Dockerfile> .
```
N'oubliez pas le point à la fin pour indiquer le contexte de build (le répertoire courant).

Si vous êtes dans le répertoire contenant le Dockerfile, vous pouvez oublier l'argument `--file`:
```
docker build --rm --tag ubuntu:gui-app-user .
```

## 3️⃣ Arguments courants pour lancer un conteneur
|   Instruction             |Description         |
|----------------|-------------------------------|
| `-it`     | mode interactif. |
| `--rm`    | supprime le conteneur après l'arrêt. |
| `--gpus`  | Active l’accès aux GPU (ex: `--gpus all`).    |
| `--device`    |   Ajoute un périphérique (ex: --device=/dev/sda:/dev/xvda). |
| `--env` ou `-e`   |   Définit une variable d’environnement (ex: `-e NODE_ENV=production`).    |
| `--volume` ou `-v`    |   Monte un volume (ex: `-v $(pwd):/workdir`).    |
| `-w`  | se place dans le répertoire de travail (ex: `-w /workdir`). |
| `--network`   |   Connecte le conteneur à un réseau spécifique (ex: `--network=my-network`).  |
| `--name`  |   Donne un nom au conteneur (ex: `--name=my-container`).
| `--privileged` | donne des droits root au conteneur! |

### Run: démarrer un conteneur de travail

```
docker run --rm -it \
    --env=LOCAL_USER_ID="$(id -u)" \
    -v $(pwd):/workdir \
    -w /workdir \
    -u user \
    --name mon-conteneur \
    ubuntu:gui-app-user
```

Dans le conteneur, nommé "mon-conteneur", essayez cette commande pour lancer une application graphique:
```
xeyes
```

Cela ne va pas marcher, `exit` le conteneur et le relancez avec les options suivantes:
```
CCACHE_DIR=${HOME}/.ccache
CONFIG_DIR=${HOME}/.config
XAUTH=/tmp/.docker.xauth

xhost +local:docker

docker run --rm -it \
    --env=LOCAL_USER_ID="$(id -u)" \
    --env DISPLAY=$DISPLAY \
    --env=CCACHE_DIR="${CCACHE_DIR}" \
    --env=CONFIG_DIR="${CONFIG_DIR}" \
    -v ${CCACHE_DIR}:${CCACHE_DIR}:rw \
    -v ${CONFIG_DIR}:${CONFIG_DIR}:rw \
    -v /tmp/.X11-unix:/tmp/.X11-unix/:rw \
    -v $XAUTH:$XAUTH \
    -v $(pwd):/workdir \
    -w /workdir \
    -u user \
    --name mon-conteneur \
    ubuntu:gui-app-user
```

essayez maintenant la commande `xeyes`.

Pour simplifier le lancement, on peut créer un script bash `launch.sh` comme ceci:
```
#! /bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -r WORKDIR -d HOMEDIR -i DOCKER_REPO -n CONTAINER_NAME -c COMMAND"
   echo -e "\t-r working directory on host"
   echo -e "\t-d working directory in container"
   echo -e "\t-i docker repo"
   echo -e "\t-n containe name"
   echo -e "\t-c command"
   exit 1 # Exit script after printing help
}

while getopts "r:d:i:n:c" opt
do
   case "$opt" in
      r ) WORKDIR="$OPTARG" ;;
      d ) HOMEDIR="$OPTARG" ;;
      i ) DOCKER_REPO="$OPTARG" ;;
      n ) CONTAINER_NAME="$OPTARG" ;;
      c ) COMMAND="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# give default options:
if [ -z ${WORKDIR+x} ]; then
	WORKDIR="$(pwd)"
else
	echo "WORKDIR is set to '$WORKDIR'";
fi

if [ -z ${HOMEDIR+x} ]; then
	HOMEDIR="workdir"
else
	echo "HOMEDIR is set to '$HOMEDIR'";
fi

if [ -z ${COMMAND+x} ]; then
	COMMAND="bash"
else
	echo "COMMAND is set to '$COMMAND'";
fi

# Print helpFunction in case parameters are empty
if [ -z "$DOCKER_REPO" ] || [ -z "$CONTAINER_NAME" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# enable access to xhost from the container
# be carefull, this command exposes your machine and makes sure that anyone can connect to it [https://www.baeldung.com/linux/docker-container-gui-applications].
# xhost +

# Thus, it’s better to specify the source of the connections that we want.
xhost +local:docker

# docker hygiene

#Delete all stopped containers (including data-only containers)
#docker rm $(docker ps -a -q)

#Delete all 'untagged/dangling' (<none>) images
#docker rmi $(docker images -q -f dangling=true)

echo "DOCKER_REPO: $DOCKER_REPO";

CCACHE_DIR=${HOME}/.ccache
# mkdir -p "${CCACHE_DIR}"

XAUTH=/tmp/.docker.xauth

docker run -it --rm --privileged --gpus all \
--env=LOCAL_USER_ID="$(id -u)" \
--env=CCACHE_DIR="${CCACHE_DIR}" \
-v ${CCACHE_DIR}:${CCACHE_DIR}:rw \
-v /tmp/.X11-unix:/tmp/.X11-unix/:rw \
-v $XAUTH:$XAUTH \
-v $WORKDIR:$HOMEDIR \
-v /dev:/dev/ \
-w $HOMEDIR \
-e DISPLAY=$DISPLAY \
-e NVIDIA_VISIBLE_DEVICES=all \
-e NVIDIA_DRIVER_CAPABILITIES=all \
-e QT_X11_NO_MITSHM=1 \
--network=host \
--name=${CONTAINER_NAME} ${DOCKER_REPO} ${COMMAND}
```

Donnez le droit d'exécution à ce script avec:
```
sudo chmod +x launch.sh

```

Lancez votre container avec:
```
./launch.sh -r $(pwd) -d /workdir -i "ubuntu:gui-app-user" -n mon-conteneur

```
### Partager: Sauvegarde l'image sur Docker Hub

La procédure pour partager votre image sur Docker Hub consiste à:
1) vous connecter avec votre compte Docker Hub
2) taguer votre image avec votre login Docker Hub
3) pousser votre image sur Docker Hub

```
docker login

docker tag <nom_image:tag> <login_docker/nom_image:tag>

docker push <login_docker/nom_image:tag>
```
### gestion du conteneur
- pour ouvrir un terminal dans le conteneur: `docker exec -it <nom_conteneur> /bin/bash`. Ajoutez `--user root` si vous voulez être root dans le conteneur.

### gestion des images Docker

- Nettoyer les images Docker inutilisées: `docker rmi <image:tag> <image_ID>`
- Nettoyer les images corrompues: `docker image prune`. **Surtout ne pas** ajouter un s dans "image" sinon vous allez supprimer toutes les images sur votre machine!
- Nettoyer les caches de build: `docker builder prune`

## 4️⃣ Configurer VSCode pour Docker
- Installation de l'extension **Dev Containers**:
    - Allez dans le menu latéral **Extensions**,
    - Cherchez **Dev Container** et installez-le.
- Installation de l'extension **Remote Development**
    - Faites la même chose que précédemment pour **Remote Development**.

**En local**: l'extension **Dev Containers** utilise les configurations par défaut dans: `~/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers/imageConfigs/<votre_image_docker>.json`. voici un exemple:
```
{
	"extensions": [
		"github.copilot",
		"github.copilot-chat",
		"github.vscode-pull-request-github",
		"ms-ceintl.vscode-language-pack-fr"
	]
    "remoteUser": "user",
	"containerUser": "user"
}
```

Pour créer le fichier de configuratuion pour un conteneur dans VSCode, voici les démarches à suivre:
- Lancez un container avec l'image de votre choix
- Dans VSCode, attachez le container à votre session:
    - Allez dans le menu latéral **Explorateur distant**,
    - Dans le sélectionneur le conteneur actuelle pour l'ouvrir dans VSCode dans votre fenêtre actuelle ou nouvelle fenêtre de VSCode.
- Ouvrez la **Palette de commandes** avec Ctrl+Maj+P et entrez la commande `Add Development Container Configuration Files...`
- Sélectionnez le json de l'image de votre choix et entrez par exemple les 2 dernières lignes de l'exemple ci-dessus pour configurer VSCode pour un utilisateur non root..




**(Option) A distant/Remote** VSCode utilise le fichier de configuration par défaut: `~/.ssh/config`. Voici un exemple de configuration pour se connecter à la machine `serveur2` :
```
Host <serveur.labo.univ.fr>
  HostName <serveur.labo.univ.fr>
  IdentityFile </home/votre_login/>.ssh/id_rsa
  User <votre_login_labo>
  ForwardAgent yes

# Host <autre_serveur_labo>
#   HostName <autre_serveur_labo>
#   User <votre_login_sur_ce_serveur>
#   ForwardAgent yes
Host <autre_serveur.labo.univ.fr>
  HostName <autre_serveur_labo.labo.univ.fr>
  User <votre_login_sur_ce_serveur>
  ForwardAgent yes
  ProxyCommand ssh -q -W %h:%p serveur.labo.univ.fr

Host <serveur2.labo.univ.fr>
  HostName <serveur2.labo.univ.fr>
  User <votre_login_labo>
  ProxyJump <votre_login_labo>@serveur.labo.univ.fr
  ForwardX11 yes
  Compression yes
  RemoteCommand apptainer run --nv /home/<votre_login_labo>/path/to/your/converted_image.sif

```
### Utiliser une image Docker sur serveur2:

Si votre image est partagée sur Docker Hub, voici les procédures pour l'uliser dans le serveur ***serveur2***:
1) connectez-vous sur serveur2:
```
ssh -J <your_login_labo@serveur.labo.univ.fr> <your_login_labo@serveur2.labo.univ.fr>
```
2) placez-vous dans votre répertoire de travail et utilisez une session interactive de 15 minutes:
```
salloc --mem=44G --cpus-per-task=6 --gpus=slice --time=00:15:00
```
3) préconfigurez votre environnement:
```
apptainer run --nv docker://<login_docker/image:tag>
```
4) lancez `jupyter-lab`:
```
jupyter lab --ip='<xxx.xxx.xxx.xxx>' --no-browser
```
5) dans un autre terminal (local), connectez-vous sur serveur2 et lancez:
```
ssh -N -L localhost:8888:<xxx.xxx.xxx.xxx>:8888 your_login_labo@serveur2.labo.univ.fr
```
6) appuyez ctrl+click sur l'url de jupyter-lab. Vous devez voir votre environnement de travail dans votre navigateur.

## Résumé des points clés
- Docker permet de **créer des environnements isolés et reproductibles**.
- Les instructions `FROM`, `ENV`, `ARG`, `RUN`, `COPY`, `USER`, `ENTRYPOINT`, et `CMD` sont essentielles pour créer un `Dockerfile`.
- Les flags `--device`, `--gpus`, `--env`, `-v`, `--network`, et `--name` permettent de personnaliser le lancement des conteneurs.
- L’extension **Dev Containers** de VSCode facilite le développement dans des conteneurs, en offrant une intégration transparente avec l’éditeur.
- Savoir créer une image Docker à partir d’un `Dockerfile` et savoir démarrer un conteneur avec prise en charge d'application graphique.
- Savoir configurer l'utilisateur non root qui est très important tant pour la sécurité que pour l'accès aux fichiers créés dans le conteneur.
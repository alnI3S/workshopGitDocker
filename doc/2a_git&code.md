# TP1 - Démarrer avec Git et Code

## 1️⃣ Identification et authentificaton

### 1-1) **Configurer Git** (`git config`) : 
Définir votre identité (nom, email) pour que vos contributions soient reconnues. Remplacez les blocs `<..>` par votre nom et email dans ces commandes:
```
git config --global user.name <votre_nom>
git config --global user.email <votre@email.com>
```
Visualisation de toutes les configurations actives (locale + globale + système):
```
git config --list
```
ou visualisation uniquement les configurations utilisateur:
```
git config --global --list
```

### 1-2) **Tokens d’authentification**: 
Sécuriser vos interactions avec les dépôts distants (GitHub, GitLab) pour pousser (`push`) ou récupérer (`pull`) du code.
- Sur GitHub, connectez-vous avec votre identiant et mot de passe, puis générez un token d'accès personnel, comme suit:
    - Cliquez sur le logo de **votre profile > Settings > Developer settings > Personal access tokens > Tokens (classic) > Generate new token > Generate new token (classic)**.
    - Remplissez/Cochez les champs: `name: devtoken`, `scope: repo`.
    - Cliquez sur **Generate token** et <span style="color:red; font-weight:bold;">gardez votre token précieusement pour cet atelier.</span>
        - **Note**: si vous perdez votre token vous pouvez toujours regénérer un nouveau et effacer l'ancien sur le site GitHub.
- Automatisation de l'accès token: enregistrement du token dans un fichier sur votre ordinateur afin de nep as avoir à les saisir à chaque interaction avec un dépôt distant (GitHub, GitLab, Koda).
```
git config --global --add credential.helper "store --file ~/.git-credentials"
chmode 600 ~/.git-credentials  # Restreint les permissions du fichier
```
- (Option) Voir/Supprimer la configuration:
```
git config --global --get-all credential.helper
git config --unset credential.helper
```
## 2️⃣ Gérer le travail efficacement

### 2-1) Création d'un projet en local (local repo):
Nous abordons Git par le sens local -> distant (remote): nous mettrons notre code à disposition du public. L'autre sens (distant -> local) où l'on récupe un code disponible sur GitHub puis le modifie, sera traité dans le TP2.

Créez un répertoire `monAtelierGit/`pour votre projet et y créez un fichier `README.md` avec ce contenu: 
```
# Mes notes pour l'atelier Git, Docker et Code du 14 Octobre 2025
```

### 2-2) Git: Les bases
**Cycle de vie** des fichiers dans Git: `untracked` -> `staged` -> `committed`.

**Synchronisation** : local repo <-> remote repo.

Allez dans ce répertoire et initialisez votre dépôt Git local:
```
cd monAtelierGit/
git init
```
Vous pouvez voir le fichier `.git/` qui contient les données de votre dépôt Git. La commande `git status` permet de voir l'état actuel de votre projet. N'hésitez pas à l'utiliser après chaque modification pour vérifier l'état de vos fichiers.

**Note**: `git init` crée automatiquement la branche `main` par défaut.

Ajoutez votre fichier `README.md` et commitez.validez le changement:
```
git add . # ajouter tous les fichiers du répertoire courant
git commit -m "Premier commit"
```
**Note**: 
 1) Si vous voulez ajouter un certain nombre de fichiers seulement, utilisez `git add fichier1 fichier2`.
 2) Si vous voulez modifier votre dernier commit, utilisez la commande `git commit --amend`.

### 2-3) **Outils: diff et merge** : 
Git dispose deux outils en ligne de commande: `git diff` pour comparer et `git merge` pour fusionner les commits. Vous pouvez essayer la commande `git diff` dans votre projet. Nous les délaissons au détriment de la version plus pratique `git difftool`, `git mergetool` pour visualiser et résoudre les conflits directement dans Code.

**Configuration de Code** : Configurer Code comme éditeur par défaut pour Git, et utiliser ses outils intégrés pour les diffs et les fusions.

Faire de Code l'éditeur par défaut:
```
git config --global core.editor 'code --wait'
```
Configurer Code comme outil de diff/merge:
```
git config --global diff.tool Code
git config --global difftool.Code.cmd 'code --wait --diff $LOCAL $REMOTE'
git config --global merge.tool Code
git config --global mergetool.Code.cmd 'code --wait $MERGED'
```
Voir la configuration (dans le fichier `~/.gitconfig`):
```
git config --global -e
```
Modifiez/Ajoutez du texte dans votre fichier `README.md` et testez la commande `git difftool`.

## 3️⃣ Partager/Sauvegarder le code sur GitHub
- **Collaboration simplifiée** : Pousser votre code sur GitHub pour le partager avec votre équipe ou la communauté.
- **Intégration fluide** : Code facilite les commits, les pushes, et les revues de code grâce à ses extensions (comme GitLens).

### 3-1) Projet sur GitHub (remote repo):
Vous allez héberger votre projet sur GitHub en mode `Public` ou `Private` et syncroniser votre dépôt local avec le dépôt distant.
- Connectez-vous avec votre compte GitHub pour créer un nouveau dépôt (remote repo) comme suit:
    - Cliquez sur le logo de **votre profile > Repositories > New**
    - Remplissez les champs:
        - ***Repository name***:  *monAtelierGit*,
        - ***Description*** avec par exemple le texte *atelier pratique Git, Docker avec  Code.*, 
        - ***Configuration/Choose visibility***: `Public` (ou `Private` si vous ne voulez pas partager),
        - ***Configuration/Add README***: *Off*,
        - ***Configuration/Add .gitignore*****: *No*,
        - ***Configuration/Add license***: *MIT*.
        - copiez l'URL de votre projet pour la suite.

### 3-2) Association projet local <-> projet distant:
- Retournez dans le terminal de Code, exécutez la commande suivante pour ajouter le dépôt distant à votre dépôt local:
    ```
    git remote add origin <votre_url_copié>
    ```
    **Note**: la commande `git remote -v` permet de vérifier que le dépôt distant est bien lié à votre dépôt local.
- Comme vous avez ajouté un fichier license (MIT) dans le dépot distant, vous devez le récupérer dans votre dépôt local:
    ```
    git fetch origin
    ```
- et fusionner les changements distants avec votre branche locale:
    ```
    git rebase origin/main
    ```
    **Note**: Pour ce début nous n'utilisons pas `git merge`, nous réservons cette commande pour plus tard.

- Maintenant vous pouvez lier votre branche locale actuelle (`main`) à votre branhce distante (`origin/main`):
    ```
    git push --set-upstream origin main
    ```
    Pour les prochains pushes sur cette branche un simple `git pull` pour récupérer les changements à distant et `git push` pour envoyer les changements en local suffira.

N'hésitez pas à vérifier l'état de votre dépôt avec `git status` et son historique `git log`:
```
git status
```
```
git log
```

## 4️⃣ Travail au quotidien
1) Quand vous modifiez/ajoutez votre code, vous utilisez `git add` et `git commit` comme dans la section 2.2.
2) Mettez à jour (récupérez) les changements distants:
    ```
    git pull
    ```
3) et envoyez vos changements:
    ```
    git push
    ```

### Pratique 1
1) Ajoutez un fichier ou modifiez un fichier existant de votre dépôt: utiliser `git add` et `git commit`,

2) Sauvegardez les changements sur GitHub: utilisez `git push`.

### (Bonus) Pratique 2
On va refaire la même chose mais cette fois-ci on va utiliser Code pour visualiser les changements et les sauvegarder sur GitHub.

1) ajoutez/modifiez un fichier de votre dépôt. Puis allez dans le menu latéral à gauche, sélectionnez **Control de code source (Ctsl + Maj + G)** puis section **Changements**:
    
    1-1) Cliquez sur le bouton "**+**" de "**Changements**" pour **Mettre en attente** (équivalent à `git add`) tous les fichiers ou cliquez seulement le bouton "**+**" du fichier que vous souhaitez **Mettre en attente**. 
    
    1-2) Une nouvelle section **Changements indexés** apparaît avec les fichiers que vous avez cliqué sur le bouton "**+**". Et le bouton **Validation** devient disponible.

    1-3) Cliquez sur **Validation** pour committer (équivalent à `git commit`) vos changements. Code va vous proposer d'entrer un message de commit, faites-le puis cliquez sur le logo "**check**" en forme de "v" pour valider le message.
    
    1-4) Synchronisez avec votre dépôt sur GitHub en cliquant sur "**Synchroniser les modifications**" (équivalent à `git push`).

# TP - Démarrer avec Git et VSCode
## 1) Identification et authentificaton
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
### 1-2) **Tokens d’authentification** : 
Sécuriser vos interactions avec les dépôts distants (GitHub, GitLab) pour pousser (`push`) ou récupérer (`pull`) du code.
- Sur GitHub, connectez-vous avec votre identiant et mot de passe, puis générez un token d'accès personnel, comme suit:
    - Cliquez sur le logo de **votre profile > Settings > Developer settings > Personal access tokens > Tokens (classic) > Generate new token > Generate new token (classic)**.
    - Remplissez/Cochez les champs: `name: devtoken`, `scope: repo`.
    - Cliquez sur **Generate token** et <span style="color:red; font-weight:bold;">gardez votre token précieusement pour cet atelier.</span>
        - **Note**: si vous perdez votre token vous pouvez toujours regénérer un nouveau et effacer l'ancien sur le site GitHub.
- Automatisation de l'accès token: enregistrement du token dans un fichier sur votre ordinateur afin de nep as avoir à les saisir à chaque interaction avec un dépôt distant (GitHub, GitLab, Koda).
```
git config --global --ad credential.helper "store --file ~/.git-credentials"
chmode 600 ~/.git-credentials  # Restreint les permissions du fichier
```
- (Option) Voir/Supprimer la configuration:
```
git config --global --get-all credential.helper
git config --unset credential.helper
```
## 2) Gérer le travail efficacement
### 2-1) Commencer un projet en local:
Créez un réperroire pour votre projet `monAtelierGit`et y créez un fichier `README.md` avec ce contenu: 
```
# Mes notes pour l'atelier Git, Docker et VSCode
```
initialisez un dépôt Git local:

### 2-2) **Outils de diff et merge** : 
Git dispose deux outils en ligne de commande: `git diff` pour comparer et `git merge` pour fusionner les commits. **Mais** nous les délaissons pour utiliser la version plus pratique `difftool`, `mergetool` dans VSCode.
Visualiser et résoudre les conflits directement dans VSCode.
- **Personnalisation de VSCode** : Configurer VSCode comme éditeur par défaut pour Git, et utiliser ses outils intégrés pour les diffs et les fusions.
## 3) Partager le code sur GitHub
- **Collaboration simplifiée** : Pousser votre code sur GitHub pour le partager avec votre équipe ou la communauté.
- **Intégration fluide** : VSCode facilite les commits, les pushes, et les revues de code grâce à ses extensions (comme GitLens).

# Utilisation Courante de Git - Concepts Clés
Git offre des outils puissants pour gérer les modifications de code de manière collaborative et organisée. Que ce soit pour travailler sur des branches, résoudre des conflits, ou synchroniser avec des dépôts distants, Git facilite le développement en équipe et assure la traçabilité des changements.

VSCode permet de visualiser et de gérer ces modifications de manière intuitive, en intégrant des outils de diff et de merge directement dans l’éditeur.

## 📥 Récupération d’un Projet sur GitHub
- **Forker un dépôt GitHub opensource**: Duppliquer un projet opensource sur GitHub.
- **Cloner un dépôt**: Utilisez `git clone` pour récupérer une copie locale d’un projet hébergé sur GitHub.
- **Mettre à jour un dépôt local**: Utilisez `git pull` pour synchroniser les dernières modifications depuis le dépôt distant.

## 🔄 Gestion des Modifications
- **Branches**: Utilisez `git branch` et git checkout pour travailler sur des fonctionnalités ou corrections de manière isolée.
- **Modification de code**: Modifiez les fichiers dans votre environnement local.
- **Diff Tool**: Utilisez `git difftool` ou des outils intégrés dans VSCode pour visualiser les différences entre les versions de fichiers.
- **Merge Tool**: Résolvez les conflits avec `git merge` ou des outils graphiques intégrés.
- **Revenir en arrière**: Utilisez `git reset` pour annuler des modifications.
- **Suppression des fichiers non suivis**: Nettoyez les fichiers inutiles avec `git clean`.

## 🔄 Synchronisation avec la Branche Distante
- **Pousser les modifications**: Utilisez `git push` pour envoyer vos changements locaux vers le dépôt distant.
- **Mettre à jour la branche distante**: Utilisez `git pull` pour intégrer les dernières modifications depuis le dépôt distant dans votre branche locale.

## 🌿 Utilisation Avancée des Branches
- **Cloner une branche spécifique**: Récupérez uniquement une branche particulière avec `git checkout -b <nom_branche> origin/<nom_branche>`.
- **Pousser une branche locale vers GitHub**: Partagez une nouvelle branche avec `git push -u origin <nom_branche>`.
- **Fusionner les branches**: Intégrez les modifications d’une branche dans une autre avec `git merge`.
- **Comparer les fichiers entre branches**: Identifiez les différences avec `git difftool <branche1>..<branche2>`.

## 📦 Gestion des Sous-Modules
- **Ajouter un sous-module**: Intégrez un autre dépôt Git avec `git submodule add`.
- **Mettre à jour un sous-module**: Synchronisez les modifications du sous-module avec `git submodule update`.

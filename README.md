# ChatApp Flutter

Une application de messagerie instantanée construite avec **Flutter** et **Firebase**. Cette application permet aux utilisateurs de discuter en temps réel, gérer leurs profils, réagir aux messages et afficher des avatars.

---

## Fonctionnalités principales

* **Authentification Firebase**

    * Inscription / Connexion via email et mot de passe.
    * Déconnexion et gestion de l'état utilisateur.

* **Chat en temps réel**

    * Messages envoyés et reçus instantanément.
    * Affichage des avatars des utilisateurs.
    * Emoticônes et réactions aux messages.

* **Profil utilisateur**

    * Affichage du profil d’un utilisateur lorsqu’on clique sur son avatar.
    * Possibilité de mettre à jour l’avatar, le nom d’utilisateur et la bio.

* **Historique des conversations**

    * Messages stockés dans **Cloud Firestore**.
    * Date et heure des messages affichées de manière lisible avec `intl`.

---

## Architecture du projet

Le projet est structuré comme suit :

```
lib/
├── model/
│   ├── Chat.dart
│   ├── ChatUser.dart
│   └── Message.dart
├── viewmodel/
│   ├── AuthViewModel.dart
│   ├── ChatUserViewModel.dart
│   └── ChatViewModel.dart
├── pages/
│   ├── login_page.dart
│   ├── signup_page.dart
│   ├── home_page.dart
│   ├── chat_page.dart
│   ├── profile_page.dart
│   └── splash_page.dart
├── widgets/
│   ├── ChatListItem.dart
│   ├── MessageItem.dart
│   └── LoadingScreen.dart
├── constants.dart
└── main.dart
```

---

## Installation

1. Cloner le dépôt :

```bash
git clone https://github.com/Stephanethr/tp_flutter_M2
cd tp_flutter_M2
```

2. Installer les dépendances :

```bash
flutter pub get
```

3. Configurer Firebase :

    * Créer un projet Firebase.
    * Ajouter l’application Android/iOS.
    * Télécharger le fichier `google-services.json` (Android) ou `GoogleService-Info.plist` (iOS) et placer dans le projet.
    * Activer **Authentication** (Email/Password) et **Cloud Firestore**.

4. Lancer l’application :

```bash
flutter run
```

---

## Packages utilisés

* `firebase_auth` : pour l’authentification des utilisateurs.
* `cloud_firestore` : pour le stockage et la récupération des messages.
* `intl` : pour le formatage des dates et heures.
* `flutter/material.dart` : pour l’UI Flutter.

---

## Contribuer

Les contributions sont les bienvenues !
Forkez le projet, créez une branche pour vos fonctionnalités et ouvrez une Pull Request.

---

## License

MIT License © Thiry Stéphane

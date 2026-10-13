# TP — Travail collaboratif avec Git Flow
## Projet : Boîte à outils d'administration Linux

**Durée indicative :** 1 heure
**Organisation :** groupes de 3 à 4 étudiants  
**Environnement :** Linux (Debian ou Ubuntu), Bash, Git et GitHub

---

## Contexte

Vous travaillez au sein d'une équipe d'administrateurs systèmes et réseaux chargée de développer une boîte à outils permettant d'automatiser différentes opérations d'administration sur des serveurs Linux.

Cette boîte à outils sera progressivement enrichie, testée et publiée par votre équipe.

Votre objectif n'est pas uniquement de développer des scripts fonctionnels : vous devez surtout mettre en place et respecter un véritable workflow de travail collaboratif avec Git et GitHub.

Pendant ce TP, vous devrez utiliser :

- Les branches Git
- Git Flow
- Les Pull Requests
- Les protections de branches
- La revue de code
- La gestion de conflits
- Les branches `feature/*`
- Les branches `fix/*`
- Les branches `release/*`
- Les branches `hotfix/*`
- Les tags de version

**Important :** toutes les opérations d'administration doivent pouvoir être testées dans un environnement Linux de laboratoire. Les scripts ne doivent pas provoquer de modifications dangereuses ou irréversibles sur les machines.

---

## 1. Création du projet

Un membre du groupe crée un repository GitHub destiné à accueillir la boîte à outils.

Le projet doit initialement contenir :

```text
linux-admin-toolkit/
├── scripts/
├── config/
│   └── toolkit.conf
└── README.md
```

Le fichier de configuration doit contenir au minimum :

- Un répertoire de destination pour les rapports
- Un seuil d'alerte d'utilisation du disque
- Un nom permettant d'identifier le serveur

Le README doit présenter brièvement le projet et expliquer son objectif.

Effectuez un premier commit sur `main`.

Tous les membres du groupe doivent ensuite récupérer le projet sur leur machine.

---

## 2. Mise en place de Git Flow

Mettez en place une organisation permettant de distinguer :

- La version stable du projet
- La version en cours de développement
- Les nouvelles fonctionnalités
- Les corrections de bugs
- La préparation des versions
- Les corrections urgentes en production

L'organisation principale doit respecter les conventions suivantes :

- `main` : version stable
- `develop` : prochaine version en cours de développement
- `feature/*` : nouvelles fonctionnalités
- `fix/*` : corrections classiques
- `release/*` : préparation d'une version
- `hotfix/*` : corrections urgentes de production

Chaque membre doit comprendre le rôle de ces branches avant de commencer les développements.

---

## 3. Protection du repository

Configurez GitHub afin d'interdire les modifications directes sur les branches `main` et `develop`.

Les règles suivantes doivent être appliquées :

- Interdiction des push directs
- Obligation de passer par une Pull Request
- Obligation d'obtenir deux validations avant une fusion

À partir de maintenant, aucune modification ne doit être directement effectuée sur `main` ou `develop`.

**Attention :** selon les fonctionnalités disponibles sur votre compte GitHub et le type de repository, certaines règles de protection peuvent ne pas être applicables. Dans ce cas, documentez la limitation et respectez les règles manuellement.

---

## 4. Première phase — Développement des fonctionnalités

Chaque membre doit développer une fonctionnalité indépendante à partir de `develop`.

Les scripts doivent être réalisés en Bash.

### Administrateur 1 — Surveillance des ressources système

Créer un script `system-monitor.sh`.

Ce script doit :

- Afficher le nom du serveur
- Afficher la date et l'heure
- Afficher l'utilisation de la mémoire
- Afficher l'utilisation des principaux systèmes de fichiers
- Afficher la charge du système
- Générer un rapport texte dans le répertoire prévu par la configuration

Le rapport doit être suffisamment lisible pour être exploité par un administrateur.

### Administrateur 2 — Vérification des services

Créer un script `service-check.sh`.

Ce script doit :

- Accepter le nom d'un service en paramètre
- Vérifier si le service existe
- Déterminer si le service est actif ou inactif
- Afficher un message adapté à son état
- Permettre de vérifier plusieurs services successivement
- Enregistrer les résultats dans un rapport

Le script ne doit pas démarrer ou arrêter automatiquement les services.

### Administrateur 3 — Vérification réseau

Créer un script `network-check.sh`.

Ce script doit :

- Afficher les principales informations réseau de la machine
- Identifier les adresses IP configurées
- Tester l'accessibilité d'une machine distante
- Permettre de préciser la cible à tester
- Afficher un résultat compréhensible en cas d'échec
- Enregistrer les résultats des tests dans un rapport

Le script doit gérer les cas où la cible est inaccessible ou lorsqu'un paramètre est invalide.

### Administrateur 4 — Analyse des journaux système

Créer un script `log-analyzer.sh`.

Ce script doit :

- Lire un fichier journal fourni en paramètre
- Vérifier que le fichier existe et est accessible
- Compter le nombre total de lignes
- Identifier les lignes contenant des erreurs ou avertissements
- Produire un résumé des résultats
- Enregistrer ce résumé dans un rapport

Le script doit fonctionner avec un fichier journal de test sans nécessiter de privilèges administrateur.

### Adaptation pour les groupes de 3

Dans un groupe de trois étudiants, la fonctionnalité d'analyse des journaux est répartie entre les membres du groupe.

La répartition doit être équitable et documentée dans le README.

---

## 5. Commits et publication

Chaque administrateur travaille uniquement sur sa branche de fonctionnalité.

Le travail doit être organisé en plusieurs commits pertinents.

Les messages de commit doivent permettre de comprendre les modifications réalisées.

Une fois la fonctionnalité terminée :

1. Publiez votre branche sur GitHub.
2. Créez une Pull Request vers `develop`.
3. Demandez une revue aux autres membres du groupe.

Il est interdit de fusionner immédiatement sa propre Pull Request.

---

## 6. Code Review

Chaque Pull Request doit être relue par au moins deux autres membres du groupe.

Les reviewers doivent vérifier :

- Le script répond au besoin fonctionnel
- Le code Bash est lisible et correctement structuré
- Les variables sont nommées de manière compréhensible
- Les paramètres sont correctement vérifiés
- Les erreurs prévisibles sont prises en compte
- Les chemins utilisés sont cohérents avec la configuration
- Le script ne présente pas de comportement dangereux
- Aucun fichier sans rapport avec la fonctionnalité n'a été modifié
- La Pull Request cible bien `develop`

Un reviewer peut :

- Approuver la Pull Request
- Ajouter un commentaire
- Demander une modification

Une Pull Request nécessitant une correction ne doit pas être fusionnée.

Le développeur concerné doit apporter la correction sur sa branche puis publier un nouveau commit.

La Pull Request doit automatiquement être mise à jour.

Une fois les deux validations obtenues, la branche peut être fusionnée dans `develop`.

---

## 7. Gestion d'un conflit

Après l'intégration des premières fonctionnalités, l'équipe souhaite améliorer le fonctionnement global de la boîte à outils.

Deux administrateurs doivent travailler simultanément sur le fichier de configuration commun :

`config/toolkit.conf`

Créez deux branches distinctes à partir du même état de `develop` :

- `feature/alerting`
- `feature/reporting`

Les deux administrateurs doivent travailler sans attendre que l'autre ait terminé.

### feature/alerting — Configuration des alertes

Modifier la configuration pour :

- Ajuster le seuil d'alerte disque
- Ajouter un seuil d'alerte mémoire
- Ajouter une option permettant d'activer ou désactiver les alertes
- Adapter le script de surveillance système pour exploiter ces paramètres

### feature/reporting — Configuration des rapports

Modifier la configuration pour :

- Adapter le répertoire de destination des rapports
- Ajouter une option de nommage des rapports
- Ajouter une option permettant d'activer ou désactiver leur génération
- Adapter au moins un script pour exploiter ces paramètres

### Contrainte importante

Les deux administrateurs doivent volontairement modifier certaines lignes communes dans `toolkit.conf`, notamment la ligne définissant le répertoire de destination des rapports.

Les modifications doivent être différentes afin de provoquer un véritable conflit lors de leur intégration.

Les deux branches doivent conserver une configuration cohérente et des scripts fonctionnels.

---

## 8. Première fusion

La branche `feature/alerting` est terminée en premier.

Créez une Pull Request vers `develop`.

Effectuez la Code Review.

Après deux validations, fusionnez la Pull Request.

La branche `develop` contient maintenant les nouvelles fonctionnalités d'alerte.

---

## 9. Apparition du conflit

L'administrateur travaillant sur `feature/reporting` termine ensuite son travail.

Entre-temps, `develop` a évolué.

Avant de finaliser sa Pull Request, il doit intégrer les dernières modifications de `develop` dans sa branche.

Un conflit doit apparaître dans `toolkit.conf`.

Analysez le conflit et identifiez :

- Les modifications provenant de `develop`
- Les modifications provenant de `feature/reporting`
- Les paramètres qui doivent être conservés
- Les éventuelles incohérences entre les paramètres

Résolvez manuellement le conflit afin de conserver les fonctionnalités d'alerte et de génération de rapports.

Vérifiez que le fichier de configuration est valide et que les scripts concernés fonctionnent.

Validez la résolution avec un commit puis publiez la branche mise à jour.

La Pull Request peut ensuite être revue et fusionnée.

---

## 10. Correction d'un bug

Après l'intégration des fonctionnalités, l'équipe découvre un problème dans `system-monitor.sh`.

Lorsque le seuil d'alerte disque est atteint, le script affiche systématiquement un état normal.

Le problème est lié à la comparaison entre le pourcentage d'utilisation du disque et le seuil configuré.

Ce bug concerne la version en cours de développement et n'est pas encore présent en production.

Réalisez une correction dans une branche de type `fix/*` créée depuis `develop`.

La correction doit :

- Identifier l'origine du problème
- Corriger la comparaison
- Gérer correctement les valeurs numériques
- Permettre de vérifier le comportement avec une valeur inférieure et une valeur supérieure au seuil

Créez une Pull Request vers `develop`.

La correction doit être validée par deux autres membres avant fusion.

---

## 11. Préparation de la version 1.0

Toutes les fonctionnalités prévues sont maintenant présentes dans `develop`.

L'équipe souhaite préparer la première version stable de la boîte à outils.

Créez une branche `release/1.0` depuis `develop`.

À partir de cette branche :

- Vérifiez le fonctionnement des différents scripts
- Vérifiez les paramètres attendus
- Vérifiez les messages d'erreur
- Vérifiez le comportement lorsque des fichiers ou services sont absents
- Vérifiez les permissions nécessaires à l'exécution
- Vérifiez que les rapports sont correctement générés
- Corrigez uniquement les petits problèmes nécessaires à la livraison
- Complétez le README avec les instructions d'installation et d'utilisation
- Ajoutez la mention « Version 1.0 »

Aucune nouvelle fonctionnalité ne doit être ajoutée pendant cette étape.

Lorsque la version est considérée comme stable, créez une Pull Request de `release/1.0` vers `main`.

Effectuez la Code Review.

Après deux validations, fusionnez la version.

La branche `main` représente maintenant la version 1.0 en production.

Créez le tag `v1.0`.

La branche de release doit également être réintégrée dans `develop` si elle contient des corrections réalisées pendant la préparation de la version.

---

## 12. Incident en production

Après la publication de la version 1.0, un problème urgent est découvert.

Le script `service-check.sh` ne distingue pas correctement un service inactif d'un service inexistant.

Dans les deux cas, il affiche un message indiquant que le service fonctionne normalement.

Cette erreur peut induire un administrateur en erreur lors d'un diagnostic.

La correction doit être mise en production immédiatement.

Il ne faut pas utiliser `develop`, car cette branche pourrait déjà contenir des modifications destinées à une future version.

Créez une branche `hotfix/service-status` directement depuis `main`.

Corrigez uniquement le problème demandé.

Le script doit désormais distinguer clairement :

- Un service actif
- Un service existant mais inactif
- Un service inexistant

Vérifiez ces trois situations avec des cas de test adaptés.

Effectuez un commit puis publiez la branche.

Créez une Pull Request vers `main`.

Effectuez la Code Review.

Après validation, fusionnez le hotfix.

Créez le tag `v1.0.1`.

---

## 13. Synchronisation de develop

Le problème corrigé dans `main` peut toujours exister dans `develop`.

La correction doit donc être réintégrée dans la branche de développement.

Assurez-vous que le comportement corrigé est présent dans :

- `main`
- `develop`

Cette synchronisation doit respecter les protections du repository et passer par une Pull Request si nécessaire.

À la fin de cette opération, la prochaine version de la boîte à outils ne doit pas réintroduire le problème corrigé en production.

---

## 14. État final attendu

À la fin du TP :

- `main` contient la version stable `v1.0.1`.
- `develop` contient les développements et la correction du hotfix.
- Les fonctionnalités ont été développées dans des branches `feature/*`.
- Une correction classique a été réalisée dans une branche `fix/*`.
- Une version a été préparée dans une branche `release/*`.
- Une correction urgente de production a été réalisée dans une branche `hotfix/*`.
- Les branches `main` et `develop` sont protégées.
- Les modifications passent obligatoirement par des Pull Requests.
- Les Pull Requests nécessitent deux validations.
- Un conflit Git a été rencontré et résolu.
- Chaque membre du groupe a participé aux Code Reviews.
- Les scripts Bash sont fonctionnels et documentés.

Le repository doit permettre de retrouver l'historique du travail collaboratif.

Les Pull Requests, commentaires et validations doivent rester consultables sur GitHub.

---

## 15. Questions de synthèse

À la fin du TP, chaque groupe doit être capable d'expliquer :

1. Pourquoi les branches `feature/*` sont créées depuis `develop` et non depuis `main`.
2. Pourquoi une Pull Request est utile même lorsqu'un script fonctionne correctement sur la machine de son auteur.
3. Pourquoi deux validations ont été imposées avant une fusion.
4. Pourquoi un conflit Git apparaît.
5. Pourquoi Git ne peut pas toujours résoudre automatiquement un conflit.
6. Pourquoi les fichiers de configuration partagés présentent un risque de conflit dans une équipe d'administrateurs.
7. Quelle est la différence entre une branche `fix/*` et une branche `hotfix/*`.
8. Pourquoi un hotfix est créé depuis `main`.
9. Pourquoi la correction d'un hotfix doit également revenir dans `develop`.
10. Quel est le rôle d'une branche `release/*`.
11. Quelle différence existe entre `develop` et `main` dans ce workflow.
12. Pourquoi les scripts d'administration doivent être testés avant leur intégration dans une version stable.
13. Quels risques pourrait présenter l'exécution d'un script Bash non relu sur un serveur de production.
14. Comment Git permet de retrouver une version antérieure d'un script ayant introduit un incident.

---

## Livrable

Chaque groupe doit transmettre le lien de son repository GitHub.

Le README doit impérativement préciser :

- Le nom et le prénom de chaque membre
- Le pseudo GitHub correspondant
- La répartition des fonctionnalités
- Les instructions d'utilisation des scripts
- Les prérequis techniques
- La version actuelle du projet

L'historique GitHub doit permettre de vérifier le respect du workflow, la participation des membres et la réalisation des différentes étapes du TP.
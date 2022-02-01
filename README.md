# Spot Discovery
## Description
Il s'agit d'un projet d'initiation à Flutter.
Vous utiliserez les données mises à votre disposition afin de constuire une interface simple.

## Collection Postman
Lien d'import : https://www.getpostman.com/collections/0c29f43a6b83d6547556

Vous y trouverez les requêtes suivantes :
- Liste de spots
- Liste de spots recommandés
- Détail d'un spot
- Ajout de commentaire

Ces requêtes pointent toutes vers une base de données Firebase avec pour base URL https://spot-discovery-5b840-default-rtdb.firebaseio.com

## Objectifs
1. Mettez à jour le **SpotManager** pour récupérer la liste des spots depuis l'API
2. À l'ouverture d'un spot, appelez l'API de détail. Puis grâce à la réponse détaillée :
   - Affichez la description
   - Utilisez le widget [PageView](https://api.flutter.dev/flutter/widgets/PageView-class.html) pour afficher la liste d'images

Pour ce point vous devrez d'abord modifier le modèle de donnée (la classe Spot)

3. Ajoutez un bouton `Like` (dans la vue de liste, la vue de détail ou les 2).
   En cliquant dessus, le spot sera ajouté (puis supprimé si on reclique) en base de donnée. Utilisez le package de votre choix.
   Ajoutez ensuite un moyen d'accéder à la liste des spots favoris, par exemple une bottom navigation bar sur la homepage.
4. Sur la vue de détail d'un spot, afficher la liste de commentaires et ajoutez la possibilité de poster un commentaire

## Historique
<details>
    <summary>Cours 1: Initiation à Flutter</summary>

## SpotManager
Vous trouverez dans ce projet le singleton **SpotManager** (lib/core/manager/spot_manager.dart) qui vous donne accès à une liste de spots.
Les données sont parsées depuis le fichier spots.json se trouvant dans le dossier `assets/json`.
La classe **Spot** (lib/core/model/spot.dart) représente un lieu et vous donne accès à de nombreuses informations sur celui-ci.

### Exemples d'utilisation
Récupérer la liste complète des spots :
```
List<Spot> fullSpotList = SpotManager().spots;
```

Récupérer une sous liste de spots :
```
List<Spot> spots = SpotManager().getSomeSpots();
List<Spot> moreSpots = SpotManager().getSomeSpots(startIndex: 15, endIndex: 30);
```

Récupérer un spot au hasard :
```
Spot randomSpot = SpotManager().getRandomSpot();
```

## Objectifs
1. Utilisez une ListView pour afficher la liste des spots. Faites apparaître les infos suivantes du Spot :
   - title
   - imageThumbnail
   - mainCategory : affichez  le `name`

2. Créez la page détail d'un spot, dans laquelle vous afficherez :
   - title
   - imageFullsize
   - address
   - trainStation (attention, la valeur peut-être null)
   - isRecommended : faites apparaître un bandeau avec le label `Recommandé` si **true**
   - isClosed : faites appaître un bandeau avec le label `Fermé` si **true**
   - tagsCategory : affichez les catégories dans une ListView

Lors du clic sur un élément de la liste de votre première vue, redirigez l'utilisateur sur la vue de détail.

3. Ajoutez un FloatingActionButton sur la page d'accueil.
   En cliquant sur ce bouton, vous récupérerez un spot au hasard dans la liste et l'afficherez dans la vue de détail

4. Implémentez une fonction **getSpotByName** dans le singleton `SpotManager`.
   Utilisez cette fonction pour implémenter une fonctionnalité de recherche par titre de spot dans votre application.

5. Affectez un **ScrollController** à votre ListView pour implémenter une liste paginée.
   Vous pouvez utiliser la fonction `getSomeSpots` pour simuler une pagination.
</details>

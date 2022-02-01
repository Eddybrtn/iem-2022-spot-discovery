import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iem_2022_spot_discovery/core/manager/api_manager.dart';
import 'package:iem_2022_spot_discovery/core/manager/database_manager.dart';
import 'package:iem_2022_spot_discovery/core/model/comment.dart';
import 'package:iem_2022_spot_discovery/core/model/spot.dart';

class SpotManager {
  List<Spot>? _spots;

  List<Spot> get spots => _spots ?? [];

  List<Spot>? _favoriteSpots;

  List<Spot> get favoriteSpots => _favoriteSpots ?? [];

  static final SpotManager _instance = SpotManager._internal();

  factory SpotManager() => _instance;

  SpotManager._internal();

  int get _spotListLength => _spots?.length ?? 0;

  /// Initialise les spots :
  /// - Via l'API pour la liste complète
  /// - Via la BDD pour les spots favoris
  Future<bool> initData() async {
    await Future.wait([loadAllSpots(), loadFavoriteSpots()]);
    return true;
  }

  /// Charge et renvoie la liste complète de spots
  Future<void> loadAllSpots() async {
    // Calling API
    try {
      var response = await ApiManager().getAllSpots();
      if (response.data != null) {
        // Mapping data
        _spots = List<Map<String, dynamic>>.from(response.data?["data"])
            .map((json) => Spot.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint("Erreur : $e");
    }
  }

  Future<void> loadFavoriteSpots() async {
    _favoriteSpots = await DatabaseManager().getFavoriteSpots();
  }

  bool isSpotFavorite(int idSpot) {
    try {
      return _favoriteSpots?.firstWhere((spot) => spot.id == idSpot) != null;
    } catch (e) {
      // Spot not found
      return false;
    }
  }

  Future<void> toggleFavorite(Spot spotToUpdate) async {
    bool isFavorite = await DatabaseManager().isFavorite(spotToUpdate.id);
    await DatabaseManager().toggleFavorite(isFavorite, spotToUpdate);
    if (isFavorite) {
      _favoriteSpots?.removeWhere((Spot spot) => spot.id == spotToUpdate.id);
    } else {
      _favoriteSpots ??= [];
      _favoriteSpots?.add(spotToUpdate);
    }
  }

  /// Renvoie un spot aléatoire de la liste pré-chargée
  Spot? getRandomSpot() {
    if (_spots?.isNotEmpty ?? false) {
      var random = Random();
      int randomIndex = random.nextInt(_spotListLength - 1);
      return _spots?[randomIndex];
    }
    return null;
  }

  /// Renvoie les spots de l'interval défini
  /// [startIndex] est l'index de début de l'interval
  /// [endIndex] est l'index de fin de l'interval
  List<Spot>? getSomeSpots({int startIndex = 0, int endIndex = 15}) {
    if ((_spots?.isNotEmpty ?? false) &&
        startIndex < _spotListLength &&
        startIndex < endIndex) {
      if (endIndex > _spotListLength) {
        endIndex = _spotListLength;
      }
      return _spots?.getRange(startIndex, endIndex).toList();
    }
    return null;
  }

  /// Renvoie les spots dont le titre contient la chapine de caractère passée
  /// en paramètre
  List<Spot> getSpotsByName(String name) {
    List<Spot> matchingSpots = [];
    if (_spots?.isNotEmpty ?? false) {
      for (Spot spot in _spots ?? []) {
        if (spot.title?.toLowerCase().contains(name.toLowerCase()) ?? false) {
          matchingSpots.add(spot);
        }
      }
    }
    return matchingSpots;
  }

  /// Récupère le détail d'un Spot
  Future<Spot?> getSpotDetail(int idSpot) async {
    Spot? spot;
    try {
      var response = await ApiManager().getSpot(idSpot);
      if (response.data != null) {
        spot = Spot.fromJson(response.data ?? {});
      }
    } catch (error) {
      debugPrint("Erreur : $error}");
    }
    return spot;
  }

  /// Poste un commentaire sur un spot
  Future<SpotComment?> sendComment(int idSpot, String comment) async {
    try {
      SpotComment spotComment = SpotComment(
          comment: comment, createdAt: DateTime.now().millisecondsSinceEpoch);
      var response = await ApiManager().postComment(idSpot, spotComment);
      if (response.data != null) {
        // Comment successfully sent
        return spotComment;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Erreur : $e");
      return null;
    }
  }
}

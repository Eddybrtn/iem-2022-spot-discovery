import 'package:flutter/material.dart';
import 'package:iem_2022_spot_discovery/core/manager/spot_manager.dart';
import 'package:iem_2022_spot_discovery/core/model/spot.dart';
import 'package:iem_2022_spot_discovery/ui/components/spot_list.dart';

class SpotListPage extends StatefulWidget {
  final bool isFromFavorite;

  const SpotListPage({Key? key, this.isFromFavorite = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SpotListPageState();
}

class _SpotListPageState extends State<SpotListPage> {
  @override
  Widget build(BuildContext context) {
    return SpotList(
      spots: widget.isFromFavorite
          ? SpotManager().favoriteSpots
          : SpotManager().spots,
      onFavoriteChanged: (Spot spot, bool shouldToggle) async {
        if (shouldToggle) {
          await SpotManager().toggleFavorite(spot);
        }
        setState(() {});
      },
    );
  }
}

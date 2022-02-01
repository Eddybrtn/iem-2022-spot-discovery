import 'package:flutter/material.dart';
import 'package:iem_2022_spot_discovery/core/manager/spot_manager.dart';
import 'package:iem_2022_spot_discovery/core/model/spot.dart';
import 'package:iem_2022_spot_discovery/ui/components/image_placeholder.dart';
import 'package:iem_2022_spot_discovery/ui/spot_detail.dart';

class SpotList extends StatelessWidget {
  final List<Spot> spots;
  final Function(Spot, bool)? onFavoriteChanged;

  const SpotList({Key? key, required this.spots, this.onFavoriteChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return spots.isNotEmpty ? ListView.builder(
      itemBuilder: (context, position) {
        Spot spot = spots[position];
        return InkWell(
          onTap: () async {
            bool oldFavorite = SpotManager().isSpotFavorite(spot.id);

            var newFavorite = await Navigator.of(context).pushNamed(SpotDetail.route,
                arguments: SpotDetailArguments(spot: spot));

            if (newFavorite is bool && newFavorite != oldFavorite) {
              onFavoriteChanged?.call(spot, false);
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    spot.imageThumbnail ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, child, stack) {
                      return const ImagePlaceholder();
                    },
                  )),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spot.title ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text("Catégorie : ${spot.mainCategoryName() ?? 'Inconnue'}")
                  ],
                ),
              ),
              IconButton(
                icon: Icon(SpotManager().isSpotFavorite(spot.id)
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  onFavoriteChanged?.call(spot, true);
                },
              ),
              const SizedBox(width: 16,)
            ],
          ),
        );
      },
      itemCount: spots.length,
    ) : const Center(child: Text('Aucun spot'),);
  }
}

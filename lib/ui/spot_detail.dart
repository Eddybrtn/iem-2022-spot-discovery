import 'package:flutter/material.dart';
import 'package:iem_2022_spot_discovery/core/manager/database_manager.dart';
import 'package:iem_2022_spot_discovery/core/manager/spot_manager.dart';
import 'package:iem_2022_spot_discovery/core/model/comment.dart';
import 'package:iem_2022_spot_discovery/core/model/spot.dart';
import 'package:iem_2022_spot_discovery/ui/components/image_placeholder.dart';

class SpotDetailArguments {
  Spot spot;

  SpotDetailArguments({required this.spot});
}

class SpotDetail extends StatefulWidget {
  static const route = "/spot";

  final Spot spot;

  const SpotDetail(this.spot, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SpotDetailState();
}

class _SpotDetailState extends State<SpotDetail> {
  bool? isFavorite;
  late Spot spot;

  @override
  void initState() {
    spot = widget.spot;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isFavorite);
        return true;
      },
      child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            SpotManager().getSpotDetail(spot.id),
            DatabaseManager().isFavorite(spot.id)
          ]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              spot = snapshot.data?[0];
              isFavorite = snapshot.data?[1];
            }
            return Scaffold(
                appBar: AppBar(
                  title: Text(spot.title ?? ''),
                ),
                floatingActionButton: isFavorite != null
                    ? FloatingActionButton(
                        onPressed: () async {
                          bool currentlyFavorite = isFavorite ?? false;
                          await SpotManager().toggleFavorite(spot);
                          setState(() {
                            isFavorite = !currentlyFavorite;
                          });
                        },
                        child: Icon(isFavorite ?? false
                            ? Icons.favorite
                            : Icons.favorite_border),
                      )
                    : null,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: PageView.builder(
                              itemBuilder: (context, position) {
                                return Image.network(
                                  snapshot.hasData
                                      ? (spot.imagesCollection?[position] ?? '')
                                      : spot.imageFullsize ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, child, stack) {
                                    return const ImagePlaceholder();
                                  },
                                );
                              },
                              itemCount: snapshot.hasData
                                  ? (spot.imagesCollection?.length ?? 0)
                                  : 1,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Visibility(
                                visible: spot.isRecommended == true,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Colors.green),
                                  child: const Text(
                                    "Recommandé",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Visibility(
                                visible: spot.isClosed == true,
                                child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        color: Colors.red),
                                    child: const Text("Fermé",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white))),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              spot.title ?? '',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              height: 40,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, position) {
                                  String tag =
                                      spot.tagsCategory?[position].name ?? '';
                                  return Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    child: Center(
                                        child: Text(
                                      tag,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                  );
                                },
                                separatorBuilder: (context, position) =>
                                    const SizedBox(
                                  width: 8,
                                ),
                                itemCount: spot.tagsCategory?.length ?? 0,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text("Adresse : ${spot.address}"),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                                "Gare la plus proche : ${spot.trainStation ?? "inconnue"}"),
                            const SizedBox(
                              height: 20,
                            ),
                            snapshot.hasData
                                ? _SpotDescription(spot.description ?? '')
                                : Container(),
                            snapshot.hasData
                                ? _SpotComments(
                                    spot,
                                  )
                                : Container()
                          ],
                        ),
                      )
                    ],
                  ),
                ));
          }),
    );
  }
}

class _SpotDescription extends StatelessWidget {
  final String description;

  const _SpotDescription(this.description);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Description",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(description)
      ],
    );
  }
}

class _SpotComments extends StatelessWidget {
  final Spot spot;
  final TextEditingController commentFieldController = TextEditingController();
  final GlobalKey<AnimatedListState> animatedListKey = GlobalKey();

  _SpotComments(this.spot);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Commentaires",
                style: TextStyle(fontSize: 18),
              ),
              TextButton(
                  onPressed: () {
                    _postCommentDialog(context);
                  },
                  child: const Text("Laisser un avis"))
            ],
          ),
          AnimatedList(
            key: animatedListKey,
            initialItemCount: spot.comments?.length ?? 0,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, position, animation) {
              return SizeTransition(
                  sizeFactor: animation,
                  child: _CommentItem(spot.comments?[position] ??
                      SpotComment(
                          comment: 'Erreur',
                          createdAt: DateTime.now().millisecondsSinceEpoch)));
            },
          )
        ],
      ),
    );
  }

  void _postCommentDialog(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            insetPadding: const EdgeInsets.symmetric(horizontal: 40),
            title: const Text("Saisissez votre commentaire",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            content: TextField(
              controller: commentFieldController,
              minLines: 3,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (commentFieldController.text.isNotEmpty) {
                    SpotComment? postedComment = await SpotManager()
                        .sendComment(spot.id, commentFieldController.text);
                    if (postedComment != null) {
                      spot.comments ??= [];
                      spot.comments?.insert(0, postedComment);
                      animatedListKey.currentState?.insertItem(0);
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text(
                  "ENVOYER",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          );
        });
  }
}

class _CommentItem extends StatelessWidget {
  final SpotComment comment;

  const _CommentItem(this.comment);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Text("« ${comment.comment} »"),
    );
  }
}

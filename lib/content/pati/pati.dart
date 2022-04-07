import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class ItemPublic extends StatefulWidget {
  final Map<String, dynamic> publicFData;
  ItemPublic({Key? key, required this.publicFData}) : super(key: key);
  @override
  State<ItemPublic> createState() => _ItemPublicState();
}

class _ItemPublicState extends State<ItemPublic> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                "${widget.publicFData["picture"]}",
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Text("${widget.publicFData["username"].toString()[0]}"),
              ),
              title: Text("${widget.publicFData["title"]}"),
              subtitle: Text("${widget.publicFData["publishedAt"].toDate()}"),
              trailing: Wrap(
                children: [
                  IconButton(
                    icon: Icon(Icons.star_outlined, color: Colors.green),
                    tooltip: "Likes: ${widget.publicFData["stars"]}",
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: "Compartir",
                    icon: Icon(Icons.share),
                    onPressed: () async{
                      final response = await http.get(Uri.parse(widget.publicFData["picture"]));
                      final documentDirectory = await getApplicationDocumentsDirectory();
                      final share_image = File(join(documentDirectory.path, 'shared_img.png'));
                      share_image.writeAsBytesSync(response.bodyBytes);
                      List<String> imagesPaths = [];
                      imagesPaths.add(share_image.path);

                      Share.shareFiles(
                        imagesPaths,
                        text: widget.publicFData["title"] + "\n" + widget.publicFData["publishedAt"].toString(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Fotazas extends StatelessWidget {
  const Fotazas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      query: FirebaseFirestore.instance.collection("photo_share").where("public", isEqualTo: true),
      itemBuilder: (BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> res) {
        return ItemPublic(publicFData: res.data());
      }
    );
  }
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final FirebaseFirestore getData = FirebaseFirestore.instance;
  final authInst = FirebaseAuth.instance;
  final FirebaseStorage imgStorage = FirebaseStorage.instance;
  List<Map<String, dynamic>> partiesList = [];

  @override
  void initState() {
    super.initState();
    getResultsData();
  }

  Future<void> getResultsData() async {
    try {
      if (authInst.currentUser != null) {
        final partiesSnapshot = await getData.collection("parties").get();
        for (var doc in partiesSnapshot.docs) {
          String imgURL = await getImageUrl(doc["imageURL"]);
          partiesList.add({
            'name': doc["Name"],
            'fullname': doc["FullName"],
            'votes': doc["Votes"],
            'imageURL': imgURL
          });
        }
        setState(() {});
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 5), () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
          return AlertDialog.adaptive(
            title: Text(
              "Could not retrieve data.",
              style: TextStyle(fontFamily: "Helvetica"),
            ),
            content: Text(
              "$e",
              style: TextStyle(fontFamily: "Helvetica"),
            ),
          );
        },
      );
    }
  }

  Future<String> getImageUrl(String imagePath) async {
    String downloadUrl = await imgStorage.ref(imagePath).getDownloadURL();
    return downloadUrl;
  }

  String findHighestVotes() {
    String hold = "";

    if (partiesList.isNotEmpty) {
      int count = partiesList[0]['votes'];
      int n = partiesList.length;
      int index = 0;
      for (int i = 1; i < n; i++) {
        if (partiesList[i]['votes'] > count) {
          count = partiesList[i]['votes'];
          index = i;
        }
      }
      if (partiesList[index]['votes'] == 0) {
        hold = "-";
      } else {
        hold = partiesList[index]['name'];
      }
    }
    return hold;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 15, 134, 231),
        toolbarHeight: 220,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                  size: 40,
                )),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                "Live vote count of elections",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Helvetica",
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text("The results will be finalised soon.",
                  style: TextStyle(
                      color: Colors.white70,
                      fontFamily: "Helvetica",
                      fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 60),
              child: Text("The current leader is ${findHighestVotes()}",
                  style: TextStyle(
                      color: Colors.white70,
                      fontFamily: "Helvetica",
                      fontSize: 20)),
            )
          ],
        ),
      ),
      body: partiesList.isEmpty
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.green, size: 70),
            )
          : ListView.builder(
              itemCount: partiesList.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 150,
                  child: Card(
                    color: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 30),
                          child: CachedNetworkImage(
                            imageUrl: partiesList[index]['imageURL'],
                            width: 70,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                partiesList[index]['name'],
                                style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                partiesList[index]['fullname'],
                                style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 33, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Votes",
                                  style: TextStyle(
                                      fontFamily: "Helvetica",
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 17),
                              Text(
                                "${partiesList[index]['votes']}",
                                style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}

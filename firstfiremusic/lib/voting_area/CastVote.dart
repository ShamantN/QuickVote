import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Castvote extends StatefulWidget {
  const Castvote({super.key});

  @override
  State<Castvote> createState() => _CastvoteState();
}

class _CastvoteState extends State<Castvote> {
  final autharise = FirebaseAuth.instance;
  final FirebaseFirestore addData = FirebaseFirestore.instance;
  final storageInstance = FirebaseFirestore.instance;
  final FirebaseStorage imageStorage = FirebaseStorage.instance;
  bool doneLoading = false;
  bool voted = false;
  int voteValue = 0;
  Map<String, bool> checkedValues = {};
  List<Map<String, dynamic>> partiesList = [];
  String updatePartyID = "";

  @override
  void initState() {
    super.initState();
    getFirebaseData();
    checkIfUserVoted();
  }

  void checkIfUserVoted() async {
    final curUser =
        addData.collection("votedUsers").doc(autharise.currentUser?.uid);
    final docSnapshot = await curUser.get();
    updatePartyID = docSnapshot["Voted Party"];
    final partyRef = addData.collection('parties').doc(updatePartyID);
    final partySnap = await partyRef.get();
    checkedValues[updatePartyID] = true;
    if (docSnapshot.exists) {
      voted = true;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog.adaptive(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.grey.shade400,
              title: Center(
                child: Text(
                  "NOTICE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: "Helvetica",
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              content: Text(
                "You have already finished voting for ${partySnap["Name"]}",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Helvetica", fontSize: 15),
              ),
            );
          });
    }
  }

  Future<void> getFirebaseData() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        throw Exception("User is not authenticated.");
      }

      final snapShots = await storageInstance.collection("parties").get();
      for (var doc in snapShots.docs) {
        String downloadURL = await getImageUrl(doc["imageURL"]);
        partiesList.add({
          'id': doc.id,
          'name': doc["Name"],
          'fullname': doc["FullName"],
          'imageURL': downloadURL
        });
      }
      setState(() {});
    } catch (error) {
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
              "$error",
              style: TextStyle(fontFamily: "Helvetica"),
            ),
          );
        },
      );
    }
  }

  Future<String> getImageUrl(String imagePath) async {
    String downloadUrl = await imageStorage.ref(imagePath).getDownloadURL();
    return downloadUrl;
  }

  void votedBox(int index, String partyName, String partyID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.grey.shade400,
            title: Text(
              "Are you sure you want to vote for $partyName?",
              style: TextStyle(fontFamily: "Helvetica", fontSize: 16),
            ),
            contentTextStyle: TextStyle(fontFamily: "Helvetica"),
            content: Row(
              children: [
                RawMaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: Colors.white,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    voted = true;
                    User? user = FirebaseAuth.instance.currentUser;
                    String curUserEmail = user?.email ?? "No user logged in";
                    addData
                        .collection("votedUsers")
                        .doc(autharise.currentUser?.uid)
                        .set({"E-mail": curUserEmail, "Voted Party": partyID});
                    increaseVoteCount();
                    Navigator.pop(context);
                  },
                  child: Text("Yes"),
                ),
                const SizedBox(
                  width: 105,
                ),
                RawMaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: Colors.white,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      checkedValues[partyID] = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("No"),
                ),
              ],
            ),
          );
        });
  }

  void increaseVoteCount() async {
    final curUser =
        addData.collection("votedUsers").doc(autharise.currentUser?.uid);
    final docSnapshot = await curUser.get();
    updatePartyID = docSnapshot["Voted Party"];
    final partyRef = addData.collection('parties').doc(updatePartyID);

    try {
      final partySnap = await partyRef.get();
      if (partySnap.exists) {
        int currentVotes = partySnap.data()?['Votes'] ?? 0;
        int newVotes = currentVotes + 1;
        await partyRef.update({'Votes': newVotes});
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new)),
          centerTitle: true,
          excludeHeaderSemantics: true,
          backgroundColor: const Color.fromARGB(255, 15, 134, 231),
          title: Text(
            "Ongoing Election",
            style: TextStyle(
                fontFamily: "Helvetica",
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.white,
        body: partiesList.isEmpty
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.grey, size: 70))
            : ListView.builder(
                itemCount: partiesList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade400),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: partiesList[index]['imageURL'],
                          width: 56,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        title: Text(
                          partiesList[index]['name'],
                          style: TextStyle(
                              fontFamily: "Helvetica",
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          partiesList[index]['fullname'],
                          style: TextStyle(
                              fontFamily: "Helvetica",
                              fontSize: 16,
                              fontStyle: FontStyle.italic),
                        ),
                        trailing: Checkbox(
                            checkColor: Colors.green,
                            activeColor: Colors.grey.shade700,
                            side: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            value: checkedValues[partiesList[index]['id']] ??
                                false,
                            onChanged: (bool? newValue) {
                              if (voted == false) {
                                if (partiesList[index]['id'] != null) {
                                  HapticFeedback.heavyImpact();
                                  if (voted == false) {
                                    votedBox(index, partiesList[index]['name'],
                                        partiesList[index]['id']);
                                  }
                                  setState(() {
                                    checkedValues[partiesList[index]['id']] =
                                        newValue ?? false;
                                  });
                                }
                              } else {
                                HapticFeedback.heavyImpact();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Center(
                                  child: Text(
                                      "Sorry, you have already finished voting!"),
                                )));
                              }
                            }),
                      ),
                    ),
                  );
                }));
  }
}

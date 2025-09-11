import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class refAndEarn extends StatefulWidget {
  var UserObj;

  refAndEarn({Key? key, this.UserObj}) : super(key: key);

  @override
  State<refAndEarn> createState() => _refAndEarnState();
}

class _refAndEarnState extends State<refAndEarn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Refer & Earn"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Wallet Bal. :${widget.UserObj["walletBal"]}/-",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: fireBCollection.collection("supuser").doc(widget.UserObj["CLIENTNO"]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return Center(child: Text("Error:-${snapshot}"));
            } else {
              dynamic d = snapshot.data!.data();
              String referenceCode = d["CLIENTNO"].toString().padLeft(5, '0');
              return Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .3,
                    child: Image.asset("assets/img/referandearn.jpeg"),
                  ),
                  Text(
                    "Share your refer code and get Rs 500 credit ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.black45, // Set the desired border color here
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$referenceCode",
                                style: TextStyle(fontSize: 40),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.extended(
                        onPressed: () {
                          var url = "https://uniqsoftwares.com/app/?refcode=$referenceCode";
                          Share.share(url);
                        },
                        label: Text("Share Now")),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 8),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         "Your Referal",
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //           color: jsmColor,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Divider(),
                  // Expanded(
                  //     child: StreamBuilder<QuerySnapshot>(
                  //         stream: fireBCollection.collection("references").where("CLNT", isEqualTo: widget.UserObj["CLIENTNO"]).snapshots(),
                  //         builder: (context, snapshot) {
                  //           if (snapshot.connectionState == ConnectionState.waiting) {
                  //             return Center(child: CircularProgressIndicator());
                  //           } else if (!snapshot.hasData) {
                  //             return Center(child: Text("Error:-${snapshot}"));
                  //           } else {
                  //             var snp = snapshot.data!.docs;
                  //             if (snp.length > 0) {
                  //               return ListView(
                  //                 children: [
                  //                   ...snp.map((e) {
                  //                     dynamic r = e.data();
                  //                     return ListTile(
                  //                       title: Text("${r["shop_Name"]}"),
                  //                       subtitle: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                  //                         children: [
                  //                           Text("Date:${(Myf.dateFormate(r["time"]))}"),
                  //                           Row(
                  //                             children: [
                  //                               Flexible(child: Text("Credit :")),
                  //                               Flexible(
                  //                                   child: Text(
                  //                                 "${r["status"]}",
                  //                                 style: TextStyle(fontWeight: FontWeight.bold),
                  //                               )),
                  //                             ],
                  //                           )
                  //                         ],
                  //                       ),
                  //                       trailing: Column(
                  //                         mainAxisAlignment: MainAxisAlignment.start,
                  //                         children: [
                  //                           Text("${r["refAmt"]}/-"),
                  //                         ],
                  //                       ),
                  //                     );
                  //                   }).toList()
                  //                 ],
                  //               );
                  //             } else {
                  //               return Text("No dues ");
                  //             }
                  //           }
                  //         }))
                ],
              );
            }
          }),
    );
  }
}

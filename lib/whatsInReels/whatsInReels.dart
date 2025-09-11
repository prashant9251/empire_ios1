import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/videoPlayer/videoPlayer.dart';
import 'package:flutter/material.dart';

class whatsInReels extends StatefulWidget {
  const whatsInReels({Key? key}) : super(key: key);

  @override
  State<whatsInReels> createState() => _whatsInReelsState();
}

class _whatsInReelsState extends State<whatsInReels> {
  PageController pcontroller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<Widget> reels = [
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.amber,
      )
    ];
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: fireBCollection
              .collection("softwares")
              .doc("$firebaseSoftwaresName")
              .collection("help")
              .where('linkType', isEqualTo: "video")
              .orderBy("sr", descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              //print(snapshot.error);
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (!snapshot.hasData) {
              return Text('No data available');
            } else {
              var snp = snapshot.data!.docs;
              return PageView(
                scrollDirection: Axis.vertical,
                children: [
                  ...snp.map((e) {
                    dynamic d = e.data();
                    return VideoPlayFromUrl(url: d["link"], d: d);
                  }).toList()
                ],
                controller: pcontroller,
              );
            }
          },
        ),
      ),
    );
  }
}

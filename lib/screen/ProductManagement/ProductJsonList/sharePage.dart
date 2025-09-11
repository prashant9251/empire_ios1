import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SharePage extends StatefulWidget {
  SharePage({Key? key, required this.I}) : super(key: key);
  List I;
  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> with TickerProviderStateMixin {
  double progressbar = 0;
  List newI = [];

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: jsmColor, title: const Text("Share")),
      // backgroundColor: jsmColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: shareCard(),
        ),
      ),
    );
  }

  Column shareCard() {
    return Column(
        children: newI.map((e) {
      List<String> imgpath = e['imgpath'].cast<String>();
      int lengh = imgpath.length;
      //print("=============$imgpath");
      return ListTile(
        leading: CircleAvatar(
            backgroundColor: jsmColor,
            child: Text(
              "Slab",
              style: TextStyle(color: Colors.white),
            )),
        title: Text(
          "${lengh.toString()} Images",
          style: TextStyle(color: jsmColor, fontWeight: FontWeight.bold),
        ),
        subtitle: LinearProgressIndicator(
          value: progressbar,
          semanticsLabel: 'Linear progress indicator',
        ),
        trailing: ElevatedButton(
            onPressed: () async {
              await shareSlabFile(imgpath);
            },
            child: Text("Share")),
      );
    }).toList());
  }

  getListI(int productLength, int limit) async {
    List I = [];
    List ImgLink = widget.I;
    var startIndex = 0;
    var limitIndex = limit;
    var devide = productLength / limit;
    var loop = (devide * 1).ceil() / 1;
    for (var k = 0; k < loop; k++) {
      if (k != 0) {
        startIndex += limit;
        limitIndex += limit;
      }
      Map<String, dynamic> obj = {};
      var subArr = [];
      for (var i = startIndex; i < limitIndex; i++) {
        try {
          var ele = await widget.I[i];
          subArr.add(ele);
        } catch (err) {}
      }
      obj['imgpath'] = subArr;
      I.add(obj);
    }
    //print(I);
    return I;
  }

  void getData() async {
    var productLength = widget.I.length;
    var limit = 30;
    newI = await getListI(productLength, limit);
    setState(() {});
  }

  shareSlabFile(imgpath) async {
    await Share.shareXFiles(([XFile(imgpath)]));
  }
}

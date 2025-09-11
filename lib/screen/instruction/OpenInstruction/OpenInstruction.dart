import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/fullScreenImg/fullScreenImg.dart';
import 'package:flutter/material.dart';

class OpenInstruction extends StatefulWidget {
  dynamic d;

  OpenInstruction({Key? key, required this.d}) : super(key: key);

  @override
  State<OpenInstruction> createState() => _OpenInstructionState();
}

class _OpenInstructionState extends State<OpenInstruction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(backgroundColor: jsmColor, title: Text("${widget.d["title"]}")),
      body: ListView(children: [
        // Container(
        //   color: Colors.amber,
        //   child: Column(
        //     children: [
        //       Text(
        //         "Note: kya apne ye MSG seen kiya",
        //         style: TextStyle(fontSize: 20),
        //       ),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         children: [
        //           ElevatedButton(
        //               style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        //               onPressed: () {},
        //               child: Text(
        //                 "Yes",
        //                 style: TextStyle(color: Colors.white),
        //               )),
        //           ElevatedButton(
        //               style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        //               onPressed: () {},
        //               child: Text(
        //                 "No",
        //                 style: TextStyle(color: Colors.white),
        //               )),
        //         ],
        //       )
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              children: [
                Text(
                  "${widget.d["title"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                widget.d["link"] != null && widget.d["link"] != ""
                    ? InkWell(
                        onTap: () => Myf.Navi(context, fullScreenImg(img_list: [widget.d["link"]])),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width,
                          key: UniqueKey(),
                          imageUrl: widget.d["link"],
                          fit: BoxFit.cover,
                          httpHeaders: {
                            "Authorization": basicAuthForLocal,
                          },
                          maxHeightDiskCache: 400,
                          placeholder: (context, url) => Container(color: Colors.grey),
                          errorWidget: (context, url, error) {
                            return Container(child: Icon(Icons.error, color: Colors.red));
                          },
                        ),
                      )
                    : SizedBox.shrink(),
                Text(
                  "${widget.d["msg"]}",
                  style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          child: Text(
            "Instruction",
            style: TextStyle(color: Colors.blueGrey, fontSize: 30),
          ),
        ),
        widget.d["step"] != null
            ? StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  List<dynamic> step = widget.d["step"];
                  var sr = 0;
                  return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: step.map((e) {
                        sr++;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            color: Colors.grey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$sr",
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                                e["steplink"] != null && e["steplink"] != ""
                                    ? InkWell(
                                        onTap: () {
                                          Myf.Navi(context, fullScreenImg(img_list: [e["steplink"]]));
                                        },
                                        child: CachedNetworkImage(
                                          width: MediaQuery.of(context).size.width,
                                          key: UniqueKey(),
                                          imageUrl: e["steplink"],
                                          fit: BoxFit.cover,
                                          httpHeaders: {
                                            "Authorization": basicAuthForLocal,
                                          },
                                          maxHeightDiskCache: 400,
                                          placeholder: (context, url) => Container(color: Colors.grey),
                                          errorWidget: (context, url, error) {
                                            return Container(child: Icon(Icons.error, color: Colors.red));
                                          },
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                Text("${e["text"]}"),
                                Divider()
                              ],
                            ),
                          ),
                        );
                      }).toList());
                })
            : SizedBox.shrink()
      ]),
    );
  }
}

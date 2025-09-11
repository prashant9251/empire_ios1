import 'dart:convert';
import 'dart:typed_data';

import 'package:empire_ios/Apis/Enotify.dart';
import 'package:empire_ios/Models/QrCodeLinkRespModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';

class EnotifyHome extends StatefulWidget {
  const EnotifyHome({Key? key}) : super(key: key);

  @override
  State<EnotifyHome> createState() => _EnotifyHomeState();
}

class _EnotifyHomeState extends State<EnotifyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uniq-notify"),
      ),
      body: ListView(
        children: [
          Card(
            child: FutureBuilder(
              future: EnotifyApis.getQrCodeApi(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SizedBox.shrink();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                dynamic snp = snapshot.data ?? {};
                return Builder(builder: (context) {
                  if (snp["status"] == "qrcode") {
                    Uint8List decodedBytes = base64Decode(snp["data"]);
                    return ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("QR Code"),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      subtitle: Image.memory(
                        decodedBytes,
                        height: 200,
                        width: 200,
                      ),
                    );
                  } else if (snp["status"] == "success") {
                    QrCodeLinkRespModel qrCodeLinkRespModel = QrCodeLinkRespModel.fromJson(Myf.convertMapKeysToString(snp["data"] ?? {}));

                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Instance status "),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () async {
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.logout),
                            onPressed: () async {
                              Myf.snakeBar(context, "Please logout from your Device");
                              // changeStream.add(true);
                            },
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Connected successfully",
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Chip(
                                      label: Text("${qrCodeLinkRespModel.quota}"),
                                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text("Remaining "),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Chip(label: Text("${qrCodeLinkRespModel.instanceUsage}"), labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Credits usage"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Chip(
                                        label:
                                            Text("${Myf.dateFormateYYYYMMDD(qrCodeLinkRespModel.quotaValidity.toString(), formate: "dd-MMMM-yyyy")}"),
                                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Expiry date"),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

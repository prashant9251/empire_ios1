import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:share_plus/share_plus.dart';

class DatabaseBackUpList extends StatefulWidget {
  DatabaseBackUpList({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;
  @override
  State<DatabaseBackUpList> createState() => _DatabaseBackUpListState();
}

class _DatabaseBackUpListState extends State<DatabaseBackUpList> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (contex, constraints) {
      return Scaffold(
        appBar: AppBar(backgroundColor: jsmColor, title: Text("Your Software Backup Folder List")),
        body: Container(
          width: friendlyScreenWidth(context, constraints),
          child: ListView(
            children: [
              Center(child: Text("CLIENT NO : ${widget.UserObj["CLIENTNO"]}")),
              Center(child: Text("BACKUP FOLDER")),
              StreamBuilder<QuerySnapshot>(
                stream: fireBCollection
                    .collection("supuser")
                    .doc(widget.UserObj["CLIENTNO"])
                    .collection("EMP_DATABASE")
                    .orderBy("CREATETIME", descending: true)
                    .limit(50)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("BK ERROR"));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text("BK LOGIN ISSUE"));
                  } else if (snapshot.hasError) {
                    return Center(child: Text("BK LOGIN ERROR"));
                  } else if (snapshot.hasData) {
                    var snp = snapshot.data!.docs;
                    if (snp.length > 0) {
                      return Column(
                        children: snp.map((e) {
                          var id = e.reference.id;
                          dynamic d = e.data();
                          return Card(
                            child: ListTile(
                              title: Text("${id}"),
                              trailing: IconButton(
                                  onPressed: () async {
                                    Myf.showBlurLoading(context);
                                    var f = await Myf.downloadFileFromFirestore("${d["URL"]}", "${d["NAME"]}");
                                    if (f != null) {
                                      Share.shareXFiles([XFile(f.path)]);
                                    }
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.download)),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(
                              "You have no database backup plan",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 30),
                            )),
                            Text("1.Plan price 3000/- per year", style: TextStyle(color: Colors.blue)),
                            Text("2.End to end encrypted with your password protection"),
                            Text("3.We will use your google firebase account for your database backup system  aprox (5gb) storage free"),
                            Text(
                                "4.When you take backup from Accounting softwares Our computer utility encrypt that file with your password and take backup to cloud "),
                            Text("4.All backup come from your computer show below in list"),
                            Row(
                              children: [
                                Icon(Icons.arrow_downward),
                                Flexible(
                                    child: Text("dont call in our office. if you have any installation  query just click. We will contact you soon")),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  final MailOptions mailOptions = MailOptions(
                                    body:
                                        'Please contact us for installation setup on this \n No :-${widget.UserObj["mobileno_user"]}. \n Email :-${widget.UserObj["emailadd"]}',
                                    subject: 'AUTO DATBASE BACKUP SYSTEM QUERY',
                                    recipients: ['$contactEmail'],
                                    // isHTML: true,
                                    // bccRecipients: ['other@example.com'],
                                    // ccRecipients: ['third@example.com'],
                                    // attachments: [
                                    //   '$filePath',
                                    // ],
                                  );
                                  final MailerResponse response = await FlutterMailer.send(mailOptions);
                                  switch (response) {
                                    case MailerResponse.saved:

                                      /// ios only
                                      break;
                                    case MailerResponse.sent:

                                      /// ios only
                                      break;
                                    case MailerResponse.cancelled:

                                      /// ios only
                                      break;
                                    case MailerResponse.android:
                                      break;
                                    default:
                                      break;
                                  }
                                },
                                child: Text("Request for installation"))
                          ],
                        ),
                      );
                    }
                  } else {
                    return Center(child: Text("please wait Login process"));
                  }
                },
              )
            ],
          ),
        ),
      );
    });
  }
}

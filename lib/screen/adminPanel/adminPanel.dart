import 'dart:convert';

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/adminPanel/addnewUser.dart';
import 'package:empire_ios/screen/adminPanel/userPermissionSettingsAdminEmpTrading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../EMPIRE/webview.dart';

class AdminPanel extends StatefulWidget {
  AdminPanel({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;
  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  var loading = true;

  var userList = [];
  var userCount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    userCount = 0;
    return Scaffold(
      appBar: AppBar(backgroundColor: jsmColor, title: Text("ADMIN PANEL")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: jsmColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.account_circle, size: 48, color: jsmColor),
                      SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("GSTIN :", "${widget.UserObj["GSTIN"]}"),
                            SizedBox(height: 8),
                            _buildInfoRow("USER EMAIL :", "${widget.UserObj["emailadd"]}"),
                            SizedBox(height: 8),
                            _buildInfoRow("USER MOBILE :", "${widget.UserObj["mobileno_user"]}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(thickness: 1, color: jsmColor.withOpacity(0.3)),
                Column(
                  children: userList.map((U) {
                    userCount++;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            U["software_name"] = widget.UserObj["software_name"];
                            Myf.Navi(
                                context,
                                UserPermissionAdmin(
                                  UserObj: U,
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blue.shade100,
                                  child: FittedBox(
                                    child: Text(
                                      "$userCount",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${U["usernm"]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.phone, size: 15, color: Colors.grey),
                                          SizedBox(width: 4),
                                          Text("${U["mobileno_user"]}"),
                                        ],
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(Icons.email, size: 15, color: Colors.grey),
                                          SizedBox(width: 4),
                                          Text("${U["emailadd"]}"),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green.shade600,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              icon: Icon(Icons.lock_open),
                                              label: Text("Permission"),
                                              onPressed: () {
                                                U["software_name"] = widget.UserObj["software_name"];
                                                Myf.Navi(
                                                    context,
                                                    UserPermissionAdmin(
                                                      UserObj: U,
                                                    ));
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Flexible(
                                            child: OutlinedButton.icon(
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.blue,
                                                side: BorderSide(color: Colors.blue),
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              icon: Icon(Icons.share),
                                              label: Text("Share App Link"),
                                              onPressed: () {
                                                var shareText = firebSoftwraesInfo["applicationLinkMsg"];
                                                shareText = shareText.toString().replaceAll("\$company", "${widget.UserObj["SHOPNAME"]}");
                                                shareText = shareText.toString().replaceAll("\$gstin", "*${widget.UserObj["GSTIN"]}*");
                                                shareText = shareText.toString().replaceAll("\$mobile", "*${widget.UserObj["mobileno_user"]}*");
                                                String url = "whatsapp://send?phone=91${U["mobileno_user"]}&text=$shareText";
                                                launchUrl(Uri.parse(url));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 100)
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        icon: Icon(Icons.person_add, size: 28),
        label: Text(
          "Add New User",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return WebView(
                  mainUrl: urldata().newUserCreateUrlSettings,
                  CURRENT_USER: widget.UserObj,
                );
              },
            ),
          );
        },
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[700],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  getData() async {
    var deviceId = await Myf.getId();
    var userGstin = widget.UserObj["GSTIN"];
    var email = widget.UserObj["emailadd"];
    var mobileNo = widget.UserObj["mobileno_user"];
    var OTP = widget.UserObj["CUOTP"];
    var loginUrl = "${urldata.adminUserListUrl}?userGstin=$userGstin&email=$email&mobileNo=$mobileNo&OTP=$OTP&DID=$deviceId";
    //print('----$loginUrl');
    var res = '[]';
    try {
      var url = Uri.parse(loginUrl);
      var response = await http.get(url);
      res = (response.body);
      if (res != null) {
        try {
          userList = await jsonDecode(res);
          userList.sort((a, b) {
            return a["usernm"].toString().compareTo(b["usernm"]);
          });
        } catch (e) {}
        //print('----$userList');
      } else {
        //print("User Not Valid");
      }
    } catch (e) {}
    setState(() {
      loading = false;
    });
  }
}

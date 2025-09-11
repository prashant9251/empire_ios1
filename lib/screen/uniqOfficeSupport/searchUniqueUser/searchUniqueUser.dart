import 'dart:convert';

import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

class searchUniqueUser extends StatefulWidget {
  const searchUniqueUser({Key? key}) : super(key: key);

  @override
  State<searchUniqueUser> createState() => _searchUniqueUserState();
}

class _searchUniqueUserState extends State<searchUniqueUser> {
  var obj = {};
// {
//   'tableName':tableName,
//        'dateOrder':dateOrder,
// 		'recordLimit':recordLimit,
// 		'duetype':duetype,
// 		'usernm':usernm,
// 		'mobileNo':mobileNo,
// 		'email':email,
// 		'softwareName':softwareName,
// 		'block':block,
// 		'clnt':clnt
// 		}
  void getData() async {
    var loginUrl = "https://aashaimpex.com/offsupport/searchUserFetch.php";
    var res = '[]';
    //print(loginUrl);
    var url = Uri.parse(loginUrl);
    var response = await http.post(url, body: obj);
    res = (response.body);
    //print('----$res');
    if (res != null) {
      var resJson = jsonDecode(res);
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search User Admin panel"),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}

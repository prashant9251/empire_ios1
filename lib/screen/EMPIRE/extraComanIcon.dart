import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/screen/EMPIRE/webview.dart';
import 'package:empire_ios/screen/fireClass.dart';
import 'package:empire_ios/screen/instruction/rateApplication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../main.dart';
import '../adminPanel/adminPanel.dart';
import '../databaseBackUpList/databaseBackUpList.dart';
import 'Myf.dart';

class ExtraComanIcon extends StatelessWidget {
  ExtraComanIcon({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;
  @override
  Widget build(BuildContext context) {
    admin = UserObj["admin"].toString().contains("true");
    return ComanIcon(context);
  }

  Widget ComanIcon(context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Center(
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    final InAppReview inAppReview = InAppReview.instance;
                    var availableRating = await inAppReview.isAvailable();

                    await inAppReview.requestReview();
                    inAppReview.openStoreListing(appStoreId: IosId);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image(
                            image: AssetImage("assets/img/feedback.png"),
                            height: 60,
                            width: 60,
                            color: null,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center),
                        Text(
                          "YOUR FEEDBACK",
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                InDev(
                  inDevUser: UserObj["login_user"],
                  widget: InkWell(
                    onTap: () {
                      Myf.Navi(
                          context,
                          DatabaseBackUpList(
                            UserObj: UserObj,
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage("assets/img/backuplist.png"),
                            height: 60,
                            width: 60,
                            color: null,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                          ),
                          Text(
                            "DATABASE \n BACKUP LIST",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                admin
                    ? InkWell(
                        onTap: () {
                          Myf.Navi(
                              context,
                              AdminPanel(
                                UserObj: UserObj,
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.admin_panel_settings_sharp,
                                color: Colors.red,
                                size: 60,
                              ),
                              // Image(
                              //   image: AssetImage("assets/img/admin.png"),
                              //   height: 60,
                              //   width: 60,
                              //   color: null,
                              //   fit: BoxFit.scaleDown,
                              //   alignment: Alignment.center,
                              // ),
                              Text(
                                "ADD NEW USER(ADMIN)",
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
          // Myf.checkForAppUpdate(context),

          Container(
            padding: EdgeInsets.all(15),
            width: friendlyScreenWidth(context, constraints),
            child: Card(
              color: Color.fromARGB(255, 236, 232, 232),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Logged in User"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Client : "),
                        Text("${UserObj["CLIENTNO"]}"),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Gstin : "),
                        Text("${UserObj["GSTIN"]}"),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("User Name : "),
                        Text("${Myf.getUserNameString(UserObj["login_user"])}"),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Email : "),
                        Text("${UserObj["emailadd"]}"),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Mobile : "),
                        Text("${UserObj["mobileno_user"]}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            width: friendlyScreenWidth(context, constraints),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Auto sync Off/On"),
                    Switch(
                      value: firebaseCurrntUserObj["autoSync"] == null || "${firebaseCurrntUserObj["autoSync"]}".contains("true") ? true : false,
                      onChanged: (value) async {
                        Map<String, dynamic> obj = {};
                        obj["autoSync"] = value;
                        await FireClass.updateUserDetails(context, UserObj: UserObj, updatingObj: obj);
                        SyncStatus.sink.add("");
                      },
                    ),
                  ],
                ),
                Container(
                  width: friendlyScreenWidth(context, constraints),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(child: Text("${firebSoftwraesInfo["contactNoshowMsgWith"]}:")),
                      GestureDetector(
                        onTap: () => Myf.dialNo([firebSoftwraesInfo["contactNo"]], context),
                        child: Text(
                          " ${firebSoftwraesInfo["contactNo"]}",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      )
                    ],
                  ),
                ),
                Container(width: friendlyScreenWidth(context, constraints), child: Text("${firebSoftwraesInfo["msg"]}")),
                kIsWeb ? SizedBox.shrink() : Container(width: friendlyScreenWidth(context, constraints), child: RatingApplication()),
                SizedBox(height: 30),
              ],
            ),
          )
        ],
      );
    });
  }
}

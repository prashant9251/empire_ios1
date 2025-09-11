import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/FireUserModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FireUserModel fireUserModel = FireUserModel.fromJson(Myf.convertMapKeysToString(firebaseCurrntUserObj));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [jsmColor.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.settings, color: jsmColor),
                      title: Text(
                        "App Preferences",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Divider(),
                    SwitchListTile(
                      activeColor: jsmColor,
                      title: Text("Quality Report Old Style"),
                      secondary: Icon(Icons.assignment, color: jsmColor),
                      value: fireUserModel.qualReportOldStyle ?? false,
                      onChanged: (value) {
                        setState(() {
                          fireUserModel.qualReportOldStyle = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      activeColor: jsmColor,
                      title: Text("Master Report Old Style"),
                      secondary: Icon(Icons.assignment_turned_in, color: jsmColor),
                      value: fireUserModel.masterReportOldStyle ?? false,
                      onChanged: (value) {
                        setState(() {
                          fireUserModel.masterReportOldStyle = value;
                        });
                      },
                    ),
                    if (Myf.isAndroid())
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text("Report Screen Zoom (200 is default)"),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Zoom",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: Icon(Icons.zoom_in, color: jsmColor),
                                ),
                                initialValue: (fireUserModel.screenZoom ?? loginUserModel.wEB)?.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    fireUserModel.screenZoom = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text("Default Company CNO"),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "MCNO",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: Icon(Icons.business, color: jsmColor),
                              ),
                              initialValue: fireUserModel.MCNO,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  fireUserModel.MCNO = (value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text("Default Type Code"),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "MTYPE",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: Icon(Icons.code, color: jsmColor),
                              ),
                              initialValue: fireUserModel.MTYPE,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  fireUserModel.MTYPE = (value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    GFButton(
                      onPressed: () {
                        fireBCollection
                            .collection("supuser")
                            .doc(loginUserModel.cLIENTNO)
                            .collection("user")
                            .doc(loginUserModel.loginUser)
                            .set(fireUserModel.toJson(), SetOptions(merge: true))
                            .then((value) {
                          Myf.snakeBar(context, "Settings saved successfully");
                          Navigator.pop(context);
                        }).catchError((error) {
                          Myf.snakeBar(context, "Error saving settings: $error");
                        });
                      },
                      text: "Save",
                      color: jsmColor,
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      type: GFButtonType.solid,
                      fullWidthButton: true,
                      size: GFSize.LARGE,
                      shape: GFButtonShape.pills,
                      icon: Icon(Icons.save, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

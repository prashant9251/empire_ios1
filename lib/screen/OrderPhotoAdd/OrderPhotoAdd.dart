import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';

class OrderPhotoAdd extends StatefulWidget {
  MasterModel masterModel;
  OrderPhotoAdd({Key? key, required this.masterModel}) : super(key: key);

  @override
  State<OrderPhotoAdd> createState() => _OrderPhotoAddState();
}

class _OrderPhotoAddState extends State<OrderPhotoAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: FittedBox(child: Text("${widget.masterModel.partyname} - ${widget.masterModel.city}")),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: fireBCollection
                      .collection("supuser")
                      .doc(GLB_CURRENT_USER["CLIENTNO"])
                      .collection("CUSTOMER")
                      .doc(widget.masterModel.value)
                      .collection("ORDERPHOTO")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No Data Found"));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(data["name"]),
                          subtitle: Text(data["date"]),
                        );
                      },
                    );
                  })),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(icon: Icon(Icons.add_a_photo), onPressed: () {}, label: Text("Add Photo")),
    );
  }
}

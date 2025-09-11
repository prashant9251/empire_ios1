import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/OrderPhotoAdd/OrderPhotoAdd.dart';
import 'package:empire_ios/screen/OrderPhotoCustomerAdd/OrderPhotoCustomerAdd.dart';
import 'package:flutter/material.dart';

class OrderPhotoCustomers extends StatefulWidget {
  const OrderPhotoCustomers({Key? key}) : super(key: key);

  @override
  State<OrderPhotoCustomers> createState() => _OrderPhotoCustomersState();
}

class _OrderPhotoCustomersState extends State<OrderPhotoCustomers> {
  var ctrlSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Order Photo"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: ctrlSearch,
                decoration: const InputDecoration(
                  hintText: 'Search Customer ...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 16.0),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("CUSTOMER").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No Customers Found"));
                  }
                  var customerList = snapshot.data!.docs;
                  var sr = 0;
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(color: Colors.black),
                    itemCount: customerList.length,
                    itemBuilder: (context, index) {
                      MasterModel masterModel = MasterModel.fromJson(Myf.convertMapKeysToString(customerList[index].data() as Map<String, dynamic>));
                      return ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text("${++sr}"),
                        ),
                        title: Text("${masterModel.partyname} (${masterModel.city})"),
                        onTap: () {
                          Myf.Navi(context, OrderPhotoAdd(masterModel: masterModel));
                        },
                      );
                    },
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "addPhoto",
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text("Add Customer"),
        backgroundColor: jsmColor,
        foregroundColor: Colors.white,
        onPressed: () {
          // Handle add photo action
          MasterModel masterModel = MasterModel(value: uuid.v1());
          Myf.Navi(context, OrderPhotoCustomerAdd(masterModel: masterModel));
        },
        icon: Icon(Icons.add),
      ),
    );
  }
}

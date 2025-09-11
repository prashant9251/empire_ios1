import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/widget/BuildTextFormField.dart';
import 'package:flutter/material.dart';

class OrderPhotoCustomerAdd extends StatefulWidget {
  MasterModel masterModel;
  OrderPhotoCustomerAdd({Key? key, required this.masterModel}) : super(key: key);

  @override
  State<OrderPhotoCustomerAdd> createState() => _OrderPhotoCustomerAddState();
}

class _OrderPhotoCustomerAddState extends State<OrderPhotoCustomerAdd> {
  var formKey = GlobalKey<FormState>();
  MasterModel masterModel = MasterModel();
  initState() {
    super.initState();
    masterModel = widget.masterModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Customer Add"),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: buildTextFormField(
                context,
                controller: TextEditingController(text: masterModel.partyname),
                labelText: "Customer Name",
                hintText: "Enter Customer Name",
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return "Please Enter Customer Name";
                  }
                  return null;
                },
                onChanged: (value) {
                  masterModel.partyname = value.toUpperCase().trim();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: buildTextFormField(
                context,
                controller: TextEditingController(text: masterModel.city),
                labelText: "City",
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return "Please Enter City";
                  }
                  return null;
                },
                hintText: "Enter City",
                onChanged: (value) {
                  masterModel.city = value.toUpperCase().trim();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: buildTextFormField(
                context,
                controller: TextEditingController(text: masterModel.mO),
                labelText: "Mobile Number",
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return "Please Enter Mobile Number";
                  }
                  return null;
                },
                hintText: "Enter Mobile Number",
                onChanged: (value) {
                  masterModel.mO = value.trim();
                },
              ),
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: jsmColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Save the customer data
                    // Navigator.pop(context);
                    saveToFirestore();
                  }
                },
                icon: Icon(Icons.save, color: Colors.white),
                label: Text("Save")),
          ],
        ),
      ),
    );
  }

  void saveToFirestore() async {
    fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("CUSTOMER")
        .doc(masterModel.value)
        .set(masterModel.toJson())
        .then((value) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Customer Added Successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }).catchError((error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error adding customer: $error"),
          backgroundColor: Colors.red,
        ),
      );
    });
    // Add your Firestore saving logic here
    // You can use the masterModel object to access the form data
    // For example: masterModel.partyname, masterModel.city, etc.
  }
}

import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/EmpOrderFormParty.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/cubit/EmpOrderFormPartyCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/toast/gf_toast.dart';

class EmpOrderAddMaster extends StatefulWidget {
  const EmpOrderAddMaster({Key? key, required this.masterModel}) : super(key: key);
  final MasterModel masterModel;

  @override
  State<EmpOrderAddMaster> createState() => _EmpOrderAddMasterState();
}

class _EmpOrderAddMasterState extends State<EmpOrderAddMaster> {
  late MasterModel masterModel;

  var _formKey = GlobalKey<FormState>();

  initState() {
    super.initState();
    masterModel = widget.masterModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Add Master"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: masterModel.aTYPE ?? '1',
                      items: [
                        DropdownMenuItem(
                          value: '1',
                          child: Text('SUNDRY DEBITORS'),
                        ),
                        DropdownMenuItem(
                          value: '12',
                          child: Text('BROKER'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          masterModel.aTYPE = value!;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.category),
                        labelText: 'A/C TYPE',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a type';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: masterModel.partyname,
                      onChanged: (value) {
                        masterModel.partyname = value.toUpperCase().trim();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: masterModel.aD1,
                      onChanged: (value) {
                        masterModel.aD1 = value.toUpperCase().trim();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: masterModel.city,
                            onChanged: (value) {
                              masterModel.city = value.toUpperCase().trim();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your city';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_city),
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: masterModel.pNO,
                            onChanged: (value) {
                              masterModel.pNO = value.toUpperCase().trim();
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.pin_drop),
                              labelText: 'Pincode',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: masterModel.gST,
                      onChanged: (value) {
                        masterModel.gST = value.toUpperCase().trim();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your GSTIN';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.business),
                        labelText: 'GSTIN',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      onChanged: (value) {
                        masterModel.mO = value.toUpperCase().trim();
                      },
                      initialValue: masterModel.mO,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'Mobile No',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        var pushScreen = BlocProvider(create: (context) => EmpOrderFormPartyCubit(context), child: EmpOrderFormParty(atype: "12"));
                        var model = await Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return pushScreen;
                          },
                        ));
                        if (model == null) return;
                        if (model is MasterModel) {
                          masterModel.broker = model.value;
                          setState(() {});
                        }
                      },
                      controller: TextEditingController(text: masterModel.broker),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Broker',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: masterModel.dhara,
                      onChanged: (value) {
                        masterModel.dhara = value.toUpperCase().trim();
                      },
                      controller: TextEditingController(text: masterModel.dhara),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Dhara',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: jsmColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          // TODO: Implement save logic
                          if (_formKey.currentState!.validate()) {
                            save();
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void save() {
    // Implement your save logic here
    masterModel.value = masterModel.gST;
    var json = masterModel.toJson();
    json["eTyp"] = "LIVE";
    fireBCollection.collection("supuser").doc(loginUserModel.cLIENTNO).collection("EMP_MST").doc(masterModel.value).set(json).then(
      (value) {
        GFToast.showToast("Master saved successfully", context, toastDuration: 1);
        Navigator.pop(context, masterModel);
      },
    ).onError((error, stackTrace) {
      GFToast.showToast("Error saving data: $error", context);
    });
  }
}

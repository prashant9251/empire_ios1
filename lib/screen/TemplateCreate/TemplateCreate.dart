import 'dart:async';
import 'dart:typed_data';

import 'package:bubble/bubble.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:empire_ios/Apis/TemplateManagerApis.dart';
import 'package:empire_ios/Models/TemplateModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/widget/TemplateWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TemplateCreate extends StatefulWidget {
  TemplateModel? templateModel;
  TemplateCreate({key, this.templateModel});

  @override
  State<TemplateCreate> createState() => _TemplateCreateState();
}

class _TemplateCreateState extends State<TemplateCreate> {
  var _formKey = GlobalKey<FormState>();
  final StreamController<bool> changeStream = StreamController<bool>.broadcast();
  TemplateModel templateModel = TemplateModel(header: Header(headerType: "TEXT"), buttons: [], body: "", name: "", status: "");

  PlatformFile? platformFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.templateModel != null) {
      templateModel = widget.templateModel!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final layoutInfo = Myf.getWidthInfo(constraints);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: Text("New Template"),
          actions: [
            ElevatedButton.icon(onPressed: validate, label: Text("Save"), icon: Icon(Icons.save)),
          ],
        ),
        body: Wrap(
          children: [
            Form(
              key: _formKey,
              child: Container(
                width: layoutInfo.width,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            initialValue: templateModel.name,
                            onChanged: (value) {
                              templateModel.name = value;
                              changeStream.sink.add(true);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: "Template Name", border: OutlineInputBorder()),
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Card(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Header Type',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: ["Select Header Type", "TEXT", "MEDIA"]
                                    .map((String item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: templateModel.header!.headerType.toString().toUpperCase(),
                                onChanged: (String? value) {
                                  setState(() {
                                    templateModel.header!.headerType = value;
                                    changeStream.sink.add(true);
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: 40,
                                  width: 140,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    StreamBuilder<bool>(
                        stream: changeStream.stream,
                        builder: (context, snapshot) {
                          switch (templateModel.header!.headerType) {
                            case "TEXT":
                              return TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                maxLines: 2,
                                initialValue: templateModel.header!.title,
                                onChanged: (value) {
                                  templateModel.header!.title = value;
                                  changeStream.sink.add(true);
                                },
                                decoration: InputDecoration(labelText: "Header Content", border: OutlineInputBorder()),
                              );
                            case null:
                              return SizedBox.shrink();
                            default:
                              return Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    maxLines: 2,
                                    initialValue: templateModel.header!.url,
                                    onChanged: (value) {
                                      templateModel.header!.url = value;
                                      changeStream.sink.add(true);
                                    },
                                    decoration: InputDecoration(labelText: "MEDIA URL", border: OutlineInputBorder()),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      platformFile = await Myf.pickImageInBytes(fileType: FileType.any, allowMultiple: false);
                                      if (platformFile != null) {
                                        changeStream.sink.add(true);
                                      }
                                    },
                                    child: Text('Pick ${templateModel.header!.headerType ?? ""}'),
                                  ),
                                ],
                              );
                          }
                        }),
                    SizedBox(height: 8),
                    TextFormField(
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please enter some text';
                      //   }
                      //   return null;
                      // },
                      maxLines: 4,
                      initialValue: templateModel.body,
                      onChanged: (value) {
                        templateModel.body = value;
                        changeStream.sink.add(true);
                      },
                      decoration: InputDecoration(labelText: "Body Text", border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        templateModel.buttons!.add(Button(type: "quickReply", title: "Quick Reply"));
                        changeStream.sink.add(true);
                      },
                      label: Text("Add Buttons"),
                      icon: Icon(Icons.add),
                    ),
                    StreamBuilder<bool>(
                        stream: changeStream.stream,
                        builder: (context, snapshot) {
                          return Column(
                            children: [
                              if (templateModel.buttons != null)
                                ...templateModel.buttons!.map(
                                  (e) {
                                    return Row(
                                      children: [
                                        Flexible(
                                          child: Card(
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<String>(
                                                // isExpanded: true,
                                                hint: Text(
                                                  'Select Item',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context).hintColor,
                                                  ),
                                                ),
                                                items: ["quickReply", "call", "url"]
                                                    .map((String item) => DropdownMenuItem<String>(
                                                          value: item,
                                                          child: Text(
                                                            item,
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                                value: e.type,
                                                onChanged: (String? value) {
                                                  e.type = value;
                                                  if (e.type == "quickReply") {
                                                    // e.phoneNumber = null;
                                                    // e.url = null;
                                                    // e.text = "Quick Reply";
                                                  } else if (e.type == "call") {
                                                    // e.phoneNumber = "xxx";
                                                    // e.text = "xxx";
                                                    // e.url = null;
                                                  } else if (e.type == "url") {
                                                    // e.url = "website.com";
                                                    // e.text = "website.com";
                                                    // e.phoneNumber = null;
                                                  }
                                                  changeStream.sink.add(true);
                                                },
                                                buttonStyleData: const ButtonStyleData(
                                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                                  height: 40,
                                                  width: 140,
                                                ),
                                                menuItemStyleData: const MenuItemStyleData(
                                                  height: 40,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            margin: EdgeInsets.all(8),
                                            child: TextFormField(
                                              initialValue: e.title,
                                              onChanged: (value) {
                                                e.title = value;
                                                e.payload = value;
                                                e.id = value;

                                                changeStream.sink.add(true);
                                              },
                                              decoration: InputDecoration(labelText: "Button Text", border: OutlineInputBorder()),
                                            ),
                                          ),
                                        ),
                                        if (e.type == "call")
                                          Flexible(
                                            child: Container(
                                              margin: EdgeInsets.all(8),
                                              child: TextFormField(
                                                initialValue: e.payload,
                                                onChanged: (value) {
                                                  e.payload = value;
                                                  changeStream.sink.add(true);
                                                },
                                                decoration: InputDecoration(labelText: "Phone Number", border: OutlineInputBorder()),
                                              ),
                                            ),
                                          ),
                                        if (e.type == "url")
                                          Flexible(
                                            child: Container(
                                              margin: EdgeInsets.all(8),
                                              child: TextFormField(
                                                initialValue: e.payload,
                                                onChanged: (value) {
                                                  e.payload = value;
                                                  changeStream.sink.add(true);
                                                },
                                                decoration: InputDecoration(labelText: "url", border: OutlineInputBorder()),
                                              ),
                                            ),
                                          ),
                                        Flexible(
                                            child: IconButton(
                                                onPressed: () {
                                                  templateModel.buttons!.remove(e);
                                                  changeStream.sink.add(true);
                                                },
                                                icon: Icon(Icons.delete))),
                                      ],
                                    );
                                  },
                                ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ),
            StreamBuilder<bool>(
                stream: changeStream.stream,
                builder: (context, snapshot) {
                  return Container(
                    height: constraints.maxHeight,
                    width: layoutInfo.width,
                    padding: EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/img/chatBackground.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TemplateWidget(templateModel: templateModel, layoutInfo: layoutInfo),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      );
    });
  }

  void validate() async {
    if (_formKey.currentState!.validate()) {
      templateModel.header!.headerType = templateModel.header!.headerType!.toLowerCase();
      TemplateManagerApis.createTemplate(context, templateModel).then(
        (value) {
          Navigator.pop(context);
        },
      );
    }
  }
}

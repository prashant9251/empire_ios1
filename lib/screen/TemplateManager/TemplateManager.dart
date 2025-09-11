import 'package:empire_ios/Apis/TemplateManagerApis.dart';
import 'package:empire_ios/Models/TemplateModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/TemplateCreate/TemplateCreate.dart';
import 'package:empire_ios/widget/TemplateWidget.dart';
import 'package:flutter/material.dart';

List<TemplateModel>? templates = [];

class TemplateManager extends StatefulWidget {
  const TemplateManager({key});

  @override
  State<TemplateManager> createState() => _TemplateManagerState();
}

class _TemplateManagerState extends State<TemplateManager> {
  var loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() {
    TemplateManagerApis.getTemplates().then((value) {
      templates = value!;
      setState(() {
        loading = false;
      });
    });
  }

  TemplateModel selectedTemplate = TemplateModel();
  @override
  Widget build(BuildContext context) {
    var sr = 0;
    return loading
        ? CircleAvatar()
        : LayoutBuilder(builder: (context, constraints) {
            final layoutInfo = Myf.getWidthInfo(constraints);

            return Scaffold(
              appBar: AppBar(
                title: Text('Template Manager'),
                backgroundColor: jsmColor,
              ),
              body: Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: Container(
                        child: ListView(
                          children: [
                            ...templates!.map(
                              (templateModel) {
                                sr++;
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        selectedTemplate = templateModel;
                                      });
                                    },
                                    leading: Text("${sr}"),
                                    title: Text(templateModel.name ?? ""),
                                    subtitle: Text(templateModel.status ?? ""),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min, // Ensures the Row takes only the required width
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () async {
                                            await Myf.Navi(context, TemplateCreate(templateModel: templateModel));
                                            getData();
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => TemplateManagerApis.deleteTemplate(templateModel.name ?? "").then((value) {
                                            getData();
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )),
                  Flexible(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/img/chatBackground.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: ListView(
                          children: [
                            selectedTemplate.name != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TemplateWidget(templateModel: selectedTemplate, layoutInfo: layoutInfo),
                                    ],
                                  )
                                : SizedBox.shrink()
                          ],
                        ),
                      ))
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  await Myf.Navi(context, TemplateCreate());
                  getData();
                },
                label: Text('Create New Template'),
                backgroundColor: jsmColor,
              ),
            );
          });
  }
}

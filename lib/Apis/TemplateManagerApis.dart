import 'package:empire_ios/Models/TemplateModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/framework.dart';

class TemplateManagerApis {
  static Future<List<TemplateModel>?> getTemplates() async {
    List<TemplateModel> templates = [];
    await fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("templates").get().then((value) {
      value.docs.forEach((element) {
        var data = element.data();
        var templateModel = TemplateModel.fromJson(Myf.convertMapKeysToString(data));
        templates.add(templateModel);
      });
      return templates;
    });

    return templates;
  }

  static Future<bool> deleteTemplate(String id) async {
    try {
      await fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("templates").doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static createTemplate(BuildContext context, TemplateModel templateModel) async {
    await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("templates")
        .doc(templateModel.name)
        .set(templateModel.toJson());
  }
}

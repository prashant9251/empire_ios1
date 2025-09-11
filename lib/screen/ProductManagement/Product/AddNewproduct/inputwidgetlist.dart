import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class inputBoxClassWidget {
  static Container InputField(
      {ctrl, label, hint, validator, textsize, height, TextInputTypeKeyBord, prefix = const Icon(Icons.search), maxLine = 1}) {
    var ctrltmp = TextEditingController();
    return Container(
      height: height == null ? 70 : height,
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
        child: TextFormField(
          keyboardType: TextInputTypeKeyBord == null ? TextInputType.text : TextInputTypeKeyBord,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              return validator.toString().isNotEmpty ? validator : null;
            }
            return null;
          },
          autofocus: false,
          maxLines: maxLine,
          cursorColor: Colors.blue,
          controller: ctrl != null ? ctrl : ctrltmp,
          decoration: InputDecoration(
            suffix: prefix,
            errorStyle: TextStyle(fontSize: 8),
            hintStyle: TextStyle(fontSize: textsize == null ? 10.0 : textsize),
            label: Text("$label", style: TextStyle(fontSize: 10)),
            hintText: "$hint",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

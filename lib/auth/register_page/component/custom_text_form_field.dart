import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/mytheme.dart';

import '../../../provider/app_config_provider.dart';

class CustomTextFormField extends StatelessWidget {
  String label;
  TextInputType keyboardType;
  TextEditingController controller;
  String? Function(String?) validator;
  bool isPassword;

  CustomTextFormField(
      {required this.label,
      this.keyboardType = TextInputType.text,
      required this.controller,
      required this.validator,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(
            label,
            style: TextStyle(
                color: provider.isDarkMode()
                    ? MyTheme.whiteColor
                    : MyTheme.blackColor),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
              BorderSide(width: 3, color: Theme.of(context).primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
              BorderSide(width: 3, color: Theme.of(context).primaryColor)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(width: 3, color: MyTheme.redColor)),
        ),
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
      ),
    );
  }
}

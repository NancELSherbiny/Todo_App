import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Dialog_utils/dialog_utils.dart';
import 'package:todo/FireBaseUtils.dart';
import 'package:todo/auth/login_page/login.dart';
import 'package:todo/auth/register_page/component/custom_text_form_field.dart';
import 'package:todo/model/myuser.dart';
import 'package:todo/provider/auth_provider.dart';

import '../../home/homepage.dart';

class RegisterPage extends StatelessWidget {
  static const String routeName = 'register';

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passController = TextEditingController();

  var confirmPassController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Stack(
        children: [
          Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    CustomTextFormField(
                      label: 'User Name',
                      controller: nameController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter User Name';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter Email';
                        }
                        bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if (!emailValid) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      label: 'Password',
                      keyboardType: TextInputType.number,
                      isPassword: true,
                      controller: passController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter Password';
                        }
                        if (text.length < 6) {
                          return 'Password should be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      label: 'Confirm Password',
                      keyboardType: TextInputType.number,
                      isPassword: true,
                      controller: confirmPassController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter Confirmation Password';
                        }
                        if (text != passController.text) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          register(context);
                        },
                        child: Text(
                          'Register',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(LoginPage.routeName);
                        },
                        child: Text('Account already exists'))
                  ],
                ),
              ))
        ],
      ),
    );
  }

  void register(BuildContext context) async {
    if (formKey.currentState!.validate() == true) {
      DialogUtils.showLoading(context, 'Loading...');

      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passController.text);

        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            email: emailController.text,
            name: nameController.text);

        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(myUser);

        await FireBaseUtils.addUserToFireStore(myUser);

        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'Regsiter Successfully',
            title: 'Success',
            positiveActionName: 'ok',
            barrierDismissible: false, positiveAction: () {
          Navigator.pushReplacementNamed(context, HomePage.routeName);
        });
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context, 'The password provided is too weak.',
              title: 'Error',
              positiveActionName: 'ok',
              barrierDismissible: false);
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context, 'The account already exists for that email.',
              title: 'Error',
              positiveActionName: 'ok',
              barrierDismissible: false);
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, e.toString(),
            title: 'Error',
            positiveActionName: 'ok',
            barrierDismissible: false);
      }
    }
  }
}

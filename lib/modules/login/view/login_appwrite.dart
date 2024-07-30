import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/main.dart';
import 'package:appwrite/models.dart' as models;
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';

class LoginAppwritePage extends StatelessWidget {
  models.User? loggedInUser;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppWriteController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(loggedInUser != null ? 'Logged in as ${loggedInUser!.name}' : 'Not logged in'),
              SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      controller.login(emailController.text, passwordController.text);
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      controller.register(emailController.text, passwordController.text, nameController.text);
                    },
                    child: Text('Register'),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      controller.logout();
                    },
                    child: Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

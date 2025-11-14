import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/repositories.dart';

class LoginController extends GetxController {
  final AuthRepository authRepository = Get.find();

  Future<void> login() async {
    await authRepository.login();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: OutlinedButton(
          onPressed: controller.login,
          child: const Text("Login"),
        ),
      ),
    );
  }
}

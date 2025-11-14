import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wirwa/data/datasource/job_vacancy.dart';
import 'package:wirwa/data/datasource/user.dart';
import 'package:wirwa/data/key.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/login.dart';

Future<void> main() async {
  await Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_API_KEY);
  Get.put<JobVacancyRepository>(JobVacancyDataSource());
  Get.put<UserRepository>(UserDataSource());
  runApp(const WirwaApp());
}

class WirwaApp extends StatelessWidget {
  const WirwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wirwa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(),
    );
  }
}

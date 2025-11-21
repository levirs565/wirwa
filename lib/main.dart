import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:wirwa/data/datasource/auth.dart';
import 'package:wirwa/data/datasource/job_vacancy.dart';
import 'package:wirwa/data/datasource/user.dart';
import 'package:wirwa/data/key.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:wirwa/screen/landing_screen.dart';
import 'package:wirwa/screen/login.dart';
import 'package:wirwa/screen/splash_screen.dart';
import 'package:wirwa/data/datasource/job_application.dart';
import 'package:wirwa/data/datasource/workshop.dart';
import 'package:wirwa/data/model.dart';

// Import Halaman yang BENAR
import 'package:wirwa/screen/recruiter/main.dart';
import 'package:wirwa/screen/recruiter/new_profile.dart';
import 'package:wirwa/screen/job_seeker/main.dart';
import 'package:wirwa/screen/job_seeker/new_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  // Inisialisasi Supabase
  await Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_API_KEY);

  // Dependency Injection
  Get.put<SupabaseClient>(Supabase.instance.client, permanent: true);
  Get.put<AuthRepository>(AuthDataSource(), permanent: true);
  Get.put<UserRepository>(UserDataSource(), permanent: true);
  Get.put<JobVacancyRepository>(JobVacancyDataSource(), permanent: true);
  Get.put<JobApplicationRepository>(JobApplicationDataSource(), permanent: true);
  Get.put<WorkshopRepository>(WorkshopDataSource(), permanent: true);

  Get.put(WirwaController(), permanent: true);

  runApp(const WirwaApp());
}

class WirwaController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final UserRepository userRepository = Get.find();

  StreamSubscription<String?>? _authSubscription;
  String? _lastUserId;

  @override
  void onReady() {
    super.onReady();
    _authSubscription = authRepository.userChangedStream().listen((userId) {
      if (userId != _lastUserId) {
        _lastUserId = userId;
        handleAuthChange();
      }
    });

    _lastUserId = authRepository.getUserId();

    // Delay 3 detik agar Splash Screen tampil
    Future.delayed(const Duration(seconds: 3), () {
      handleAuthChange();
    });
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }

  Future<void> handleAuthChange() async {
    if (_lastUserId == null) {
      Get.offAll(const LandingScreen());
      return;
    }

    var role = await userRepository.getUserRole(_lastUserId!);
    if (role == null) {
      role = await configureRole();
    }

    // LOGIKA NAVIGASI YANG SUDAH DIBETULKAN
    if (role == UserRole.RECRUITER) {
      final profile = await userRepository.getRecruiterProfile(_lastUserId!);
      if (profile == null) {
        Get.off(RecruiterNewProfilePage());
      } else {
        Get.off(RecruiterPage());
      }
    } else if (role == UserRole.JOB_SEEKER) {
      final profile = await userRepository.getJobSeekerProfile(_lastUserId!);
      if (profile == null) {
        Get.off(JobSeekerNewProfilePage());
      } else {
        Get.off(JobSeekerPage()); // Memanggil JobSeekerPage, bukan RecruiterPage
      }
    }
  }

  Future<UserRole> configureRole() async {
    final role = await Get.bottomSheet<UserRole>(
      Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              title: const Text("Job Seeker"),
              onTap: () => Get.back(result: UserRole.JOB_SEEKER),
            ),
            ListTile(
              title: const Text("Recruiter"),
              onTap: () => Get.back(result: UserRole.RECRUITER),
            ),
          ],
        ),
      ),
      isDismissible: false,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    if (role != null) {
      await userRepository.setUserRole(_lastUserId!, role);
      return role;
    }

    return UserRole.JOB_SEEKER;
  }
}

class WirwaApp extends StatelessWidget {
  const WirwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wirwa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
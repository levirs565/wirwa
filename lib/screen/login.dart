import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/data/repositories.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginController extends GetxController {
  final AuthRepository authRepository = Get.find<AuthRepository>();

  var isLoading = false.obs;

  Future<void> login() async {
    try {
      isLoading.value = true;
      await authRepository.login();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  // LoginPage({super.key}) {
  //   if (!Get.isRegistered<AuthRepository>()) {
  //     Get.put(AuthRepository());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Mengambil warna dominan dari gambar (Pinkish Red)
    final Color primaryColor = const Color(0xFFE91E63);
    final Color softPink = const Color(0xFFFCE4EC);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // 1. Header Text
              Text(
                'Selamat Datang',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF880E4F),
                ),
              ),

              const SizedBox(height: 10),

              // 2. Logo "SheWorks" (PNG Image)
              Image.asset(
                'assets/images/logo.png',
                height: 60,
                width: 90,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              // 3. Subtitle
              Text(
                'Masuk & Temukan Kesempatan\nBaru!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 60),

              Image.asset(
                'assets/images/gambar1.png',
                height: 150,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              // 4. Tombol Login (Hanya Gmail/Google)
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Ikon Google sederhana
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.g_mobiledata,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Masuk & Daftar dengan Google",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Footer section
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Text(
                      "Temukan peluang karir yang aman\ndan nyaman untuk Anda",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Data Anda aman dan terlindungi",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

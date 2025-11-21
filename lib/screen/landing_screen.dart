import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wirwa/screen/login.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentPage = 0;
  late PageController _pageController;

  // Palet Warna Baru
  final Color gradientTop = const Color(0xFFFDCDDA);
  final Color gradientBottom = Colors.white;
  final Color btnNextColor = const Color(0xFFA01355);
  final Color btnMasukColor = const Color(0xFFDD3885);
  final Color indicatorActiveColor = const Color(0xFFFF8A80);
  final Color indicatorInactiveColor = const Color(0xFFE0E0E0); // Abu-abu muda untuk titik tidak aktif

  final List<Map<String, String>> _splashData = [
    {
      "image": "assets/images/gambar1.png",
      "title": "Perempuan Hebat, Saatnya Berdaya!",
      "text": "Temukan pekerjaan dan peluang lainnya. Mulai langkah kecil menuju kemandirian ekonomi.",
    },
    {
      "image": "assets/images/gambar2.png",
      "title": "Kerja Fleksibel, Sesuai Kemampuanmu",
      "text": "Dapatkan pekerjaan ringan tanpa perlu skill rumit.",
    },
    {
      "image": "assets/images/gambar3.png",
      "title": "Tambah Ilmu, Perluas Kesempatan",
      "text": "Ikuti workshop dan pelatihan praktis untuk meningkatkan kemampuan.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Get.offAll(() => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);

    return Scaffold(
      // Scaffold transparan karena background ada di Container
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // BACKGROUND GRADASI: Pink #FDCDDA ke Putih
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientTop, gradientBottom],
            stops: const [0.0, 0.6], // Pink di atas, mulai memudar ke putih di tengah agak bawah
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Tombol Skip DIHAPUS sesuai permintaan

              Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemCount: _splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: _splashData[index]["image"]!,
                    title: _splashData[index]['title']!,
                    text: _splashData[index]['text']!,
                    mq: mq,
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
                  child: Column(
                    children: [
                      const Spacer(),
                      // Indikator Halaman
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _splashData.length,
                              (index) => buildDot(index: index),
                        ),
                      ),
                      const Spacer(flex: 2),
                      // Tombol Utama
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage == _splashData.length - 1) {
                              _navigateToLogin();
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            // LOGIKA WARNA TOMBOL:
                            // Jika halaman terakhir (Masuk) -> #DD3885
                            // Jika halaman lain (Selanjutnya) -> #A01355
                            backgroundColor: _currentPage == _splashData.length - 1
                                ? btnMasukColor
                                : btnNextColor,
                            foregroundColor: Colors.white, // Teks tombol putih
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 3,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                // LOGIKA TEKS TOMBOL
                                _currentPage == _splashData.length - 1 ? "Masuk" : "Selanjutnya",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Ikon panah kecil jika "Selanjutnya"
                              if (_currentPage != _splashData.length - 1)
                                const Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      // Logika lebar titik
      width: _currentPage == index ? 25 : 8,
      decoration: BoxDecoration(
        // LOGIKA WARNA INDIKATOR: #FF8A80 jika aktif
        color: _currentPage == index ? indicatorActiveColor : indicatorInactiveColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    super.key,
    required this.image,
    required this.title,
    required this.text,
    required this.mq,
  });

  final String image, title, text;
  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          image,
          height: mq.height * 0.35,
        ),
        const Spacer(),
        // JUDUL
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Font Hitam sesuai request
            ),
          ),
        ),
        SizedBox(height: mq.height * 0.02),
        // DESKRIPSI
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87, // Font Hitam (agak soft) agar mudah dibaca
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:salink_mobile/theme/salink_colors.dart';
import 'package:salink_mobile/widgets/left_drawer.dart';

import 'package:salink_mobile/screens/saling_beli/saling_beli_page.dart';
import 'package:salink_mobile/screens/saling_tebeng/saling_tebeng_page.dart';
import 'package:salink_mobile/screens/saling_bagi/saling_bagi_page.dart';
import 'package:salink_mobile/screens/saling_pinjam/saling_pinjam_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaLinkColors.orange,

      appBar: AppBar(
        backgroundColor: SaLinkColors.brown,
        foregroundColor: SaLinkColors.yellow,
        elevation: 0,
        title: const Text(
          'SaLink',
          style: TextStyle(
            fontFamily: 'Anton',
            fontSize: 28,
            color: SaLinkColors.yellow,
            letterSpacing: 0.5,
          ),
        ),
      ),

      drawer: const LeftDrawer(),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          final isMobile = screenWidth <= 680;
          final isTablet = screenWidth > 680 && screenWidth <= 960;

          final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);
          final horizontalPadding = isMobile ? 20.0 : 24.0;
          final heroHeight = isMobile ? 350.0 : 420.0;

          final titleSize = (screenWidth * 0.43).clamp(
            100.0,
            380.0,
          );

          return SingleChildScrollView(
            child: Column(
              children: [
                // HERO SECTION
                SizedBox(
                  height: heroHeight - 65,
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        left: horizontalPadding,
                        right: horizontalPadding,
                        bottom: -65,
                        child: SizedBox(
                          width: double.infinity,
                          height: heroHeight * 0.85,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'SaLink',
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Anton',
                                fontSize: titleSize,
                                height: 1.1,
                                color: const Color(0xFFFFF6DC),
                                letterSpacing: -2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // MAIN CONTENT PANEL
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: SaLinkColors.cream,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(70),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 15,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    isMobile ? 32 : 44,
                    horizontalPadding,
                    60,
                  ),

                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 1080,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LAYANAN MAHASISWA',
                            style: TextStyle(
                              fontFamily: 'Anton',
                              fontSize: 28,
                              color: SaLinkColors.brown,
                              letterSpacing: 0.3,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Temukan semua kemudahan aktivitas kampus '
                            'dalam satu genggaman',
                            style: TextStyle(
                              fontSize: 15,
                              color: SaLinkColors.orange,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // SERVICE CARDS
                          GridView.count(
                            crossAxisCount: crossAxisCount,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 285,

                            children: [
                              _ServiceCard(
                                emoji: '🛒',
                                title: 'SALING BELI',
                                description:
                                    'Prelove barang kos, buku kuliah, '
                                    'dan peralatan elektronik murah '
                                    'atau hibah gratis sesama mahasiswa UI.',
                                buttonText: 'JELAJAHI BELI',
                                onTap: () => _navigateTo(
                                  context,
                                  const SalingBeliPage(),
                                ),
                              ),

                              _ServiceCard(
                                emoji: '🛵',
                                title: 'SALING NEBENG',
                                description:
                                    'Cari atau tawarkan tebengan hemat '
                                    '& ramah lingkungan di sekeliling '
                                    'area kampus Depok & Salemba.',
                                buttonText: 'CARI TEBENGAN',
                                onTap: () => _navigateTo(
                                  context,
                                  const SalingTebengPage(),
                                ),
                              ),

                              _ServiceCard(
                                emoji: '🍱',
                                title: 'SALING BAGI',
                                description:
                                    'Berbagi makanan berlebih atau '
                                    'peroleh hidangan berkah dari '
                                    'kantin dan sesama rekan mahasiswa.',
                                buttonText: 'LIHAT MAKANAN',
                                onTap: () => _navigateTo(
                                  context,
                                  const SalingBagiPage(),
                                ),
                              ),

                              _ServiceCard(
                                emoji: '🤝',
                                title: 'SALING PINJAM',
                                description:
                                    'Pinjam jas lab, kalkulator saintifik, '
                                    'toga, perkakas, hingga proyektor '
                                    'untuk kegiatan akademik.',
                                buttonText: 'PINJAM BARANG',
                                onTap: () => _navigateTo(
                                  context,
                                  const SalingPinjamPage(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// SERVICE CARD WIDGET
class _ServiceCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SaLinkColors.yellow,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),

        child: Padding(
          padding: const EdgeInsets.all(8),

          child: Column(
            children: [
              // ICON AREA
              SizedBox(
                height: 90,
                width: double.infinity,
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),

              // CARD CONTENT
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    14,
                    14,
                    14,
                    12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6DC),
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 19,
                          color: SaLinkColors.brown,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Expanded(
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.45,
                            color: SaLinkColors.orange,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // ACTION BUTTON
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: SaLinkColors.brown,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              buttonText,
                              style: const TextStyle(
                                fontFamily: 'Anton',
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_forward,
                              size: 13,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
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
}

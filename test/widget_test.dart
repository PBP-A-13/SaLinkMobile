import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salink_mobile/main.dart';
import 'package:salink_mobile/screens/auth/login_page.dart';
import 'package:salink_mobile/screens/menu.dart';
import 'package:salink_mobile/screens/saling_beli/saling_beli_page.dart';
import 'package:salink_mobile/screens/saling_pinjam/saling_pinjam_page.dart';

void main() {
  testWidgets('SaLink Mobile root smoke test (LoginPage displayed initially)',
      (WidgetTester tester) async {
    // Memberikan resolusi layar standar mobile agar tidak overflow saat test rendering
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Pastikan LoginPage tampil sebagai halaman awal
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('SaLink'), findsWidgets);
  });

  testWidgets('MyHomePage displays SaLink services correctly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const MaterialApp(home: MyHomePage()));
    await tester.pumpAndSettle();

    expect(find.text('LAYANAN MAHASISWA'), findsOneWidget);
    expect(find.text('SALING BELI'), findsOneWidget);
    expect(find.text('SALING PINJAM'), findsOneWidget);
  });

  testWidgets('SalingBeliPage renders catalog header and search field',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const MaterialApp(home: SalingBeliPage()));
    await tester.pumpAndSettle();

    expect(find.text('SaLink - Beli'), findsOneWidget);
    expect(find.text('Cari Barang Prelove UI...'), findsOneWidget);
    expect(find.text('URUTKAN'), findsOneWidget);
  });

  testWidgets('SalingPinjamPage renders calendar and borrow sections',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const MaterialApp(home: SalingPinjamPage()));
    await tester.pumpAndSettle();

    expect(find.text('SaLink - Pinjam'), findsOneWidget);
    expect(find.text('PINJAMAN AKTIF SAYA'), findsOneWidget);
  });
}

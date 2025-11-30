// lib/route.dart (updated with register flow)
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/aspiration.dart';
import 'package:jawaramobile/features/keuangan/presentations/pages/iuran/kategori_iuran_page.dart';
import 'package:jawaramobile/features/keuangan/presentations/pages/iuran/tambah_iuran_page.dart';
import 'package:jawaramobile/features/keuangan/presentations/pages/keuangan_page.dart';
import 'package:jawaramobile/features/keuangan/presentations/pages/lainya_page.dart';
import 'package:jawaramobile/features/keuangan/presentations/pages/pemasukkan/detail_pemasukan.dart';
import 'package:jawaramobile/features/keuangan/presentations/pages/pemasukkan/pemasukan_lain.dart';
import 'package:jawaramobile/features/keuangan/presentations/pages/pemasukkan/tambah_pemasukkan.dart';
import 'package:jawaramobile/features/keuangan/presentations/pages/tagihan/detail_tagihan.dart';
import 'package:jawaramobile/features/keuangan/presentations/pages/tagihan/tagihan.dart';
import 'package:jawaramobile/features/onboarding/onboarding_page.dart';
import 'package:jawaramobile/features/pengaturan/presentation/pages/settings_page.dart';
import 'package:jawaramobile/features/kegiatan/presentations/pages/kegiatan.dart';
import 'package:jawaramobile/features/kegiatan/presentations/pages/tambah_kegiatan_page.dart';

// Broadcast imports
import 'package:jawaramobile/features/broadcast/presentations/pages/daftar_broadcast.dart';
import 'package:jawaramobile/features/broadcast/presentations/pages/tambah_broadcast_page.dart';

// Warga imports
import 'package:jawaramobile/features/warga/presentations/pages/keluarga/detail_keluarga/keluarga_detail.dart';
import 'package:jawaramobile/features/warga/presentations/pages/lainnya/lainnya.dart';
import 'package:jawaramobile/features/warga/presentations/pages/mutasi/daftar_mutasi/daftar_mutasi_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/mutasi/detail_mutasi/detail_mutasi_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/mutasi/tambah_mutasi/tambah_mutasi_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/penerimaan_warga/penerimaan_warga_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/rumah/daftar_rumah/daftar_rumah_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/rumah/detail_rumah/detail_rumah_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/rumah/edit_rumah/edit_rumah_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/rumah/tambah_rumah/tambah_rumah_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/statistik/statistik_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/warga/daftar_warga/daftar_warga_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/warga/detail_warga/detail_warga_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/warga/tambah_warga/tambah_warga_page.dart';
import 'package:jawaramobile/features/warga/presentations/pages/dashboard/warga_page.dart';

// Dashboard
import '../features/dashboard/presentations/pages/home_page.dart';

// Auth
import '../features/auth/presentations/pages/login_page.dart';

// Main
import 'package:jawaramobile/features/main_shell.dart';

// Register
import '../features/register/presentations/pages/register_step1_account.dart';
import '../features/register/presentations/pages/register_step2_warga.dart';
import '../features/register/presentations/pages/register_step3_rumah.dart';

// Warga
import 'package:jawaramobile/features/warga/presentations/pages/keluarga/daftar_keluarga/daftar_keluarga_page.dart';

final router = GoRouter(
  // Di development mode langsung ke /kegiatan, di production ke /login
  initialLocation: kDebugMode ? '/kegiatan' : '/login',
  
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingPage()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    // Register flow
    GoRoute(
      path: '/register/step1',
      builder: (context, state) => RegisterStep1Account(),
    ),
    GoRoute(
      path: '/register/step2',
      builder: (context, state) => RegisterStep2Warga(),
    ),
    GoRoute(
      path: '/register/step3',
      builder: (context, state) => RegisterStep3Rumah(),
    ),
    // Shell route for bottom nav or persistent layout
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/homepage',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/keuangan',
          name: 'keuangan',
          builder: (context, state) => const KeuanganPage(),
        ),
        GoRoute(
          path: '/warga',
          name: 'warga',
          builder: (context, state) => const WargaPage(),
        ),
        GoRoute(
          path: '/kegiatan',
          name: 'kegiatan',
          builder: (context, state) => const KegiatanPage(),
        ),
        GoRoute(
          path: '/pengaturan',
          name: 'pengaturan',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),

    // Menu Warga Routes
    GoRoute(
      path: '/warga/keluarga',
      builder: (context, state) => const DaftarKeluargaPage(),
    ),
    GoRoute(
      path: '/warga/keluarga/detail',
      builder: (context, state) {
        final keluargaId = state.extra as int;
        return KeluargaDetail(keluargaId: keluargaId);
      },
    ),
    GoRoute(
      path: '/warga/lainnya',
      builder: (context, state) => const Lainnya(),
    ),
    GoRoute(
      path: '/warga/statistik',
      builder: (context, state) => const StatistikPage(),
    ),
    GoRoute(
      path: '/warga/daftar-warga',
      builder: (context, state) => const DaftarWargaPage(),
    ),
    GoRoute(
      path: '/warga/daftar-warga/detail/:id',
      builder: (context, state) {
        final wargaId = int.parse(state.pathParameters['id']!);
        return DetailWargaPage(wargaId: wargaId);
      },
    ),

    GoRoute(
      path: '/warga/daftar-rumah',
      builder: (context, state) => const DaftarRumahPage(),
    ),
    GoRoute(
      path: '/warga/daftar-rumah/detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return DetailRumahPage(rumahId: id);
      },
    ),
    GoRoute(
      path: '/warga/daftar-rumah/edit/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return EditRumahPage(rumahId: id);
      },
    ),

    GoRoute(
      path: '/warga/tambah-rumah',
      builder: (context, state) => const TambahRumahPage(),
    ),
    GoRoute(
      path: '/warga/daftar-mutasi',
      builder: (context, state) => const DaftarMutasiPage(),
    ),
    GoRoute(
      path: '/warga/daftar-mutasi/detail/:id',
      builder: (context, state) {
      final id = int.parse(state.pathParameters['id']!);
      return DetailMutasiPage(mutasiId: id);
    }
    ),
    GoRoute(
      path: '/warga/tambah-mutasi',
      builder: (context, state) => const TambahMutasiPage(),
    ),
    GoRoute(
      path: '/warga/penerimaan-warga',
      builder: (context, state) => const PenerimaanWargaPage(),
    ),

    GoRoute(
      path: '/warga/tambah-warga',
      builder: (context, state) => const TambahWargaPage(),
    ),
    GoRoute(
      path: '/warga/aspirasi',
      builder: (context, state) => const AspirationPage(),
    ),

    // Keuangan Routes
    GoRoute(
      path: '/keuangan/lainnya',
      builder: (context, state) => const LainnyaPage(),
    ),
    GoRoute(
      path: '/keuangan/iuran/kategori-iuran',
      builder: (context, state) => const KategoriIuranPage(),
    ),
    GoRoute(
      path: '/keuangan/iuran/tambah-iuran',
      builder: (context, state) => const TambahIuranPage(),
    ),
    GoRoute(
      path: '/keuangan/tagihan/tagihan',
      builder: (context, state) => const TagihanPage(),
    ),
    GoRoute(
      path: '/keuangan/tagihan/detail',
      builder: (context, state) => const DetailTagihanPage(),
    ),
    GoRoute(
      path: '/keuangan/pemasukan-lain',
      builder: (context, state) => const PemasukanLainPage(),
    ),
    GoRoute(
      path: '/keuangan/pemasukan-lain/detail',
      builder: (context, state) => const PemasukanLainDetailPage(),
    ),
    GoRoute(
      path: '/keuangan/pemasukkan/tambah-pemasukkan',
      builder: (context, state) => const TambahPemasukanPage(),
    ),
    GoRoute(
      path: '/keuangan/statistik/statistik',
      builder: (context, state) => const StatistikPage(),
    ),

    // Kegiatan Routes
    GoRoute(
      path: '/kegiatan/tambah-kegiatan',
      builder: (context, state) => const TambahKegiatanPage(),
    ),

    // ============================================
    // BROADCAST ROUTES - TAMBAHKAN DISINI
    // ============================================
    GoRoute(
      path: '/broadcast/tambah-broadcast',
      name: 'tambah-broadcast',
      builder: (context, state) => const TambahBroadcastPage(),
    ),
    GoRoute(
      path: '/broadcast/daftar-broadcast',
      name: 'daftar-broadcast',
      builder: (context, state) => const DaftarBroadcastPage(),
    ),
  ],
);

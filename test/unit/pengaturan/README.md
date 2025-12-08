# Log Activity Test Suite

Test suite untuk fitur Log Activity dalam aplikasi Jawara Mobile.

## Test Coverage

### 1. Model Tests (`providers/log_activity_providers_test.dart`)

Test untuk `LogActivityModel`:
- ✅ Parsing data dari map dengan benar
- ✅ Handling null `user_id`
- ✅ Parsing ID dari string
- ✅ Handling empty title
- ✅ Parsing timestamp dengan format lengkap
- ✅ Support alternative field names (camelCase dan snake_case)

**Total: 7 tests**

### 2. Widget/Page Tests (`pages/log_activity_page_test.dart`)

Test untuk `LogActivityPage`:
- ✅ Menampilkan log activities dengan benar
- ✅ Menampilkan label group (Hari ini, Kemarin)
- ✅ Menampilkan actor dengan label yang sesuai:
  - "Anda" untuk user yang sedang login
  - "User [id]..." untuk user lain
  - "Sistem" untuk aktivitas tanpa user
- ✅ Search/filter activities berdasarkan query
- ✅ Menampilkan loading state
- ✅ Menampilkan error state
- ✅ Menampilkan empty state
- ✅ Clear search functionality
- ✅ Back button navigation

**Total: 8 tests**

## Menjalankan Test

### Menjalankan semua test log activity:
```bash
flutter test test/unit/pengaturan/
```

### Menjalankan test tertentu:
```bash
# Model tests
flutter test test/unit/pengaturan/providers/log_activity_providers_test.dart

# Widget tests
flutter test test/unit/pengaturan/pages/log_activity_page_test.dart
```

### Dengan coverage:
```bash
flutter test test/unit/pengaturan/ --coverage
```

## Struktur Test

```
test/unit/pengaturan/
├── providers/
│   └── log_activity_providers_test.dart  # Model & Provider tests
└── pages/
    └── log_activity_page_test.dart       # Widget & UI tests
```

## Test Result

```
00:28 +13: All tests passed! ✅
```

Semua 13 test berhasil dijalankan dengan sukses.

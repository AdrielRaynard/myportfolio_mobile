# MyPortfolio Mobile

Aplikasi portofolio pribadi berbasis Flutter sebagai kelanjutan dari proyek Tutorial 08 untuk **Individual Assignment 7: Basic Flutter** pada mata kuliah **Pemrograman Berbasis Platform (CSGE602022)**, Fakultas Ilmu Komputer, Universitas Indonesia, Semester Gasal 2026/2027.

Aplikasi ini menampilkan identitas pemilik portofolio, menyediakan beberapa kartu aksi, dan menyajikan ringkasan portofolio melalui bottom sheet. Implementasi berfokus pada widget tree Flutter, pemisahan widget menjadi komponen yang dapat digunakan kembali, `StatelessWidget`, penggunaan `BuildContext`, serta interaksi dasar Material Design 3.

## Daftar Isi

- [Fitur](#fitur)
- [Teknologi dan dependensi](#teknologi-dan-dependensi)
- [Struktur proyek](#struktur-proyek)
- [Persiapan dan menjalankan aplikasi](#persiapan-dan-menjalankan-aplikasi)
- [Pengujian dan analisis kode](#pengujian-dan-analisis-kode)
- [Catatan implementasi](#catatan-implementasi)
- [Progres pengerjaan](#progres-pengerjaan)
- [Tugas 7](#tugas-7)
- [AI Disclosure](#ai-disclosure)

## Fitur

### Fitur utama sesuai tugas

- **Informasi profil:** menampilkan NPM `2506587150`, nama `Adriel Raynard Davis Sihotang`, dan kelas `PBP B` melalui tiga komponen `InfoCard`.
- **Kartu aksi portofolio:** menyediakan tombol `Lihat Proyek`, `Tambah Proyek`, dan `Logout`, masing-masing dengan ikon serta warna latar berbeda.
- **Umpan balik interaksi:** ketika salah satu dari tiga kartu aksi utama ditekan, aplikasi menampilkan `SnackBar` dengan format pesan `Kamu telah menekan tombol [Nama Tombol]!`.
- **Struktur widget:** halaman utama dipisahkan ke `lib/menu.dart`, sedangkan bootstrap aplikasi berada di `lib/main.dart`. `MyHomePage` dan komponen tampilannya menggunakan `StatelessWidget`.

### Fitur ekstra dan peningkatan UI/UX

- **Tentang Portofolio:** kartu aksi keempat yang membuka modal bottom sheet berisi ringkasan aplikasi, nama pemilik, identitas NPM dan kelas, serta chip teknologi/topik (`Flutter`, `Material 3`, dan `PBP`). Bottom sheet dapat ditutup melalui tombol `Tutup`.
- **Grid responsif:** jumlah kolom kartu aksi menyesuaikan lebar yang tersedia. Tampilan menggunakan dua kolom pada lebar di bawah 600 logical pixels dan empat kolom mulai dari 600 logical pixels.
- **Semantics untuk kartu aksi:** setiap kartu dibungkus dengan `Semantics` dan diberi label serta penanda bahwa elemen tersebut merupakan tombol.
- **Material Design 3:** tema aplikasi dibuat dengan `ColorScheme.fromSeed` dan `useMaterial3: true`.

> **Batasan fungsional saat ini:** `Lihat Proyek`, `Tambah Proyek`, dan `Logout` masih berupa demonstrasi interaksi yang menampilkan `SnackBar`. Ketiganya belum membuka daftar proyek, menyimpan proyek baru, atau mengakhiri sesi autentikasi. Aplikasi pada tugas ini belum menggunakan backend, database, maupun sistem login.

## Teknologi dan dependensi

- **Flutter** untuk membangun antarmuka aplikasi multiplatform.
- **Dart** sebagai bahasa pemrograman.
- **Material Design 3** untuk sistem tema dan komponen UI.
- `cupertino_icons: ^1.0.8` sebagai dependensi ikon.
- `flutter_test` untuk widget testing.
- `flutter_lints: ^6.0.0` untuk aturan analisis/lint Dart.

Versi SDK Dart yang dideklarasikan proyek pada `pubspec.yaml` adalah `^3.13.7`. Gunakan Flutter SDK yang menyertakan versi Dart yang memenuhi constraint tersebut.

## Struktur proyek

```text
myportofolio_mobile/
├── lib/
│   ├── main.dart          # Entry point, MyApp, MaterialApp, dan tema aplikasi
│   └── menu.dart          # MyHomePage dan seluruh widget/komponen halaman utama
├── test/
│   └── widget_test.dart   # Pengujian widget halaman utama dan interaksinya
├── android/               # Konfigurasi platform Android
├── ios/                   # Konfigurasi platform iOS
├── web/                   # Konfigurasi platform web
├── windows/               # Konfigurasi platform Windows
├── linux/                 # Konfigurasi platform Linux
├── macos/                 # Konfigurasi platform macOS
├── analysis_options.yaml  # Konfigurasi lint/analyzer
├── pubspec.yaml           # Metadata proyek dan dependensi
├── pubspec.lock           # Versi dependensi yang terkunci
└── README.md              # Dokumentasi proyek
```

### Pembagian tanggung jawab kode

- **`lib/main.dart`**: menjalankan `runApp(const MyApp())`. `MyApp` mengatur `MaterialApp`, judul aplikasi, tema Material 3, dan `MyHomePage` sebagai halaman awal.
- **`lib/menu.dart`**: mendefinisikan `MyHomePage`, data profil, daftar item aksi, alur penanganan tap, serta komponen UI yang digunakan pada halaman utama dan bottom sheet.
- **`test/widget_test.dart`**: memeriksa tampilan profil dan kartu aksi, warna kartu, pesan `SnackBar`, serta perilaku buka/tutup bottom sheet.

## Persiapan dan menjalankan aplikasi

### Prasyarat

1. Pasang Flutter SDK dan pastikan perintah `flutter` tersedia di terminal.
2. Pasang editor seperti Visual Studio Code atau Android Studio.
3. Siapkan emulator Android/iOS atau perangkat fisik yang telah terhubung. Untuk menjalankan target lain, siapkan toolchain platform yang sesuai.

Periksa instalasi Flutter dengan:

```bash
flutter --version
flutter doctor
```

### Instalasi dependensi

Buka terminal di root folder `myportofolio_mobile`, lalu jalankan:

```bash
flutter pub get
```

### Menjalankan aplikasi

```bash
flutter run
```

Jika terdapat lebih dari satu perangkat/target yang tersedia, Flutter akan meminta pemilihan perangkat atau kamu dapat menentukan device melalui opsi `-d`.

## Pengujian dan analisis kode

Jalankan widget test dari root folder proyek:

```bash
flutter test
```

Test yang tersedia saat ini mencakup:

1. Memastikan NPM, nama, kelas, dan empat kartu aksi tampil, serta masing-masing kartu menggunakan warna yang diharapkan.
2. Memastikan tiga aksi utama menampilkan pesan `SnackBar` yang sesuai dengan nama tombol.
3. Memastikan kartu `Tentang Portofolio` membuka bottom sheet dengan informasi ringkasan, lalu tombol `Tutup` menutupnya.

Jalankan static analysis dengan:

```bash
flutter analyze
```

Sebelum pengumpulan, pastikan test berhasil dan hasil analisis menunjukkan `No issues found!`. Jalankan juga aplikasi pada emulator/perangkat untuk memeriksa tata letak, keterbacaan teks, dan interaksi secara langsung. Dokumentasi ini tidak menyatakan bahwa perintah-perintah tersebut telah lulus pada mesin lokal; hasilnya perlu dikonfirmasi setelah dijalankan menggunakan Flutter SDK di lingkungan pengembangan.

## Catatan implementasi

### Model data kartu aksi

`ItemHomepage` menyimpan properti yang diperlukan untuk menampilkan satu kartu aksi, yaitu `name`, `icon`, `color`, dan `action`. Daftar kartu dideklarasikan satu kali pada `MyHomePage`, sehingga warna serta perilaku masing-masing kartu ditentukan oleh data item, bukan oleh percabangan pewarnaan yang berulang di dalam `ItemCard`.

`PortfolioAction` membedakan respons kartu yang menampilkan umpan balik (`showFeedback`) dengan kartu yang membuka ringkasan portofolio (`showOverview`). `ItemCard` bertanggung jawab pada tampilan dan meneruskan tap melalui callback `onTap`, sedangkan `MyHomePage` menentukan respons interaksinya.

### Widget tree ringkas

```text
MyApp
└── MaterialApp
    └── MyHomePage
        └── Scaffold
            ├── AppBar
            └── SafeArea
                └── SingleChildScrollView
                    └── Padding
                        └── Column
                            ├── Row
                            │   ├── InfoCard (NPM)
                            │   ├── InfoCard (Name)
                            │   └── InfoCard (Class)
                            ├── Text (pesan sambutan)
                            ├── Text (judul menu)
                            └── LayoutBuilder
                                └── GridView.builder
                                    └── ItemCard (sesuai data item)
```

Bottom sheet dibuat terpisah melalui `PortfolioOverviewSheet`, dengan `PortfolioDetail` sebagai komponen untuk setiap baris informasi.

## Progres pengerjaan

Proyek dikembangkan secara bertahap dari basis Tutorial 08. Riwayat commit berikut diambil dari repositori proyek pada saat dokumentasi ini disusun:

| Tanggal | Commit | Perubahan |
|---|---|---|
| 11 Nov 2026 | `cd92ce5` | `Tutorial 08: Basic Flutter` — basis awal proyek Flutter. |
| 14 Nov 2026 | `3ea8f21` | `Mengkustomisasi action cards portfolio` — kustomisasi kartu aksi dan warna. |
| 14 Nov 2026 | `dbbd0d4` | `Mengcover home interaction portfolio` — pengujian widget untuk halaman utama dan interaksi. |
| 15 Nov 2026 | `a4d0139` | `Menambahkan overview sheet portfolio` — fitur ekstra bottom sheet ringkasan portofolio. |

Perubahan disimpan dalam beberapa commit terpisah agar progres dan tujuan setiap perubahan dapat ditelusuri. Dokumentasi tugas dan AI disclosure ini disiapkan sebagai perubahan README tersendiri setelah fitur utama, pengujian, dan fitur ekstra.

## Tugas 7

### 1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!

Widget tree adalah struktur hierarkis yang menggambarkan bagaimana widget-widget disusun untuk membentuk antarmuka Flutter. Setiap widget dapat memiliki satu atau beberapa child, sedangkan widget yang menaunginya disebut parent. Parent menentukan bagaimana child ditempatkan, diukur, diberi batasan, atau menerima konfigurasi. Flutter menyusun antarmuka dengan menggabungkan widget-widget kecil menjadi struktur yang lebih besar.

Pada aplikasi ini, `MyApp` mengembalikan `MaterialApp`, lalu `MaterialApp` menampilkan `MyHomePage` melalui properti `home`. Di dalam `MyHomePage`, `Scaffold` menjadi kerangka halaman yang memiliki `AppBar` dan body. Body berisi `SafeArea`, `SingleChildScrollView`, `Padding`, dan `Column`. `Column` kemudian memiliki beberapa child seperti `Row` untuk tiga `InfoCard`, teks sambutan, dan `LayoutBuilder` yang membangun grid `ItemCard`. Dengan susunan tersebut, perubahan pada parent dapat memengaruhi tata letak child tanpa setiap child harus mengatur keseluruhan halaman sendiri.

### 2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!

Widget pada aplikasi dikelompokkan berdasarkan perannya sebagai berikut.

**Widget aplikasi dan struktur halaman:**

- `MyApp`: widget khusus yang menjadi pembungkus konfigurasi aplikasi.
- `MaterialApp`: menyediakan kerangka aplikasi bergaya Material, tema, dan halaman awal.
- `MyHomePage`: widget khusus untuk menyusun halaman utama portofolio.
- `Scaffold`: menyediakan struktur dasar halaman, termasuk area app bar dan body.
- `AppBar`: menampilkan judul `MyPortfolio` di bagian atas halaman.
- `SafeArea`: menjaga konten agar tidak tertutup area sistem seperti notch atau status bar.
- `SingleChildScrollView`: memungkinkan konten halaman digulir secara vertikal.
- `Padding`: memberi jarak di sekeliling child.
- `Column`: menyusun komponen halaman secara vertikal.
- `Row`: menyusun tiga kartu informasi secara horizontal.
- `Expanded`: membagi ruang yang tersedia secara fleksibel di dalam `Row`.
- `SizedBox`: memberi jarak atau ukuran kosong di antara komponen.
- `LayoutBuilder`: membaca constraint lebar yang tersedia untuk menentukan tata letak grid responsif.
- `GridView.builder`: membangun kartu aksi dalam bentuk grid berdasarkan daftar item.
- `Center`: menempatkan ikon dan teks kartu aksi di tengah area kartu.

**Widget informasi, teks, dan tampilan:**

- `InfoCard`: widget khusus yang menampilkan judul dan isi informasi profil.
- `Card`: memberi tampilan kartu pada setiap informasi profil.
- `Text`: menampilkan judul, deskripsi, label, dan konten teks lainnya.
- `Icon`: menampilkan ikon untuk masing-masing aksi dan informasi.
- `Container`: menyediakan area dengan ukuran dan dekorasi, termasuk handle visual di bagian atas bottom sheet.
- `CircleAvatar`: menampilkan ikon avatar pada ringkasan portofolio.
- `ListTile`: menyusun ikon, label, dan nilai informasi dalam satu baris.
- `Wrap`: menyusun chip dan memungkinkan susunannya berpindah baris jika ruang tidak cukup.
- `Chip`: menampilkan label teknologi/topik seperti Flutter, Material 3, dan PBP.

**Widget interaksi dan aksesibilitas:**

- `ItemCard`: widget khusus untuk menampilkan satu kartu aksi portofolio.
- `Semantics`: memberi informasi semantik bahwa kartu merupakan tombol serta menetapkan labelnya.
- `Material`: menyediakan permukaan Material dan warna latar kartu.
- `InkWell`: menangani interaksi tap sekaligus memberikan efek sentuhan Material.
- `SnackBar`: menampilkan umpan balik singkat setelah tiga aksi utama ditekan.
- `FilledButton`: tombol Material terisi yang digunakan untuk menutup bottom sheet melalui konstruktor `FilledButton.icon`.

**Widget bottom sheet:**

- `PortfolioOverviewSheet`: widget khusus yang berisi tampilan ringkasan portofolio.
- `PortfolioDetail`: widget khusus untuk satu baris detail, seperti nama pemilik dan identitas.

Selain widget di atas, kode juga menggunakan beberapa API/kelas pendukung yang bukan widget, misalnya `ThemeData`, `ColorScheme`, `TextStyle`, `BoxDecoration`, `BorderRadius`, `SliverGridDelegateWithFixedCrossAxisCount`, `NeverScrollableScrollPhysics`, model data `ItemHomepage`, dan enum `PortfolioAction`.

### 3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!

`MaterialApp` merupakan widget tingkat atas yang menyiapkan konfigurasi dasar aplikasi dengan pola desain Material. Widget ini menjadi tempat untuk mengatur hal-hal seperti tema, skema warna, judul aplikasi, routing/navigasi, dan halaman awal. `MaterialApp` juga menyiapkan infrastruktur yang diperlukan oleh banyak komponen Material, sehingga widget di bawahnya dapat menggunakan fitur seperti tema dan navigasi melalui konteks widget.

Pada proyek ini, `MyApp` mengembalikan `MaterialApp` dengan judul `MyPortfolio`, tema yang dibuat dari `ColorScheme.fromSeed`, opsi `useMaterial3: true`, dan `MyHomePage` sebagai `home`. `MaterialApp` sesuai digunakan sebagai root karena seluruh halaman dan komponen Material berada di bawah satu konfigurasi aplikasi yang konsisten.

### 4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget?

`StatelessWidget` digunakan untuk komponen yang tidak menyimpan state lokal yang berubah selama masa hidup widget. Tampilan dibangun dari konfigurasi/properti yang diterima. Jika input atau konfigurasi dari parent berubah, Flutter dapat membangun ulang widget dengan nilai baru.

`StatefulWidget` digunakan ketika sebuah komponen perlu memiliki state yang dapat berubah, misalnya nilai counter, status pilihan, input form, tab aktif, atau hasil proses yang diperbarui selama widget ditampilkan. Nilai state disimpan dalam objek `State`, dan perubahan state yang memengaruhi UI biasanya diberitahukan menggunakan `setState` atau mekanisme state management lain.

Pada aplikasi ini, `MyHomePage`, `InfoCard`, `ItemCard`, `PortfolioOverviewSheet`, dan `PortfolioDetail` menggunakan `StatelessWidget` karena tidak menyimpan data lokal yang berubah. Daftar kartu serta identitas profil bersifat tetap selama aplikasi berjalan. Tap pada kartu hanya memicu callback yang menampilkan `SnackBar` atau meminta Flutter membuka bottom sheet; pengelolaan tampilan sementara tersebut ditangani oleh mekanisme Flutter, bukan state lokal `MyHomePage`. `StatefulWidget` baru diperlukan jika fitur berikutnya menambahkan, misalnya, form tambah proyek dengan input yang berubah, filter proyek, atau data yang dapat diedit langsung pada halaman.

### 5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build?

`BuildContext` adalah referensi ke lokasi sebuah widget di dalam widget tree. Melalui context, sebuah widget dapat menemukan informasi atau layanan yang disediakan oleh ancestor (widget induk di atasnya), misalnya tema, navigator, atau scaffold messenger. Karena itu, context penting untuk mengakses konfigurasi dan mekanisme yang mengikuti posisi widget di dalam tree.

Pada proyek ini, `build(BuildContext context)` menggunakan context untuk mengambil warna dan tema melalui `Theme.of(context)`, contohnya saat mengatur warna `AppBar`, gaya teks, dan warna pada `PortfolioOverviewSheet`. Context juga digunakan oleh `ScaffoldMessenger.of(context)` untuk menampilkan `SnackBar`, oleh `showModalBottomSheet` untuk membuka bottom sheet pada navigator yang sesuai, serta oleh `Navigator.of(context).pop()` untuk menutup bottom sheet. Context yang digunakan harus berasal dari bagian tree yang tepat agar ancestor yang dicari memang tersedia.

### 6. Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?

**Hot reload** menerapkan perubahan kode Dart ke aplikasi yang sedang berjalan dan membangun ulang bagian UI yang terdampak tanpa menghapus state aplikasi yang sedang aktif. Proses ini mempercepat iterasi tampilan karena developer dapat melihat perubahan tanpa mengulang seluruh alur aplikasi. Secara umum, hot reload tidak menjalankan ulang `main()` dan tidak mengulang `initState()` pada state yang sudah ada.

**Hot restart** memulai ulang bagian aplikasi Dart sehingga state dalam memori direset dan `main()` dijalankan kembali. Berbeda dari hot reload, nilai state sementara yang sedang digunakan tidak dipertahankan. Namun, hot restart tidak sama dengan membangun ulang aplikasi native dari awal.

**Full restart** menghentikan dan menjalankan ulang aplikasi beserta proses build/launch platform yang diperlukan. Full restart diperlukan ketika perubahan menyentuh sisi native atau konfigurasi platform, misalnya kode Kotlin/Swift, konfigurasi Android/iOS, pengaturan Gradle atau CocoaPods, atau integrasi plugin native yang tidak dapat diterapkan hanya dengan hot reload. Setelah menambahkan atau mengubah dependensi, jalankan `flutter pub get`; perubahan plugin/native juga dapat memerlukan full restart.

Dalam praktiknya, gunakan hot reload untuk perubahan UI dan logika Dart biasa. Gunakan hot restart ketika perubahan memerlukan inisialisasi ulang aplikasi atau ketika hot reload tidak menerapkan perubahan yang diharapkan. Gunakan full restart ketika perubahan berada pada lapisan native atau konfigurasi build platform.

## AI Disclosure

AI digunakan sebagai alat bantu selama pengerjaan, bukan sebagai pengganti pemahaman, keputusan, atau tanggung jawab pengembang. Informasi berikut menjelaskan penggunaan AI pada tugas ini secara spesifik.

### Tools yang digunakan

- **ChatGPT (OpenAI):** membantu membaca instruksi dan rubrik dari PDF, meninjau struktur serta kode proyek Flutter, menyarankan pembagian pengerjaan, membantu menyiapkan patch kode dan widget test pada tahap sebelumnya, serta membantu menyusun dokumentasi dan jawaban reflektif pada README ini.

### Strategi prompting

Proses bantuan AI dilakukan secara bertahap dan berbasis konteks proyek:

1. Memberikan dokumen tugas beserta rubrik penilaian agar AI memahami kriteria wajib dan kriteria nilai tertinggi.
2. Memberikan arsip proyek agar saran dan dokumentasi mengacu pada file, nama widget, identitas, dan alur kode yang benar-benar digunakan.
3. Meminta analisis struktur terlebih dahulu sebelum meminta perubahan, serta menetapkan batasan agar file proyek tidak diubah tanpa persetujuan.
4. Memecah pekerjaan menjadi patch terpisah untuk fitur utama, pengujian, fitur ekstra, dan dokumentasi agar perubahan dapat ditinjau dan di-commit secara bertahap.

### Bagian yang dibantu AI

- Menguraikan persyaratan tugas dan menghubungkannya dengan struktur proyek.
- Membantu merancang dan menyiapkan perubahan kartu aksi, model data item, warna kartu, serta umpan balik `SnackBar`.
- Membantu menyiapkan widget test untuk tampilan profil, warna kartu, interaksi, dan bottom sheet.
- Membantu menyiapkan fitur ekstra bottom sheet `Tentang Portofolio`.
- Membantu menyusun uraian struktur aplikasi, enam jawaban reflektif, instruksi setup, catatan progres, dan bagian AI disclosure ini.

### Evaluasi kritis atas keterbatasan AI dan tanggung jawab pengembang

AI dapat menghasilkan kode atau penjelasan yang tampak masuk akal tetapi belum tentu cocok dengan versi SDK, struktur proyek, atau perilaku aplikasi pada perangkat sebenarnya. AI juga dapat salah menafsirkan requirement, mengasumsikan fitur telah berjalan padahal baru berupa contoh interaksi, atau menyatakan pengujian berhasil tanpa benar-benar menjalankannya. Karena itu, hasil AI tidak langsung dianggap benar dan tetap perlu dibandingkan dengan kode serta rubrik tugas.

Beberapa keputusan dan pemeriksaan yang menjadi tanggung jawab pengembang:

- Mengintegrasikan hasil patch ke repositori secara bertahap dalam commit yang terpisah, bukan menyerahkan akses commit/push kepada AI.
- Menggunakan identitas pemilik portofolio sendiri (`2506587150`, `Adriel Raynard Davis Sihotang`, dan `PBP B`) alih-alih membiarkan data contoh tutorial tetap digunakan. Keakuratan data ini tetap harus dipastikan oleh pemilik sebelum pengumpulan.
- Memilih fitur tambahan yang masih relevan dengan konteks portofolio, yaitu ringkasan profil dalam bottom sheet, tanpa mengubah fokus tugas menjadi aplikasi CRUD atau autentikasi.
- Menjaga dokumentasi agar tidak melebih-lebihkan kemampuan aplikasi: tiga aksi utama saat ini menampilkan `SnackBar`, bukan benar-benar mengelola data proyek atau melakukan logout.
- Menjalankan `flutter analyze`, `flutter test`, serta uji manual pada emulator/perangkat sebelum pengumpulan. Hasil validasi harus berasal dari eksekusi lokal pengembang; dokumentasi ini tidak mengarang hasil pengujian yang belum dikonfirmasi.

AI membantu mempercepat eksplorasi dan penyusunan solusi, tetapi keputusan akhir, pemahaman kode, pemeriksaan hasil, dan tanggung jawab atas isi repositori tetap berada pada pengembang.

## Referensi

- [Flutter documentation](https://docs.flutter.dev/)
- [Flutter: Hot reload](https://docs.flutter.dev/tools/hot-reload)
- [Dart documentation](https://dart.dev/guides)

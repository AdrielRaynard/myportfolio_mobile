# MyPortfolio Mobile

Aplikasi Flutter untuk Tugas 7 dan 8 Pemrograman Berbasis Platform (CSGE602022), Fakultas Ilmu Komputer Universitas Indonesia, Semester Gasal 2026/2027. Homepage menampilkan profil Adriel Raynard Davis Sihotang. User dapat membuka formulir proyek, menambahkan riwayat pendidikan, dan melihat daftar pendidikan berdasarkan jenjang atau tahun masuk.

## Daftar Isi

- [Fitur](#fitur)
- [Teknologi dan dependensi](#teknologi-dan-dependensi)
- [Struktur proyek](#struktur-proyek)
- [Persiapan dan menjalankan aplikasi](#persiapan-dan-menjalankan-aplikasi)
- [Pengujian dan analisis kode](#pengujian-dan-analisis-kode)
- [Catatan implementasi](#catatan-implementasi)
- [Progres pengerjaan](#progres-pengerjaan)
- [Tugas 8 — formulir, navigasi, dan refleksi](#tugas-8)
- [Tugas 7](#tugas-7)
- [AI Disclosure](#ai-disclosure)

## Fitur

### Menu beranda

| Kartu | Saat ditekan |
|---|---|
| Lihat Proyek dan Logout | Menampilkan umpan balik melalui `SnackBar`. |
| Tambah Proyek | Membuka formulir proyek. **Save** memvalidasi isian lalu menampilkan ringkasan. |
| Tentang Portofolio | Membuka ringkasan profil dalam *bottom sheet* yang dapat ditutup. |
| Tambah Pendidikan | Membuka formulir pendidikan. **Simpan** menampilkan ringkasan dan menambahkan entri yang valid ke daftar sesi. |
| Daftar Pendidikan | Menampilkan kartu riwayat dengan filter jenjang dan pilihan urutan. |

Kartu beranda tersusun dalam dua kolom pada ponsel dan empat kolom ketika lebar area menu mencapai 600 piksel logis. Drawer menyediakan **Home**, **Add Project**, **Tambah Pendidikan**, dan **Daftar Pendidikan**.

### Daftar Pendidikan

Buka **Daftar Pendidikan** dari kartu beranda atau drawer. Setiap kartu menampilkan sekolah, jenjang, periode, serta jurusan dan deskripsi bila diisi. Tahun lulus yang kosong ditampilkan sebagai **Sekarang**.

Saat pertama dibuka, daftar menampilkan **Semua** jenjang dengan urutan **Terbaru ke terlama** berdasarkan tahun masuk. Tiga entri awal berasal dari migrasi pendidikan aplikasi web, yaitu Fakultas Ilmu Komputer, Universitas Indonesia (2025), SMAK PENABUR Bintaro Jaya (2022), dan SMPK PENABUR Bintaro Jaya (2019).

Untuk mencoba kedua kontrol, buka **Tambah Pendidikan** dan simpan satu sekolah berjenjang **SMA/SMK** dengan tahun masuk **2020**. Setelah menutup ringkasan, buka **Daftar Pendidikan** dari drawer, pilih **SMA/SMK**, lalu pilih **Terlama ke terbaru**. Sekolah tahun 2020 muncul sebelum SMAK PENABUR Bintaro Jaya (2022). Balik urutannya untuk melihat sekolah tahun 2022 di atas. Memilih jenjang yang masih kosong, misalnya **S2**, menampilkan pesan “Belum ada riwayat pendidikan S2.”

Jika dua sekolah memiliki tahun masuk yang sama, nama sekolah menentukan urutan alfabetisnya. Entri tambahan tersedia selama sesi aplikasi. Saat aplikasi dimulai ulang, daftar kembali ke tiga entri awal.

Jalankan `flutter test test/education_list_test.dart` untuk menguji daftar awal, filter kosong, kombinasi filter dan urutan, serta masa simpan entri baru.

## Teknologi dan dependensi

- **Flutter** untuk membangun antarmuka aplikasi multiplatform.
- **Dart** sebagai bahasa pemrograman.
- **Material Design 3** untuk sistem tema dan komponen UI.
- `material_ui: ^1.11.1` untuk komponen Material yang diimpor oleh layar aplikasi.
- `cupertino_icons: ^1.0.8` sebagai dependensi ikon.
- `flutter_test` untuk widget testing.
- `flutter_lints: ^6.0.0` untuk aturan analisis/lint Dart.

Versi SDK Dart yang dideklarasikan proyek pada `pubspec.yaml` adalah `^3.13.7`. Gunakan Flutter SDK yang menyertakan versi Dart yang memenuhi constraintnya.

## Struktur proyek

| Lokasi | Tanggung jawab |
|---|---|
| [lib/main.dart](lib/main.dart) | Menyiapkan tema dan beranda. `_MyAppState` menyimpan entri pendidikan selama sesi aplikasi. |
| [lib/screens/menu.dart](lib/screens/menu.dart) dan [lib/widgets/project_card.dart](lib/widgets/project_card.dart) | Menampilkan profil, kartu menu, dan ringkasan portofolio. |
| [lib/widgets/left_drawer.dart](lib/widgets/left_drawer.dart) | Menampilkan tujuan yang sama di setiap layar dan mengatur riwayat navigasi. |
| [lib/screens/project_form.dart](lib/screens/project_form.dart) | Menangani formulir proyek dari Tutorial 09. |
| [lib/screens/education_form.dart](lib/screens/education_form.dart) dan [lib/validation/education_validators.dart](lib/validation/education_validators.dart) | Memisahkan isian dan dialog dari aturan teks dan tahun. |
| [lib/models/education.dart](lib/models/education.dart) dan [lib/models/education_history.dart](lib/models/education_history.dart) | Mendefinisikan model, lima jenjang, data awal, dan akses ke riwayat dari tiap layar. |
| [lib/screens/education_list.dart](lib/screens/education_list.dart) | Menyaring riwayat lalu mengurutkan salinannya untuk ditampilkan sebagai kartu. |
| [test/](test/) | Berisi tes widget, tes validator, dan fungsi bantu navigasi. |

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

Untuk menjalankan versi web di Chrome, gunakan `flutter run -d chrome`. Perintah `flutter devices` menampilkan target yang terdeteksi.

## Pengujian dan analisis kode

Dari folder proyek, jalankan:

```sh
flutter analyze
flutter test
```

Pada **23 November 2026**, analisis kode selesai dengan `No issues found!` dan **17 dari 17 tes lulus** pada implementasi `315af74`. Pemeriksaan menggunakan dependensi lokal dengan opsi `--no-pub`.

| Berkas | Tes | Perilaku yang diperiksa |
|---|---:|---|
| [widget_test.dart](test/widget_test.dart) | 5 | Profil dan kartu aksi, umpan balik, formulir proyek, serta ringkasan portofolio. |
| [education_validators_test.dart](test/education_validators_test.dart) | 4 | Nama sekolah setelah markup dibersihkan, batas 255 karakter Unicode, batas tahun, serta hubungan tahun masuk dan lulus. |
| [education_form_test.dart](test/education_form_test.dart) | 6 | Dua jalur masuk dan kembali ke beranda, pesan kesalahan, enam nilai ringkasan, serta tombol Simpan pada simulasi layar 320 × 568 dengan papan ketik terbuka. |
| [education_list_test.dart](test/education_list_test.dart) | 2 | Urutan awal, jenjang kosong, kombinasi filter dan urutan untuk dua SMA, serta masa simpan entri. |

**Langkah uji manual di Chrome atau ponsel**

1. Buka **Tambah Pendidikan** dari kartu beranda. Tekan **Simpan** saat isian kosong. Nama sekolah dan tahun masuk menampilkan pesan pada kolom masing-masing.
2. Isi sekolah **SMA Melati**, jenjang **SMA/SMK**, tahun masuk **2020**, dan tahun lulus **2019**. Tekan **Simpan**. Perbaiki tahun lulus menjadi **2023**, simpan lagi, lalu cocokkan nilai di dialog. **Tutup** mengembalikan pengguna ke formulir dengan isian yang masih terlihat.
3. Buka **Daftar Pendidikan** lewat drawer. Pilih **SMA/SMK**, lalu ubah urutan. Bandingkan posisi **SMA Melati (2020)** dan **SMAK PENABUR Bintaro Jaya (2022)**. Pilih **S2** pada sesi yang hanya berisi data awal dan contoh tadi untuk melihat pesan daftar kosong.
4. Di Chrome, buka formulir lewat drawer, lalu pilih **Home** dari drawer formulir untuk kembali ke beranda. Di ponsel, buka formulir dari kartu dan coba tombol kembali perangkat. Buka lagi formulir, fokuskan kolom tahun, lalu gulir dan tekan **Simpan** saat papan ketik terbuka.

Hasil 17 tes di atas berasal dari pengujian otomatis. Langkah manual ini dapat dipakai untuk demonstrasi. Hasil uji langsung oleh pemilik pada browser atau perangkat fisik belum tercatat.

## Catatan implementasi

Isian yang sedang diketik berada di `_EducationFormPageState`. Setelah validasi berhasil, `EducationHistory.of(context).add(education)` meneruskan satu objek `Education` ke `_MyAppState`. Karena pemilik daftar berada di atas `MaterialApp`, berpindah rute tidak menghapus entri. Filter dan urutan berada di `_EducationListPageState`, sehingga mengubah urutan tampilan tidak mengubah data sesi.

### Model dan isian pendidikan

Saya memilih riwayat pendidikan karena tiap entri portofolio mempunyai jenjang dan periode yang bisa dibandingkan. Formulir Flutter mengikuti enam atribut `Education` di aplikasi Django. `EducationFormPage` menggunakan `StatefulWidget` untuk menyimpan lima pengendali teks dan satu pilihan jenjang. Semua isian berada di dalam satu `Form`. Setelah validasi berhasil, aplikasi menyimpan objek `Education` dalam riwayat sesi dan menampilkan keenam nilainya di `AlertDialog`.

| Atribut web | Isian Flutter | Aturan |
|---|---|---|
| `nama_sekolah` | Nama Sekolah / Universitas | Wajib, maksimal 255 karakter. Spasi atau tag HTML saja ditolak. |
| `tingkat` | Tingkat Pendidikan | Dropdown SMP, SMA/SMK, S1, S2, atau S3. Pilihan awal S1. |
| `jurusan` | Jurusan | Opsional, maksimal 255 karakter. |
| `tahun_masuk` | Tahun Masuk | Wajib, bilangan bulat dari 1900 hingga 2100. |
| `tahun_lulus` | Tahun Lulus | Opsional, dalam rentang yang sama. Boleh sama dengan tahun masuk. Jika lebih awal, pesan kesalahan muncul pada kolom ini. |
| `deskripsi` | Deskripsi Pendidikan | Teks beberapa baris, opsional. |

## Progres pengerjaan

| Pekan | Tanggal | Commit | Hasil |
|---|---|---|---|
| 16–22 November | 18 Nov | `3f6aeca` | Tutorial 09 menjadi dasar formulir proyek dan drawer. |
| 16–22 November | 21 Nov | `dd71e2f` | Model, validator, dan formulir pendidikan dengan dialog ringkasan. |
| 16–22 November | 21 Nov | `614627d` | Kartu beranda dan drawer terhubung ke formulir. |
| 16–22 November | 22 Nov | `429388d` | Tes navigasi, validasi, dialog, dan layar sempit. |
| 16–22 November | 22 Nov | `315af74` | Daftar pendidikan tersaring dan terurut dengan penyimpanan selama sesi. |
| 23–29 November | 23 Nov | Dokumentasi | Refleksi, log penggunaan AI, dan pemeriksaan ulang seluruh suite tes. |


## Refleksi tugas individu

### Tugas 8

1. **Apa perbedaan `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`? Bagaimana kartu membuka formulir dan bagaimana Home membawa pengguna kembali?**

   Kartu **Tambah Pendidikan** memakai `Navigator.push()` untuk menaruh `EducationFormPage` di atas beranda. Beranda tetap berada di bawahnya, sehingga tombol kembali perangkat membuka beranda semula. `pushReplacement()` mengganti rute teratas. Saya memakainya ketika pengguna berpindah lewat drawer dari satu halaman sekunder ke halaman lain, misalnya dari formulir ke daftar. `pop()` menutup rute atau lapisan teratas. Contohnya, **Tutup** pada dialog memanggil `Navigator.pop(context)` sehingga pengguna melihat kembali formulir beserta isinya.

   Untuk **Home**, `LeftDrawer` terlebih dahulu memanggil `navigator.pop()` untuk menutup drawer. Jika pengguna berada di halaman lain, `popUntil((route) => route.isFirst)` melepas rute sampai beranda yang sudah ada terlihat kembali. [Kartu beranda](lib/screens/menu.dart) · [Navigasi drawer](lib/widgets/left_drawer.dart)

2. **Bagaimana `Scaffold`, `AppBar`, dan `Drawer` menjaga konsistensi halaman? Di mana warna tema yang sama digunakan?**

   Setiap layar memakai `Scaffold` sebagai kerangka. Properti `appBar` menempatkan judul di atas, `drawer` menampilkan `LeftDrawer` dengan tujuan yang sama, dan `body` berisi konten khusus layar tersebut. Pengguna yang berpindah dari beranda ke formulir tetap menemukan **Home** di tempat yang sama. Latar app bar beranda, formulir pendidikan, dan daftar pendidikan mengambil warna `primary` dari tema yang dibentuk dengan `ColorScheme.fromSeed(seedColor: Colors.indigo, ...)`. Pada kedua layar pendidikan, warna teks dan ikon berasal dari `onPrimary`. [Tema](lib/main.dart) · [Beranda](lib/screens/menu.dart) · [Formulir](lib/screens/education_form.dart) · [Daftar](lib/screens/education_list.dart)

3. **Mengapa formulir memakai susunan ini? Bagaimana jarak dan pengguliran membantu saat ruang layar terbatas?**

   Keenam isian dan tombol **Simpan** disusun dalam satu `Column` agar pengguna bisa membaca dari atas ke bawah. Padding 16 piksel logis di tepi dan `Column.spacing` sebesar 16 memberi jarak antara kontrol, termasuk ketika pesan kesalahan menambah tinggi isian. `ConstrainedBox` membatasi lebar formulir hingga 560 piksel logis di layar lebar. Saat papan ketik memperkecil area yang terlihat, `SingleChildScrollView` memungkinkan pengguna menggulir sampai **Simpan**. Tes pada layar 320 × 568 memeriksa posisi tombol di atas papan ketik dan menekannya sampai ringkasan terbuka. [Tata letak](lib/screens/education_form.dart) · [Tes layar sempit](test/education_form_test.dart)

4. **Apa peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat Simpan ditekan? Mengapa pemilihan jenis input belum cukup?**

   `_formKey` menghubungkan tombol **Simpan** ke `FormState` milik formulir. Di `_submit()`, `_formKey.currentState!.validate()` menjalankan validator yang terpasang pada setiap kolom. Validator mengembalikan pesan untuk nilai yang salah dan `null` untuk nilai yang diterima. Jika ada kesalahan, Flutter menampilkan pesan pada kolom terkait dan `_submit()` berhenti. Setelah semua kolom lolos, aplikasi membuat objek `Education`, menyimpannya untuk sesi berjalan, lalu membuka dialog ringkasan.

   Contohnya, jika tahun masuk **2020** dan tahun lulus **2019**, kedua nilai berupa bilangan bulat dalam rentang yang diizinkan. Namun, validator **Tahun Lulus** membaca kedua tahun dan menolak **2019** karena pendidikan belum dimulai saat itu. `TextInputType.number` hanya memilih tata letak papan ketik. Angka tetap dapat ditempel, dan papan ketik tidak memeriksa rentang maupun hubungan antarkolom. [Alur Simpan](lib/screens/education_form.dart) · [Aturan validasi](lib/validation/education_validators.dart) · [Tes validator](test/education_validators_test.dart)

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

## Fitur tambahan/kreativitas

Selain memenuhi persyaratan utama Individual Assignment 7, saya mengembangkan beberapa fitur tambahan untuk meningkatkan interaktivitas, responsivitas, dan struktur kode aplikasi MyPortfolio Mobile.

Kartu Tambahan "Tentang Portofolio"

Saya menambahkan kartu aksi keempat bernama "Tentang Portofolio" dengan warna latar blue-grey. Kartu ini merupakan fitur tambahan di luar tiga tombol utama yang diwajibkan dalam tugas. Penambahan kartu ini memberikan akses kepada pengguna untuk mengenal aplikasi dan informasi pemilik portofolio lebih lanjut.

Bottom Sheet Interaktif

Ketika pengguna menekan kartu "Tentang Portofolio", aplikasi menampilkan Bottom Sheet yang berisi ringkasan aplikasi, identitas pemilik portofolio, serta informasi teknologi yang berkaitan dengan pengembangan aplikasi. Saya juga menambahkan tombol "Tutup" agar pengguna dapat menutup Bottom Sheet dan kembali ke halaman utama tanpa harus berpindah halaman.

Struktur Aksi yang Modular

Saya menerapkan struktur kode yang lebih modular dengan menggunakan enum PortfolioAction untuk menentukan jenis aksi setiap kartu. Selain itu, widget ItemCard menerima callback melalui parameter onTap, sehingga logika interaksi dapat dipisahkan dari tampilan kartu. Saya juga memisahkan tampilan Bottom Sheet ke dalam widget khusus agar kode lebih mudah dibaca, dikelola, dan dikembangkan.

Grid Responsif

Saya mengimplementasikan tampilan menu menggunakan LayoutBuilder agar susunan kartu dapat menyesuaikan ukuran layar perangkat. Pada layar mobile, kartu ditampilkan dalam dua kolom, sedangkan pada layar yang lebih lebar, kartu ditampilkan dalam empat kolom. Dengan demikian, tampilan aplikasi tetap terorganisasi pada berbagai ukuran layar.

Pengujian Widget untuk Bottom Sheet

Saya menambahkan pengujian widget pada widget_test.dart untuk memeriksa interaksi kartu "Tentang Portofolio". Pengujian ini mencakup proses membuka Bottom Sheet, memverifikasi informasi yang ditampilkan, menekan tombol "Tutup", serta memastikan Bottom Sheet berhasil ditutup.

Melalui pengembangan fitur-fitur tambahan tersebut, saya berusaha membuat MyPortfolio Mobile tidak hanya memenuhi kebutuhan dasar tugas, tetapi juga memiliki pengalaman pengguna yang lebih interaktif, tampilan yang responsif, serta struktur kode yang modular dan mudah dikembangkan.

## AI Disclosure

### Tugas 8 — log prompting dan evaluasi

Saya menggunakan ChatGPT (OpenAI) untuk membaca kebutuhan tugas, membandingkan model Django dengan Flutter, menyusun dan menerapkan patch, menulis tes, serta membantu menyusun refleksi dan dokumentasi. Berikut ringkasan percakapan yang menghasilkan keputusan proyek.

| Tahap | Permintaan atau keputusan saya | Hasil yang dapat diperiksa |
|---|---|---|
| Formulir | Saya meminta Patch 1 untuk riwayat pendidikan mengikuti model web. | Enam isian dan aturan tahun ada di model, formulir, dan validator. Ketika AI sempat menilai Patch 1 belum selesai karena menu belum terhubung, saya menunjukkan kembali pembagian patch. Navigasi kemudian diperiksa sebagai Patch 2. |
| Navigasi dan tes | Saya mengizinkan perubahan langsung untuk Patch 2 dan 3, serta mempertahankan commit dan push sebagai pekerjaan saya. | Kartu dan drawer membuka formulir. Tes memeriksa jalur kembali, kesalahan isian, dialog, dan tombol Simpan ketika papan ketik terbuka. |
| Fitur ekstra | Saya memilih daftar kartu dengan filter jenjang dan urutan tahun masuk sebagai pengganti usulan linimasa. | Pengujian memakai dua sekolah SMA/SMK dengan tahun masuk berbeda. Hasilnya menunjukkan bahwa filter tetap berlaku saat urutan dibalik. |
| Dokumentasi | Saya meminta Patch 5 diterapkan pada repositori yang sudah memuat empat patch sebelumnya. | README merujuk ke kode dan commit yang ada. Hasil 17 tes dan analisis dicatat setelah dijalankan ulang. |

Dua koreksi implementasi berasal dari pengujian. Header drawer sempat melampaui ruangnya, sehingga tinggi header dibuat mengikuti isi. Saat alur beranda diuji pada lebar 320 pixel, label kartu juga melampaui ruang vertikal. Grid kemudian memakai sel persegi agar label memiliki ruang. Perbaikan kode dan pemeriksaan otomatis tersebut dibantu AI. Keputusan mengganti fitur ekstra serta pembagian tanggung jawab commit dan push berasal dari saya sendiri.

### Catatan penggunaan AI pada Tugas 7

AI digunakan sebagai alat bantu selama pengerjaan, bukan sebagai pengganti pemahaman, keputusan, atau tanggung jawab pengembang. Informasi berikut menjelaskan penggunaan AI pada tugas ini secara spesifik.

#### Tools yang digunakan

- **ChatGPT (OpenAI):** membantu membaca instruksi dan rubrik dari PDF, meninjau struktur serta kode proyek Flutter, menyarankan pembagian pengerjaan, membantu menyiapkan patch kode dan widget test pada tahap sebelumnya, serta membantu menyusun dokumentasi dan jawaban reflektif pada README ini.

#### Strategi prompting

Proses bantuan AI dilakukan secara bertahap dan berbasis konteks proyek:

1. Memberikan dokumen tugas beserta rubrik penilaian agar AI memahami kriteria wajib dan kriteria nilai tertinggi.
2. Memberikan arsip proyek agar saran dan dokumentasi mengacu pada file, nama widget, identitas, dan alur kode yang benar-benar digunakan.
3. Meminta analisis struktur terlebih dahulu sebelum meminta perubahan, serta menetapkan batasan agar file proyek tidak diubah tanpa persetujuan.
4. Memecah pekerjaan menjadi patch terpisah untuk fitur utama, pengujian, fitur ekstra, dan dokumentasi agar perubahan dapat ditinjau dan di-commit secara bertahap.

#### Bagian yang dibantu AI

- Menguraikan persyaratan tugas dan menghubungkannya dengan struktur proyek.
- Membantu merancang dan menyiapkan perubahan kartu aksi, model data item, warna kartu, serta umpan balik `SnackBar`.
- Membantu menyiapkan widget test untuk tampilan profil, warna kartu, interaksi, dan bottom sheet.
- Membantu menyiapkan fitur ekstra bottom sheet `Tentang Portofolio`.
- Membantu menyusun uraian struktur aplikasi, enam jawaban reflektif, instruksi setup, catatan progres, dan bagian AI disclosure ini.

#### Evaluasi kritis atas keterbatasan AI dan tanggung jawab pengembang

AI dapat menghasilkan kode atau penjelasan yang tampak masuk akal tetapi belum tentu cocok dengan versi SDK, struktur proyek, atau perilaku aplikasi pada perangkat sebenarnya. AI juga dapat salah menafsirkan requirement, mengasumsikan fitur telah berjalan padahal baru berupa contoh interaksi, atau menyatakan pengujian berhasil tanpa benar-benar menjalankannya. Karena itu, hasil AI tidak langsung dianggap benar dan tetap perlu dibandingkan dengan kode serta rubrik tugas.

Beberapa keputusan dan pemeriksaan yang menjadi tanggung jawab pengembang:

- Mengintegrasikan hasil patch ke repositori secara bertahap dalam commit yang terpisah, bukan menyerahkan akses commit/push kepada AI.
- Menggunakan identitas pemilik portofolio sendiri (`2506587150`, `Adriel Raynard Davis Sihotang`, dan `PBP B`), bukannya malah membiarkan data contoh tutorial tetap digunakan. Keakuratan data ini tetap harus dipastikan oleh pemilik sebelum pengumpulan.
- Memilih fitur tambahan yang masih relevan dengan konteks portofolio, yaitu ringkasan profil dalam bottom sheet, tanpa mengubah fokus tugas menjadi aplikasi CRUD atau autentikasi.
- Menjaga dokumentasi agar tidak melebih-lebihkan kemampuan aplikasi: tiga aksi utama saat ini menampilkan `SnackBar`, bukan benar-benar mengelola data proyek atau melakukan logout.
- Menjalankan `flutter analyze`, `flutter test`, serta uji manual pada emulator/perangkat sebelum pengumpulan. Hasil validasi harus berasal dari eksekusi lokal pengembang; dokumentasi ini tidak mengarang hasil pengujian yang belum dikonfirmasi.

AI membantu mempercepat eksplorasi dan penyusunan solusi, tetapi keputusan akhir, pemahaman kode, pemeriksaan hasil, dan tanggung jawab atas isi repositori tetap berada pada pengembang.

## Referensi

- [Flutter documentation](https://docs.flutter.dev/)
- [Flutter API — Navigator.push](https://api.flutter.dev/flutter/widgets/Navigator/push.html)
- [Flutter API — Navigator.pushReplacement](https://api.flutter.dev/flutter/widgets/Navigator/pushReplacement.html)
- [Flutter Cookbook — Build a form with validation](https://docs.flutter.dev/cookbook/forms/validation)
- [Flutter: Hot reload](https://docs.flutter.dev/tools/hot-reload)
- [Dart documentation](https://dart.dev/guides)

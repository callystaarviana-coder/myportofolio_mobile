# myportofolio_mobile

# MyPortfolio Mobile

MyPortfolio Mobile adalah aplikasi Flutter untuk portofolio pribadi PBP. Halaman utama menampilkan identitas pemilik dan empat kartu aksi. Kartu Tambah Proyek dan Tambah Edukasi membuka formulir masing-masing. Kedua formulir dapat diakses dari drawer.

## Setup

Siapkan Flutter SDK dengan Dart yang memenuhi batas versi di `pubspec.yaml` (`^3.13.7`). Untuk menjalankan aplikasi di Chrome, jalankan perintah berikut dari direktori yang berisi `pubspec.yaml`.

```bash
flutter pub get
flutter run -d chrome
```

Untuk menjalankan aplikasi di emulator atau perangkat Android yang terhubung, gunakan `flutter run`. Jalankan pemeriksaan kode dan tes dari direktori yang sama.

```bash
flutter analyze
flutter test
flutter test --platform chrome
```

## Progres

- **Tutorial 08** — Menyiapkan proyek Flutter dan memisahkan halaman utama ke `lib/menu.dart`.
- **Tugas 7** — Menyesuaikan kartu profil, memberi warna berbeda pada tombol, dan memperbaiki layout saat ukuran teks diperbesar.
- **Tutorial 09** — Menambahkan drawer bersama, navigasi, serta formulir Tambah Proyek dan dialog ringkasannya.
- **Tugas 8** — Menambahkan formulir Edukasi, akses dari kartu dan drawer, validasi, dialog ringkasan, dan widget test.

### TUGAS INDIVIDU 7

1. Widget tree adalah susunan widget yang membentuk tampilan di Flutter. Saya lebih gampang memahaminya waktu mencari bagian yang perlu diubah untuk label profil. Di menu.dart, Row punya tiga Expanded di dalam children, lalu setiap Expanded punya satu InfoCard di dalam child. Row mengatur posisi kartu, Expanded membagi lebarnya, dan InfoCard mengatur isinya. Jadi saat mau mengganti Nama menjadi Name, saya cukup cari bagian InfoCard yang menerima label itu.

2. Widget yang saya pakai di proyek ini antara lain:
- MyApp memulai aplikasi dan mengembalikan MaterialApp, yang mengatur tema dan halaman awal.
- MyHomePage menyusun halaman utama. Scaffold menjadi kerangka halaman dan AppBar menampilkan judulnya.
- SafeArea memberi jarak dari area sistem. SingleChildScrollView membuat halaman bisa digulir.
- Center menaruh konten di tengah. ConstrainedBox membatasi lebar halaman dan memberi tinggi minimum pada kartu tombol.
- Row menyusun kartu profil ke samping, Expanded membagi lebarnya, dan Column menyusun isi kartu ke bawah. InfoCard memakai Card untuk tampilan kartu dan Text untuk label serta isinya.
- Padding memberi ruang di sekitar isi. SizedBox dipakai untuk memberi jarak dan menentukan lebar kartu tombol.
- LayoutBuilder membaca lebar yang tersedia. Saya memakai MediaQuery untuk membaca skala teks dan Wrap untuk memindahkan kartu ke baris berikutnya saat ruangnya kurang.
- ItemCard menyusun tombol aksi. Material memberi warna latar, Icon menampilkan simbol, dan InkWell menangani ketukan.
- SnackBar menampilkan pesan sementara lewat ScaffoldMessenger. Saya juga memakai Theme untuk mengambil warna AppBar dan gaya teks sambutan.

3. MaterialApp menyediakan pengaturan bersama seperti tema dan navigasi. Di proyek saya, home diisi dengan MyHomePage dan temanya dipakai, misalnya, untuk warna AppBar. Waktu saya perlu memberi warna berbeda pada ketiga tombol, saya menyimpan warnanya di masing-masing item. Dari situ saya jadi lebih paham bahwa tema bisa dipakai bersama, sementara tiap kartu juga bisa punya pengaturannya sendiri. MaterialApp biasanya ditaruh dekat bagian atas supaya widget halaman di bawahnya bisa memakai pengaturan yang sama. Dokumentasi MaterialApp

4. Saya pakai StatelessWidget ketika tampilan bisa dibentuk dari data yang diterima, seperti nama, ikon, dan warna pada ItemCard. Kartu ini bisa ditekan karena onTap meminta ScaffoldMessenger menampilkan pesan. Kartunya sendiri tidak perlu menyimpan perubahan data. StatelessWidget juga tetap bisa dibangun ulang, misalnya saat tema berubah.
Saya akan pakai StatefulWidget kalau ada nilai yang perlu disimpan dan berubah selama widget dipakai. Misalnya, kalau nanti ada form Tambah Proyek, saya bisa menyimpan status isSaving di objek State dan memakai setState() supaya tombol menampilkan “Menyimpan…” saat proses simpan berjalan.

5. BuildContext menunjukkan posisi widget di dalam widget tree. Di build(), posisi ini membantu Flutter mencari informasi dari widget yang ada di atasnya. Contohnya, saya pakai Theme.of(context) untuk mengambil tema halaman. Waktu memperbaiki kartu yang meluber, saya juga pakai MediaQuery.textScalerOf(context) untuk membaca skala teks. Nilai itu saya gunakan bersama lebar dari LayoutBuilder untuk menentukan berapa kartu yang muat per baris. Dokumentasi BuildContext

6. Hot reload berguna untuk perubahan tampilan seperti padding atau warna kartu. Flutter membangun ulang tampilan sambil mempertahankan state, tanpa menjalankan ulang main() dan initState(). Kalau saya mengubah logika awal di salah satu metode itu, saya perlu hot restart supaya bagian Flutter mulai lagi dengan state baru.
Kalau yang berubah adalah kode native Android, misalnya Kotlin, saya perlu full restart dengan menghentikan aplikasi dan menjalankannya lagi agar bagian Android ikut dibangun ulang. Waktu ada masalah SDK saat setup kemarin, yang perlu dicek juga hasil build Android setelah komponennya terpasang.

#### AI disclosure Tugas 7

Saya menggunakan OpenAI Codex untuk membantu memahami rubrik dan beberapa konsep Flutter yang masih baru buat saya. Saya minta penjelasan satu per satu, misalnya bagaimana setiap tombol bisa punya warna berbeda dan kenapa isi kartu meluber saat ukuran teks diperbesar. Saya lebih mudah mengerti kalau penjelasannya langsung memakai contoh dari menu.dart.

### Tugas 8

1. Navigator.push() menambahkan halaman baru ke atas halaman yang sedang dibuka, Navigator.pushReplacement() mengganti halaman aktif, dan Navigator.pop() menutup entri teratas. Di proyek saya, kartu Tambah Edukasi memakai push(), sehingga halaman utama masih ada di bawah formulir dan bisa dibuka kembali dengan tombol kembali. Saat memilih Home dari drawer, aplikasi menutup drawer terlebih dahulu. Kalau halaman utama masih ada, aplikasi kembali ke sana dengan popUntil(). Kalau formulir sudah menggantikan halaman utama saat dibuka lewat drawer, aplikasi menampilkan MyHomePage dengan pushReplacement(). Dari kedua alur ini, saya jadi lebih mudah memahami bahwa cara membuka halaman juga menentukan cara kembali.

2. Di Tugas 7, saya memakai Scaffold sebagai kerangka halaman utama. Pola yang sama saya pakai untuk formulir Edukasi. AppBar menampilkan judul dan tombol menu, sedangkan LeftDrawer menyediakan pilihan navigasi yang sama di kedua halaman. Contohnya, latar kedua AppBar memakai warna primary, sementara judul dan ikon memakai onPrimary dari tema aplikasi. Bagian ini membantu saya memahami bagaimana satu tema dan komponen yang dipakai bersama bisa menjaga tampilan tetap konsisten di beberapa halaman.

3. Saya memilih Column karena isian Edukasi lebih mudah diikuti dari atas ke bawah, mulai dari nama institusi hingga tahun pendidikan. Padding memberi jarak dari tepi layar dan SizedBox memberi jarak antarinput. Bagian yang paling terasa manfaatnya adalah SingleChildScrollView. Saat keyboard terbuka, ruang yang tersedia jadi lebih sedikit, tetapi pengguna masih bisa menggulir sampai tombol Simpan. Dari sini saya belajar bahwa menata formulir juga berarti memastikan setiap input dan tombolnya bisa dijangkau saat ukuran layar berubah.

4. GlobalKey<FormState> dipakai untuk mengakses state formulir ketika pengguna menekan Simpan. Setelah itu, validate() menjalankan validator pada setiap kolom yang tampil. Kalau ada nilai yang salah, pesannya muncul di kolom terkait dan ringkasan baru bisa tampil setelah semua isian valid. Contohnya, tahun selesai 2024 ditolak jika tahun masuknya 2025. Aturan ini pernah saya pakai pada Edukasi di Django, jadi saya lebih mudah memahami penerapannya di Flutter. Keyboard angka memang membantu saat mengisi tahun, tetapi urutan kedua tahun tetap harus diperiksa oleh validator.

#### Pengujian Tugas 8

- Buka **Tambah Edukasi** dari kartu dan **Add Education** dari drawer. Coba tombol kembali perangkat dari jalur kartu dan opsi **Home** dari halaman formulir saat memakai Chrome.
- Masukkan spasi untuk nama institusi atau tahun selesai sebelum tahun masuk, lalu tekan **Simpan**. Pesan kesalahan muncul pada kolom terkait.
- Setelah isian diperbaiki, **Simpan** membuka ringkasan semua isian. Tekan **Tutup** untuk kembali ke formulir dengan isian masih tersedia. Saat **Masih menempuh pendidikan** aktif, kolom tahun selesai tersembunyi dan ringkasan menampilkan **Belum selesai**.
- Ulangi pada layar sempit. Widget test mensimulasikan layar 320 piksel dan ruang papan ketik untuk memeriksa jangkauan tombol **Simpan**.

#### AI disclosure Tugas 8

Saya mengerjakan kode formulir, navigasi, dan widget test sendiri. Saya menggunakan OpenAI Codex hanya untuk menjelaskan dan memeriksa. Saya memintanya membantu memahami rubrik dan struktur proyek serta model Edukasi Django, menjelaskan bagian yang belum saya mengerti, dan memeriksa hasil kerja saya per poin checklisat sebelum saya commit. Commit dan push saya lakukan sendiri.

Keterbatasan dan perbaikan

Saat menempelkan draf awal, saya sempat menyimpan formulir langsung di lib/, lalu melihat error import di editor. Setelah saya laporkan, Codex membantu mengidentifikasi penyebabnya. Saya sendiri yang memindahkan formulir ke lib/screens/ dan memulihkan konfigurasi paket Flutter. Saat audit, Codex membantu menemukan salinan duplikat yang tersisa, dan saya menghapusnya sebelum commit navigasi. Kode saya periksa dengan flutter analyze dan widget test di Flutter serta Chrome, dan Codex membantu meninjau hasilnya. Pengujian papan ketik memakai simulasi ukuran layar dan ruang papan ketik.
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

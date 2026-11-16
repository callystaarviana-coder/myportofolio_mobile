# myportofolio_mobile

# MyPortfolio Mobile

MyPortfolio Mobile adalah aplikasi Flutter untuk portofolio pribadi PBP. Halaman utamanya menampilkan identitas pemilik dan tiga tombol aksi dengan warna berbeda. Setiap tombol menampilkan pesan saat ditekan.

## Setup

Siapkan Flutter SDK dan emulator atau perangkat Android yang terhubung. Dari root proyek, jalankan:

```bash
flutter pub get
flutter run
```

Untuk mengecek kode dan menjalankan tes:

```bash
flutter analyze
flutter test
```

## Progres

- **Tutorial 08** — Menyiapkan proyek Flutter dan memisahkan halaman utama ke `lib/menu.dart`.
- **Tugas 7** — Menyesuaikan kartu profil, memberi warna berbeda pada tombol, dan memperbaiki layout saat ukuran teks diperbesar.

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

## AI disclosure 
Saya menggunakan OpenAI Codex untuk membantu memahami rubrik dan beberapa konsep Flutter yang masih baru buat saya. Saya minta penjelasan satu per satu, misalnya bagaimana setiap tombol bisa punya warna berbeda dan kenapa isi kartu meluber saat ukuran teks diperbesar. Saya lebih mudah mengerti kalau penjelasannya langsung memakai contoh dari menu.dart.



## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

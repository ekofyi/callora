# Callora iOS

Fondasi aplikasi identifikasi dan pemblokiran panggilan iOS, dibuat dengan SwiftUI dan Call Directory Extension. Navigasi utama terdiri dari Home, Protection, Premium, dan Menu. Pencarian nomor tersedia di Home; pengaturan Caller ID dan impor database tersedia di Menu.

## Menjalankan

1. Instal Xcode. Berkas `Callora.xcodeproj` sudah tersedia. XcodeGen (`brew install xcodegen`) hanya diperlukan bila mengubah `project.yml` lalu ingin membuat ulang proyek dengan `xcodegen generate`.
2. Buka `Callora.xcodeproj` di Xcode.
3. Pilih Apple Development Team untuk target **Callora** dan **CallDirectory**. Ganti bundle identifier serta App Group pada `project.yml`, kedua berkas `.entitlements`, dan `Callora/Shared/DirectoryData.swift` bila `com.callora.app` tidak tersedia di tim Anda.
4. Jalankan di iPhone, lalu aktifkan Callora di Pengaturan > Telepon > Pemblokiran & Identifikasi Panggilan (atau Pengaturan > Apps > Telepon pada versi iOS tertentu).

Pengujian identifikasi panggilan memerlukan iPhone dengan Call Directory diaktifkan.

## Data nomor

Pada Menu > Caller ID & database > Impor database, pilih berkas JSON dengan format berikut:

```json
[
  {
    "number": "+628123456789",
    "name": "Contoh Bisnis",
    "category": "Bisnis",
    "reports": 0,
    "isSpam": false
  }
]
```

Nomor harus dalam format E.164 (`+` diikuti kode negara dan nomor; panjang maksimal 15 digit). Entri yang tidak valid diabaikan. Impor berikutnya memperbarui nomor yang sama. Database dan aturan blokir tersimpan di App Group lokal; belum ada layanan server atau data identitas global. Pencarian hanya mengenali nomor yang telah diimpor.

Call Directory menerima daftar nomor lengkap yang terurut. Aturan prefix memblokir **nomor lengkap dalam database lokal** yang cocok dengan prefix tersebut; iOS tidak mendukung pencocokan prefix arbitrer saat telepon masuk. Nomor yang ditambahkan satu per satu diblokir meskipun tidak ada dalam database. Perubahan daftar dikirim ke extension lewat reload Call Directory.

Riwayat panggilan iPhone tidak tersedia bagi aplikasi pihak ketiga, sehingga halaman Recent calls menampilkan keadaan kosong. Family group, laporan panggilan, dan pembelian Premium belum tersedia; halaman terkait menampilkan informasi fitur tanpa mengklaimnya sudah aktif.

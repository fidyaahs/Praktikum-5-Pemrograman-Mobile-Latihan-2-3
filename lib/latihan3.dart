import 'package:flutter/material.dart'; // Import library Flutter untuk membuat UI
import 'package:http/http.dart' as http; // Import library http untuk mengirim permintaan HTTP
import 'dart:convert'; // Import library untuk mengonversi data JSON

void main() {
  runApp(const MyApp()); // Fungsi utama yang menjalankan aplikasi Flutter
}

class University {
  final String name; // Variabel untuk menyimpan nama universitas
  final String website; // Variabel untuk menyimpan situs web universitas

  University({required this.name, required this.website}); // Konstruktor untuk inisialisasi objek University

  factory University.fromJson(Map<String, dynamic> json) {
    // Factory method untuk membuat objek University dari data JSON
    return University(
      name: json['name'], // Ambil nama universitas dari data JSON
      website: json['web_pages'][0], // Ambil situs web pertama universitas dari data JSON
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState(); // Membuat instance dari _MyAppState
  }
}

class _MyAppState extends State<MyApp> {
  late Future<List<University>> futureUniversities; // Variabel untuk menampung hasil pemanggilan API

  @override
  void initState() {
    super.initState();
    futureUniversities = fetchUniversities(); // Memanggil method fetchUniversities saat aplikasi pertama kali dijalankan
  }

  Future<List<University>> fetchUniversities() async {
    final response = await http.get(Uri.parse(
        'http://universities.hipolabs.com/search?country=Indonesia')); // Mengirim permintaan HTTP untuk mendapatkan data universitas dari API

    if (response.statusCode == 200) {
      // Jika permintaan berhasil
      List<dynamic> data = jsonDecode(response.body); // Mendekode data JSON
      return data.map((json) => University.fromJson(json)).toList(); // Mengonversi data JSON menjadi daftar objek University
    } else {
      throw Exception('Failed to load universities'); // Jika permintaan gagal, lempar exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey, // Warna primer aplikasi
        dividerColor: Colors.grey, // Warna garis pemisah
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Indonesian Universities', // Judul aplikasi
            style: TextStyle(fontWeight: FontWeight.bold), // Judul teks bold
          ),
          centerTitle: true, // Pusatkan judul
        ),
        body: Center(
          child: FutureBuilder<List<University>>(
            future: futureUniversities, // Menampilkan daftar universitas yang didapat dari futureUniversities
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika data tersedia
                return ListView.builder(
                  itemCount: snapshot.data!.length, // Jumlah item dalam ListView
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3, // Efek bayangan kartu
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Margin kartu
                      child: ListTile(
                        title: Text(
                          snapshot.data![index].name, // Tampilkan nama universitas
                          style: TextStyle(fontWeight: FontWeight.bold), // Teks nama universitas bold
                        ),
                        subtitle: Text(snapshot.data![index].website), // Tampilkan situs web universitas
                        onTap: () {
                          // Aksi ketika ListTile diklik
                          // Misalnya, buka situs web universitas
                          // Bisa tambahkan fungsi navigasi atau fungsi lainnya di sini
                        },
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // Jika terjadi kesalahan
                return Text('${snapshot.error}'); // Tampilkan pesan kesalahan
              }

              return CircularProgressIndicator(); // Tampilkan indikator loading saat data masih dimuat
            },
          ),
        ),
      ),
    );
  }
}

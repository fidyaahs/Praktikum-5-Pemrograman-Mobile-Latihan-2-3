import 'package:flutter/material.dart'; // Impor pustaka flutter untuk pengembangan UI
import 'package:http/http.dart' as http; // Impor pustaka http untuk melakukan permintaan HTTP
import 'dart:convert'; // Impor pustaka dart:convert untuk mengonversi JSON

void main() {
  runApp(const MyApp()); // Panggil fungsi runApp untuk menjalankan aplikasi
}

// Kelas untuk menampung data aktivitas dari API
class Activity {
  String aktivitas; // Attribut untuk menampung aktivitas
  String jenis; // Attribut untuk menampung jenis aktivitas

  Activity({required this.aktivitas, required this.jenis}); // Konstruktor

  // Metode untuk mengonversi data JSON ke atribut objek
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Mengembalikan objek MyAppState
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; // Variabel untuk menampung hasil aktivitas yang akan datang
  String url = "https://www.boredapi.com/api/activity"; // URL endpoint API

  // Metode untuk menginisialisasi Future Activity
  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: ""); // Mengembalikan objek Activity kosong
  }

  // Metode untuk melakukan permintaan HTTP dan mendapatkan data aktivitas
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url)); // Permintaan GET ke URL
    if (response.statusCode == 200) {
      // Jika permintaan berhasil
      // Parse data JSON dan konversi ke objek Activity
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika permintaan gagal, lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Inisialisasi futureActivity dengan Activity kosong saat initState dipanggil
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData(); // Ketika tombol ditekan, perbarui futureActivity dengan hasil aktivitas baru
                });
              },
              child: Text("Saya bosan ..."), // Teks pada tombol
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity, // Future yang akan dibangun
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika snapshot memiliki data
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas), // Tampilkan aktivitas
                      Text("Jenis: ${snapshot.data!.jenis}") // Tampilkan jenis aktivitas
                    ]));
              } else if (snapshot.hasError) {
                // Jika terjadi kesalahan
                return Text('${snapshot.error}'); // Tampilkan pesan kesalahan
              }
              // Default: tampilkan spinner loading.
              return const CircularProgressIndicator(); // Tampilkan spinner loading saat data sedang dimuat
            },
          ),
        ]),
      ),
    ));
  }
}

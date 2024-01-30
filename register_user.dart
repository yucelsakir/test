import 'package:flutter/material.dart';
import 'models/register_model.dart'; // Bu satırı ekledim
import 'package:http/http.dart' as http; // Bu satırı ekledim
import 'dart:convert'; // JSON verilerini işlemek için

const String apiUrl = 'http://localhost:3000'; // Bu satırı ekledim

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key, required String title});

  @override
  RegisterUserState createState() => RegisterUserState();
}

class RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String adi = '';
  String soyadi = '';
  String eposta = '';
  String kullanici_adi = '';
  String sifre = '';

  Future save() async {
    // MSSQL API'nin kullanıcı ekleme URL'sini oluştur
    final Uri url =
        Uri.parse('$apiUrl/kullanici_ekle'); // Bu satırı değiştirdim

    // POST isteği için verileri hazırla
    final Map<String, String> data = {
      'adi': adi,
      'soyadi': soyadi,
      'eposta': eposta,
      'kullanici_adi': kullanici_adi, // Bu satırı değiştirdim
      'sifre': sifre,
    };

    // POST isteğini gönder
    final response = await http.post(url, body: data); // Bu satırı değiştirdim

    // Yanıtı kontrol et
    if (response.statusCode == 200) {
      // Yanıt başarılı ise, kullanıcı verilerini al
      final user = RegisterModel.fromJson(
          jsonDecode(response.body)); // Bu satırı değiştirdim
      print('Kullanıcı kaydı başarılı: ${user.toJson()}');
    } else {
      // Yanıt başarısız ise, hata mesajı göster
      print('Kullanıcı kaydı başarısız: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
          style: ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.green),
          ),
        ),
        //title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 26, 34, 38),
        shadowColor: Colors.white,
        title: const Center(
          child: Text(
            "Mobil Atık Randevu Sistemi",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(
                16.0), // Form widget'ına kenarlardan boşluk ver
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Expanded(
                  child: Image(
                    image: AssetImage("lib/images/atik.jpg"),
                    fit: BoxFit.scaleDown,
                    width: 380,
                    height: 380,
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: TextFormField(
                    // Adı soyadı widget'ının kontrolcüsünü ver
                    decoration: const InputDecoration(
                      labelText: 'Adı', // Adı soyadı widget'ının etiketini ver
                      border:
                          OutlineInputBorder(), // Adı soyadı widget'ının kenarlığını ver
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen adınızı giriniz';
                      }
                    },
                    onSaved: (value) {
                      adi = value!;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText:
                          'Soyadı', // Adı soyadı widget'ının etiketini ver
                      border:
                          OutlineInputBorder(), // Adı soyadı widget'ının kenarlığını ver
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen soyadınızı giriniz';
                      }
                    },
                    onSaved: (value) {
                      soyadi = value!;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Eposta',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen e-posta adresinizi giriniz';
                      }
                    },
                    onSaved: (value) {
                      eposta = value!;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen kullanıcı adınızı giriniz';
                      }
                    },
                    onSaved: (value) {
                      kullanici_adi = value!;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true, // Şifre widget'ının değerini gizle
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen şifrenizi girin';
                      }
                      if (value.length < 6) {
                        return 'Lütfen en az 6 karakterlik bir şifre girin';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      sifre = value!;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                    child: ElevatedButton(
                  child: const Text('Kaydet'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      save();
                    }
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

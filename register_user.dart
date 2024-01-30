import 'package:flutter/material.dart';
import 'models/register_model.dart'; // Bu satırı ekledim
import 'package:http/http.dart' as http; // Bu satırı ekledim
import 'dart:convert'; // JSON verilerini işlemek için

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _KayitEkraniState createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  final _formKey = GlobalKey<FormState>();
  final _nameController =
      TextEditingController(); // Adı soyadı widget'ının kontrolcüsü
  final _emailController =
      TextEditingController(); // Eposta widget'ının kontrolcüsü
  final _usernameController =
      TextEditingController(); // Kullanıcı adı widget'ının kontrolcüsü
  final _passwordController =
      TextEditingController(); // Şifre widget'ının kontrolcüsü

  String? name; // Adı soyadı değeri
  String? email; // Eposta değeri
  String? username; // Kullanıcı adı değeri
  String? password; // Şifre değeri

  @override
  void dispose() {
    // Widget'ların kontrolcülerini temizle
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    controller:
                        _nameController, // Adı soyadı widget'ının kontrolcüsünü ver
                    decoration: const InputDecoration(
                      labelText: 'Adı', // Adı soyadı widget'ının etiketini ver
                      border:
                          OutlineInputBorder(), // Adı soyadı widget'ının kenarlığını ver
                    ),
                    validator: (value) {
                      // Adı soyadı widget'ının doğrulayıcısını ver
                      if (value == null || value.isEmpty) {
                        // Eğer değer boşsa
                        return 'Lütfen adınızı girin'; // Hata mesajı döndür
                      }
                      return null; // Değer geçerliyse null döndür
                    },
                    onSaved: (value) {
                      // Adı soyadı widget'ının kaydedicisi
                      name = value; // Değeri name değişkenine ata
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: TextFormField(
                    controller:
                        _nameController, // Adı soyadı widget'ının kontrolcüsünü ver
                    decoration: const InputDecoration(
                      labelText:
                          'Soyadı', // Adı soyadı widget'ının etiketini ver
                      border:
                          OutlineInputBorder(), // Adı soyadı widget'ının kenarlığını ver
                    ),
                    validator: (value) {
                      // Adı soyadı widget'ının doğrulayıcısını ver
                      if (value == null || value.isEmpty) {
                        // Eğer değer boşsa
                        return 'Lütfen soyadınızı girin'; // Hata mesajı döndür
                      }
                      return null; // Değer geçerliyse null döndür
                    },
                    onSaved: (value) {
                      // Adı soyadı widget'ının kaydedicisi
                      name = value; // Değeri name değişkenine ata
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Eposta',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen eposta adresinizi girin';
                      }
                      if (!value.contains('@')) {
                        return 'Lütfen geçerli bir eposta adresi girin';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen kullanıcı adınızı girin';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      username = value;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: _passwordController,
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
                      password = value;
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
              )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


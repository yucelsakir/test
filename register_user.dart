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
      'kullanici_adi': kullanici_adi,
      'sifre': sifre,
    };

    // POST isteğini gönder
    final response = await http.post(url, body: data); // Bu satırı değiştirdim

    // Yanıtı kontrol et
    if (response.statusCode == 200) {
      // Yanıt başarılı ise, kullanıcı verilerini al
      final user = KullaniciEkle.fromJson(
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
        title: const Text('Kullanıcı Kaydı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(hintText: 'Adı'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen adınızı giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  adi = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Soyadı'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen soyadınızı giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  soyadi = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'E-posta'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen e-posta adresinizi giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  eposta = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Kullanıcı Adı'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen kullanıcı adınızı giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  kullanici_adi = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Şifre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen şifrenizi giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  sifre = value!;
                },
              ),
              ElevatedButton(
                child: const Text('Kaydet'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    save();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

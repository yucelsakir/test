import 'package:flutter/material.dart';
import 'package:my_app/models/register_model.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert'; 

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
  String kullaniciAdi = '';
  String sifre = '';

  Future save() async {
    final Uri url = Uri.parse('http://localhost:3000/kullanici_ekle');

    final Map<String, String> data = {
      'adi': adi,
      'soyadi': soyadi,
      'eposta': eposta,
      'kullaniciAdi': kullaniciAdi,
      'sifre': sifre,
    };

    final response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      final user = RegisterModel.fromJson(jsonDecode(response.body));
      print('Kullanıcı kaydı başarılı: ${user.toJson()}');
    } else {
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
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                Image(
                  image: AssetImage("lib/images/atik.jpg"),
                  fit: BoxFit.scaleDown,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Adı',
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Soyadı',
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 16.0),
                TextFormField(
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
                const SizedBox(height: 16.0),
                TextFormField(
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
                    kullaniciAdi = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
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
                const SizedBox(height: 16.0),
                ElevatedButton(
                  child: const Text('Kaydet'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      save();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

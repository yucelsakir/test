import 'home_page.dart';
import 'register_user.dart';
import 'password_reset.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // JSON verilerini işlemek için
import 'package:http/http.dart' as http; // API istekleri yapmak için
import 'models/user_model.dart'; // User sınıfını içe aktar

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordInVisible = true;
  final _inputDecoration = const InputDecoration(
    filled: true,
    fillColor: Colors.transparent,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    labelText: "Kullanıcı Adı",
    labelStyle: TextStyle(color: Colors.black),
    border: OutlineInputBorder(),
  );
  //static const _errorMessage = "Giriş Bilgileriniz Hatalı";
  // Giriş sayfasının görünümünü belirleyen metod
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      resizeToAvoidBottomInset: false,
      // Scaffold widget'ının appBar özelliğine AppBar widget'ını ver
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 26, 34, 38),
        // AppBar widget'ının title özelliğine Text widget'ını ver
        title: const Center(
          child: Text(
            "Mobil Atık Randevu Sistemi",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
      ),
      // Scaffold widget'ının body özelliğine Form widget'ını ver
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Image widget'ını Expanded widget'ı ile sarmala
              const Expanded(
                child: Image(
                  image: AssetImage("lib/images/atik.jpg"),
                  fit: BoxFit.scaleDown,
                  width: 400,
                  height: 400,
                ),
              ),
              const Expanded(
                child: Text(
                  "Merhaba, MARS'a Hoşgeldin",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 11.0),
              // TextFormField widget'ını Expanded widget'ı ile sarmala
              Expanded(
                child: TextFormField(
                  decoration: _inputDecoration.copyWith(
                    // Arka plan rengini siyah yap
                    filled: true,
                    labelText: "Kullanıcı Adı",
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                  cursorColor: Colors.yellow,
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Kullanıcı Adını Giriniz";
                    } else {
                      return null;
                    }
                  },
                  // Giriş alanının değerini username değişkenine kaydet
                  controller: _usernameController,
                ),
              ),
              const SizedBox(height: 10.0),
              // TextFormField widget'ını Expanded widget'ı ile sarmala
              Expanded(
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  obscureText: _passwordInVisible,
                  decoration: _inputDecoration.copyWith(
                    filled: true,
                    labelText: "Şifre",
                    labelStyle:
                        const TextStyle(fontSize: 16, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordInVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      color: Colors.blueGrey.withOpacity(0.7),
                      onPressed: () {
                        setState(() {
                          _passwordInVisible = !_passwordInVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Şifrenizi Giriniz";
                    } else {
                      return null;
                    }
                  },
                  // Giriş alanının değerini password değişkenine kaydet
                  controller: _passwordController,
                  cursorColor: Colors.yellow,
                ),
              ),
              const SizedBox(height: 20.0),

              const SizedBox(height: 35.0),
              //-----------------------------Giriş yap butonu
              _loginButton(),
              const SizedBox(height: 5.0),
              // RichText widget'ını Expanded widget'ı ile sarmala
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: "Hesabınız yok mu?",
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: " Kayıt Ol",
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const KayitEkrani(
                                  title: '',
                                ),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              // RichText widget'ını Expanded widget'ı ile sarmala
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: "Şifrenizi mi unuttunuz?",
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: " Şifre Sıfırla",
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SifremiUnuttum(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Giriş yapma butonu oluşturan fonksiyon
  Widget _loginButton() {
    return ElevatedButton(
      onPressed: () {
        // Giriş yapma kodunu ayrı bir fonksiyon olarak tanımladım
        _login();
      },
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 12)),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          'Giriş Yap',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  // Giriş yapma fonksiyonu
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Kullanıcı verilerini doğrula ve giriş yap
      final username = _usernameController.text;
      final password = _passwordController.text;
      final response = await http.post(
        // API isteği yap
        Uri.parse('http://localhost:3000/kullanicigetir'), // API'nizin URL'si
        body: jsonEncode({
          // JSON verisini gönder
          'username': username,
          'password': password,
        }),
      );

      final result = User.fromJson(
          jsonDecode(response.body)); // JSON verisini User sınıfına dönüştür
      if (result.kullaniciAdi == username && result.sifre == password) {
        // Giriş başarılı, yönlendirme yap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnaMenu()),
        );
      } else {
        // Giriş başarısız, hata mesajı göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kullanıcı adı veya şifre yanlış'),
          ),
        );
      }
    }
  }
}

class User {
  static fromJson(jsonDecode) {}
}

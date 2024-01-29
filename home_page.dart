import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AnaMenu extends StatefulWidget {
  const AnaMenu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _anaMenuState createState() => _anaMenuState();
}

// ignore: camel_case_types
class _anaMenuState extends State<AnaMenu> {
  List<CollapsibleItem>? _items;
  List<String>? iller;
  List<String>? ilceler;
  Widget? _headline; // Headline kısmının tipini Widget olarak değiştir

  /*
    internetten resim çekmek için kullanacağım.
    final NetworkImage _avatarImage = const NetworkImage(
      'https://www.mertoglu.com.tr/UserFiles/articlefiles/orta/sifir-atik-projesi-geri-donusum339211.jpg');
  */
  final AssetImage _avatarImage = const AssetImage("lib/images/mars.JPG");

  // Formun durumunu kontrol etmek için bir anahtar tanımladım
  final _formKey = GlobalKey<FormState>();

  // Form alanlarından alınacak değerleri tutacak değişkenleri tanımladım
  String adi = 'Deneme';
  String soyadi = '';
  String telefon = '';
  String il = '';
  String ilce = '';
  String adres = '';
  String email = '';

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'Anasayfa',
        icon: Icons.home,
        onPressed: () => setState(
                () => _headline = const Form(child: Text('Açılış ekranı'))),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'Bilgilerim',
        icon: Icons.person,
        onPressed: () => setState(() => _headline = Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 122,
                    child: Center(
                      child: Text(
                        '  ADINIZ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 50.0, right: 5.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'veritabanından çekilecek',
                          labelStyle:
                          TextStyle(fontSize: 16, color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromARGB(255, 148, 161, 152),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Adınızı giriniz';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          adi = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              // Soyadı bilgisinin girilebileceği bir textformfield ekle
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 122,
                    child: Center(
                      child: Text(
                        '  SOYADINIZ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 50.0, right: 5.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'veritabanından çekilecek',
                          labelStyle:
                          TextStyle(fontSize: 16, color: Colors.white),
                          filled: true,
                          fillColor: Color.fromARGB(255, 148, 161, 152),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Soyadınızı giriniz';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          soyadi = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 122,
                    child: Center(
                      child: Text(
                        '  TELEFON',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 50.0, right: 5.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'veritabanından çekilecek',
                          labelStyle:
                          TextStyle(fontSize: 16, color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromARGB(255, 148, 161, 152),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Telefon numaranızı giriniz';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          telefon = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 122,
                    child: Center(
                      child: Text(
                        '  İLİNİZ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 50.0, right: 5.0),
                      // TextFormField widget'ını kaldırın
                      // DropdownButton widget'ını ekleyin
                      child: DropdownButton<String>(
                        // Seçilen ilin adını value parametresine verin
                        value: il,
                        // Veri tabanından gelen iller listesini items parametresine verin
                        items: iller
                            ?.map((String il) => DropdownMenuItem<String>(
                          value: 'seçiniz',
                          child: Text(il),
                        ))
                            .toList(),
                        // Seçilen il değiştiğinde, il değişkenine atama yapın
                        onChanged: (value) {
                          setState(() {
                            il = value!;
                          });
                        },
                        hint: const Text('Seçiniz'),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 122,
                    child: Center(
                      child: Text(
                        '  İLÇENİZ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 50.0, right: 5.0),
                      // TextFormField widget'ını kaldırın
                      // DropdownButton widget'ını ekleyin
                      child: DropdownButton<String>(
                        // Seçilen ilin adını value parametresine verin
                        value: il,
                        // Veri tabanından gelen iller listesini items parametresine verin
                        items: ilceler
                            ?.map((String ilce) => DropdownMenuItem<String>(
                          value: 'seçiniz',
                          child: Text(ilce),
                        ))
                            .toList(),
                        // Seçilen il değiştiğinde, il değişkenine atama yapın
                        onChanged: (value) {
                          setState(() {
                            il = value!;
                          });
                        },
                        hint: const Text('Seçiniz'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 122,
                    child: Center(
                      child: Text(
                        '  ADRESİNİZ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 50.0, right: 5.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'veritabanından çekilecek',
                          labelStyle:
                          TextStyle(fontSize: 16, color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromARGB(255, 148, 161, 152),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Adresinizi giriniz';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          adres = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 122,
                    child: Center(
                      child: Text(
                        '  E-POSTA',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 50.0, right: 5.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'veritabanından çekilecek',
                          labelStyle:
                          TextStyle(fontSize: 16, color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color.fromARGB(255, 148, 161, 152),
                        ),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email adresinizi giriniz';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          email = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              // "Güncelle" butonunu ekle
              ElevatedButton(
                child: const Text('Güncelle'),
                onPressed: () {
                  // Formun durumunu kontrol et
                  if (_formKey.currentState!.validate()) {
                    // Formun değerlerini kaydet
                    _formKey.currentState!.save();
                    // Bilgileri güncellediğine dair bir mesaj göster
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bilgileriniz güncellendi'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        )),
      ),
      CollapsibleItem(
        text: 'Taleplerim',
        icon: Icons.add,
        onPressed: () => setState(
              () => _headline = Form(
            key: _formKey,
            child: const Column(
              children: [
                Text(
                    'Talepler burada görünecek ve yeni talep oluştur butonu olacak'),
              ],
            ),
          ),
        ),
      ),
      CollapsibleItem(
        text: 'Duyurular',
        icon: Icons.announcement,
        onPressed: () => setState(() =>
        _headline = const Form(child: Text('Duyurular ekranı olacak'))),
      ),
      CollapsibleItem(
          text: 'Çıkış Yap',
          icon: Icons.logout_outlined,
          onPressed: () => Navigator.pop(context)),
    ];
  }

  @override
  void initState() {
    super.initState();

    getUser();
    getKullanici();
    _items = _generateItems;
    _headline = Text(_items!
        .firstWhere((element) => element.isSelected)
        .text); // Headline kısmının başlangıç değerini Text widget'ı olarak ayarla
  }

  Future<void> getUser() async {
    // telefonun SharedPreferences kısmına kaydedilmiş veri çekilecek
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      adi = sharedPreferences.getString('kullaniciadi') ?? '';
    });
  }

  Future<void> getKullanici() async {
    // APı kullanarak DB den kullanıcı verisi çekilecke

    try {
      var request = http.Request(
          'GET', Uri.parse('http://localhost:3000/kullanicigetir'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // ignore: avoid_print
        print(await response.stream.bytesToString());
      } else {
        // ignore: avoid_print
        print(response.reasonPhrase);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: CollapsibleSidebar(
          backgroundColor: const Color.fromARGB(255, 40, 45, 41),
          items: _items!,
          avatarImg: _avatarImage,
          title: adi, //'Şakir YÜCEL',
          body: Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromARGB(255, 104, 109, 107),
            child: Center(
              child: _headline!, // Headline kısmını burada göster
            ),
          ),
        ),
      ),
    );
  }
}

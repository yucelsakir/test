import 'dart:convert';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_model.dart';
import 'models/il_ilce_models.dart';

class AnaMenu extends StatefulWidget {
  const AnaMenu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _anaMenuState createState() => _anaMenuState();
}

String baseUrl = 'http://localhost:3000/';

// ignore: camel_case_types
class _anaMenuState extends State<AnaMenu> {
  List<CollapsibleItem>? _items;
  List<String>? iller;
  List<String>? ilceler;
  Widget? _headline;

  final _userAdController = TextEditingController();
  final _userSoyadController = TextEditingController();
  final _userTelController = TextEditingController();
  final _userAdresController = TextEditingController();
  final _userEpostaController = TextEditingController();
  // int? _selectedIlce; // Seçili ilçe id'sini tutan bir değişken
  int _selectedIl = 0;
  int _selectedIlce = 0;

  late SharedPreferences prefs;
  /*
    internetten resim çekmek için kullanacağım.
    final NetworkImage _avatarImage = const NetworkImage(
      'https://www.mertoglu.com.tr/UserFiles/articlefiles/orta/sifir-atik-projesi-geri-donusum339211.jpg');
  */
  final AssetImage _avatarImage = const AssetImage("lib/images/mars.JPG");

  // Formun durumunu kontrol etmek için bir anahtar tanımladım
  final _formKey = GlobalKey<FormState>();

  // Form alanlarından alınacak değerleri tutacak değişkenleri tanımladım
  String adi = '';
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
            // Açılış ekranında kullanıcının id'sini göstermek için FutureBuilder widget'ını kullan
            () => _headline = FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      SharedPreferences prefs =
                          snapshot.data as SharedPreferences;
                      int userId = prefs.get('user_id') as int;
                      // id'yi al veya başarısız ise 0 döndür
                      //int userId = prefs.get('user_id') as int ?? 0;

                      return Text(
                          'Kullanıcı id: $userId'); // id'yi ekrana yazdır
                    } else {
                      return const CircularProgressIndicator(); // veri yüklenene kadar dönen çember göster
                    }
                  },
                )),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'Bilgilerim',
        icon: Icons.person,
        onPressed: () async {
          // onPressed özelliğine bir asenkron fonksiyon tanımla
          // kullanıcının id'sini shared_preferences paketinden al
          SharedPreferences prefs = await SharedPreferences.getInstance();
          int userId = prefs.get('user_id') as int;

          // veritabanından kullanıcı bilgilerini çek
          Kullanici? user = await getUserFromDB(userId);

          // _headline widget'ını form olarak güncelle
          setState(() => _headline = Form(
              key: _formKey,
              child: SingleChildScrollView(
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
                              controller:
                                  TextEditingController(text: user?.adi ?? ''),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
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
                              controller: TextEditingController(
                                  text: user?.soyadi ?? ''),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
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
                              controller: TextEditingController(
                                  text: user?.telefon ?? ''),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
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
                          // Child parametresine Padding widgetını verin
                          child: Padding(
                            // Padding parametresine EdgeInsets.only(left: 50, right: 5) verin
                            padding: const EdgeInsets.only(left: 50, right: 5),
                            // Child parametresine FutureBuilder widgetını verin
                            child: FutureBuilder<List<Iller>>(
                              // Future parametresine getIller fonksiyonunu verin
                              future: getIller(),
                              // Builder parametresine bir fonksiyon verin
                              builder: (context, snapshot) {
                                // Eğer snapshot parametresinin verisi varsa
                                if (snapshot.hasData) {
                                  // Veriyi DropdownButton widgetına dönüştürün
                                  return DropdownButton<int?>(
                                    // Widgetın değerini null olarak belirleyin
                                    value: null,
                                    items: snapshot.data!.map((iller) {
                                      return DropdownMenuItem(
                                        value: iller.sehirid,
                                        child: Text(iller.sehiradi!),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedIl = value!;
                                      });
                                    },
                                    // hint parametresini 'Seçiniz' olarak belirtin
                                    hint: const Text('Seçiniz'),
                                  );

                                  // Eğer snapshot parametresinin verisi yoksa
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Bir hata oluştu: ${snapshot.error}');
                                } else {
                                  // Eğer Future değer henüz dönmediyse, CircularProgressIndicator widgetını döndür
                                  return const CircularProgressIndicator();
                                }
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
                            padding: const EdgeInsets.only(left: 50, right: 5),
                            child: FutureBuilder<List<Ilceler>>(
                              // Future parametresine getIlceler fonksiyonunu seçili ilin id'si ile verin
                              future: getIlceler(_selectedIl),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return DropdownButton<int>(
                                    // Value parametresine _selectedIlce değişkenini verin
                                    value: _selectedIlce,
                                    // Items parametresinde seçili ile göre ilçeleri filtreleyin
                                    items: snapshot.data!
                                        .where((ilce) =>
                                            ilce.sehirid == _selectedIl)
                                        .map((ilce) {
                                      return DropdownMenuItem(
                                        value: ilce.ilceid,
                                        child: Text(ilce.ilceadi!),
                                      );
                                    }).toList(),
                                    // OnChanged fonksiyonunda _selectedIlce değişkenini güncelleyin
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedIlce = value!;
                                      });
                                    },
                                    hint: const Text('Seçiniz'),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Bir hata oluştu: ${snapshot.error}');
                                } else {
                                  // Eğer Future değer henüz dönmediyse, CircularProgressIndicator widgetını döndür
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ),
                        ),
                        // Diğer widgetlarınızı buraya ekleyebilirsiniz
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
                              controller: TextEditingController(
                                  text: user?.adres ?? ''),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
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
                              controller: TextEditingController(
                                  text: user?.eposta ?? ''),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
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
              )));
        },
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
    // SharedPreferences nesnesini oluştur
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      getUser();
      // Burada kullanıcının il id'sini alıp _selectedIl değişkenine ata
      setState(() {
        _selectedIl = prefs.getInt('sehirid') ?? 0;
      });
    });
    _items = _generateItems;
    _headline = Text(_items!
        .firstWhere((element) => element.isSelected)
        .text); // Headline kısmının başlangıç değerini Text widget'ı olarak ayarla
  }

// Bu fonksiyon, veritabanından iller listesini çeker ve Future olarak döndürür
  Future<List<Iller>> getIller() async {
    // API isteği yapmak için http paketini kullanın
    final response = await http.get(Uri.parse('http://localhost:3000/iller'));
    // Gelen JSON verisini ayrıştırın
    final jsonData = json.decode(response.body);
    // Liste olarak döndürün
    return List.generate(jsonData.length, (i) {
      return Iller.fromJson(jsonData[i]);
    });
  }

  Future<List<Ilceler>> getIlceler(int? ilId) async {
    // API isteği yaparak ilçeler verisini çek
    // Eğer il id'si null ise, tüm ilçeleri getir
    // Eğer il id'si null değilse, ilgili ilçeleri getir
    final response = await http.get(Uri.parse(
        'http://localhost:3000/ilceler${ilId == null ? '' : '?sehirid=$ilId'}'));
    // Liste olarak döndür
    final jsonData = json.decode(response.body);
    return List.generate(jsonData.length, (i) {
      // Her JSON elemanını Ilceler nesnesine dönüştür
      return Ilceler.fromJson(jsonData[i]);
    });
  }

  Future<void> getUser() async {
    // telefonun SharedPreferences kısmına kaydedilmiş veri çekilecek
    int userId = prefs.get('user_id') as int; // Kullanıcının id'sini al
    Kullanici? user =
        await getUserFromDB(userId); // Veritabanından kullanıcı bilgilerini al
    setState(() {
      // Controller nesnelerinin text özelliklerini güncelle
      _userAdController.text = user?.adi ?? '';
      _userSoyadController.text = user?.soyadi ?? '';
      _userAdresController.text = user?.adres ?? '';
      _userEpostaController.text = user?.eposta ?? '';
      _userTelController.text = user?.telefon ?? '';
    });
  }

  // veritabanından kullanıcı bilgilerini çekmek için bir fonksiyon
  Future<Kullanici?> getUserFromDB(int id) async {
    // burada geri dönüş tipini Future<Kullanici?> olarak tanımlamalısınız
    // veritabanının URL'sine HTTP isteği gönder
    final response =
        await http.get(Uri.parse('http://localhost:3000/kullanici_getir/$id'));

    // eğer istek başarılı ise
    if (response.statusCode == 200) {
      // JSON verisini model nesnesine dönüştür
      Kullanici user = Kullanici.fromJson(jsonDecode(response.body));
      // model nesnesini geri döndür
      return user;
    } else {
      // eğer istek başarısız ise
      // hata mesajı göster
      // ignore: avoid_print
      print('Veritabanından veri çekilemedi');
      // null döndür
      return null;
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

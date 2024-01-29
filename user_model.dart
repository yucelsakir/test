class Kullanici {
  int? id;
  String? adi;
  String? soyadi;
  int? yas;
  String? telefon;
  int? il;
  int? ilce;
  String? adres;
  String? eposta;
  String? kullaniciAdi;
  String? sifre;
  int? kullaniciTipi;
  String? kayitTarihi;

  Kullanici(
      {this.id,
        this.adi,
        this.soyadi,
        this.yas,
        this.telefon,
        this.il,
        this.ilce,
        this.adres,
        this.eposta,
        this.kullaniciAdi,
        this.sifre,
        this.kullaniciTipi,
        this.kayitTarihi});

  Kullanici.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adi = json['adi'];
    soyadi = json['soyadi'];
    yas = json['yas'];
    telefon = json['telefon'];
    il = json['il'];
    ilce = json['ilce'];
    adres = json['adres'];
    eposta = json['eposta'];
    kullaniciAdi = json['kullanici_adi'];
    sifre = json['sifre'];
    kullaniciTipi = json['kullanici_tipi'];
    kayitTarihi = json['kayit_tarihi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['adi'] = adi;
    data['soyadi'] = soyadi;
    data['yas'] = yas;
    data['telefon'] = telefon;
    data['il'] = il;
    data['ilce'] = ilce;
    data['adres'] = adres;
    data['eposta'] = eposta;
    data['kullanici_adi'] = kullaniciAdi;
    data['sifre'] = sifre;
    data['kullanici_tipi'] = kullaniciTipi;
    data['kayit_tarihi'] = kayitTarihi;
    return data;
  }
}

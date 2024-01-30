class KullaniciEkle {
  String? adi;
  String? soyadi;
  String? eposta;
  String? kullaniciAdi;
  String? sifre;

  KullaniciEkle(
      {this.adi, this.soyadi, this.eposta, this.kullaniciAdi, this.sifre});

  KullaniciEkle.fromJson(Map<String, dynamic> json) {
    adi = json['adi'];
    soyadi = json['soyadi'];
    eposta = json['eposta'];
    kullaniciAdi = json['kullanici_adi'];
    sifre = json['sifre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adi'] = this.adi;
    data['soyadi'] = this.soyadi;
    data['eposta'] = this.eposta;
    data['kullanici_adi'] = this.kullaniciAdi;
    data['sifre'] = this.sifre;
    return data;
  }
}

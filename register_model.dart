class RegisterModel {
  String? adi;
  String? soyadi;
  String? eposta;
  String? kullaniciAdi;
  String? sifre;

  RegisterModel(
      {this.adi, this.soyadi, this.eposta, this.kullaniciAdi, this.sifre});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    adi = json['adi'];
    soyadi = json['soyadi'];
    eposta = json['eposta'];
    kullaniciAdi = json['kullaniciAdi'];
    sifre = json['sifre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adi'] = adi;
    data['soyadi'] = soyadi;
    data['eposta'] = eposta;
    data['kullaniciAdi'] = kullaniciAdi;
    data['sifre'] = sifre;
    return data;
  }
}

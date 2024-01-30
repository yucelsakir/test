class RegisterModel {
  String? adi;
  String? soyadi;
  String? eposta;
  String? kullaniciAdi;
  String? sifre;

  RegisterModel(
      {this.adi, this.soyadi, this.eposta, this.kullaniciAdi, this.sifre});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      adi: json['adi'],
      soyadi: json['soyadi'],
      eposta: json['eposta'],
      kullaniciAdi: json['kullaniciAdi'],
      sifre: json['sifre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adi': adi,
      'soyadi': soyadi,
      'eposta': eposta,
      'kullaniciAdi': kullaniciAdi,
      'sifre': sifre,
    };
  }

  @override
  String toString() {
    return 'RegisterModel(adi: $adi, soyadi: $soyadi, eposta: $eposta, kullaniciAdi: $kullaniciAdi, sifre: $sifre)';
  }
}

class GoogleKullanici {
  late String email;
  late String isimSoyisim;
  late String id;
  late String photoUrl;

Map<String, dynamic> getGoogleKullaniciMapGoogleKayit(
      String emaill, String isimSoyisimm, String idd, String photoUrl) {
    Map<String, dynamic> kullanici = {
      'userID': idd,
      'userName': isimSoyisimm,
      'eMail': emaill,
      'photoUrl': photoUrl,
      'begeniSayisi':0,

    };
    return kullanici;
  }
  Map<String, dynamic> getKayitEmailPasswordKullaniciMap(
      String userName, String sifre, String eMail,String userId,String photoUrl) {
    Map<String, dynamic> kullaniciMap = {
      'userName': userName,
      'eMail': eMail,
      'sifre': sifre,
      'begeniSayisi':0,
      'userID':userId,
      'photoUrl':photoUrl,
    };

    return kullaniciMap;
  }
}

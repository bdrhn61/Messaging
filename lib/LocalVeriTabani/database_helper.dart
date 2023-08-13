import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String _tokenTabloAdi = "tokenler";
  String _id = "id"; //COlon adlari
  String _yer = "yer";

  String _kullaniciTabloAdi = "kullaniciBilgileri";
  String _kullaniciId = "kullaniciId";
  String _kullaniciAdi = "kullaniciAdi";
  String _kullaniciEmail = "kullaniciEmail";
  String _kullaniciPhotoUrl = "kullaniciPhotoUrl";
  String _kullaniciFotoBytes = "kullaniciFotoBytes";
  String _kullaniciSifre = "kullaniciSifre";

  String _yerTabloAdi = "yerTabloAdi";
  String _yerLat = "yerLat";
  String _yerLang = "yerLang";
  String _yerId = "yerAdi";

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      print("null olustu");
      return _databaseHelper;
    } else {
      print("null degil dondu DatabaseHelper");
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    Directory klasor = await getApplicationDocumentsDirectory();
    String dbPath = join(klasor.path, "tokenler.db");
    print(dbPath);
    var tokenlarDB = openDatabase(dbPath, version: 1, onCreate: _createDB);
    return tokenlarDB;
  }

  Future<void> _createDB(Database db, int version) async {
    print("creat db metodu çalıştı");
    await db.execute("CREATE TABLE $_tokenTabloAdi ($_id TEXT, $_yer TEXT )");
    print("token table olustu");
    await db.execute(
        "CREATE TABLE $_kullaniciTabloAdi ($_kullaniciId TEXT PRIMARY KEY, $_kullaniciAdi TEXT, $_kullaniciEmail TEXT, $_kullaniciSifre TEXT, $_kullaniciPhotoUrl TEXT, $_kullaniciFotoBytes BLOB )");
    print("kullanici table olustu");
    await db.execute(
        "CREATE TABLE $_yerTabloAdi ($_yerLat REAL, $_yerLang REAL, $_yerId TEXT )");

    print("yer table olustu");
  }

  yerEkleToken(String aboneOlunanYer, String aboneOlanId) async {
    var db = await _getDatabase();
    await db.insert(
      _tokenTabloAdi,
      {_yer: aboneOlunanYer, _id: aboneOlanId},
    );
    print("yerEklendi  ----");
    var sonuc = await db.rawQuery("SELECT * FROM $_tokenTabloAdi");
    print(sonuc.toString());
  }

  yerSilToken(String silinecekYer, String silinecekId) async {
    var db = await _getDatabase();
  //  await db
   //     .delete(_tokenTabloAdi, where: '$_yer = ? ', whereArgs: [silinecekYer]);
    var sonuc = await db.rawQuery(
        "DELETE FROM $_tokenTabloAdi WHERE $_yer='$silinecekYer' AND $_id='$silinecekId'");
    sonuc = await db.rawQuery("SELECT * FROM $_tokenTabloAdi");
    print(sonuc.toString()+"***---");
  }

  yerOku(String adres, String userId) async {
    print("yerOku metodu ");
    var db = await _getDatabase();
    var sonuc = await db.rawQuery(
        "SELECT * FROM $_tokenTabloAdi WHERE $_yer='$adres' AND $_id='$userId'");

    //  "SELECT * FROM $_yerTabloAdi WHERE $_yerLat=$lat AND $_yerLang=$lang"
    print(sonuc.toString());
    return sonuc;
  }

  kullaniciBilgileriniEkleLokal(String kayituserId,
      Map<String, dynamic> kullaniciMap, Uint8List fotoByte) async {
    var db = await _getDatabase();
    await db.insert(
        _kullaniciTabloAdi,
        {
          _kullaniciId: kayituserId,
          _kullaniciAdi: kullaniciMap["userName"],
          _kullaniciEmail: kullaniciMap["eMail"],
          _kullaniciPhotoUrl: kullaniciMap["photoUrl"],
          _kullaniciFotoBytes: fotoByte,
          _kullaniciSifre: kullaniciMap["sifre"]
        },
        nullColumnHack: _kullaniciId);
    print("kullanici bilgileri lokale eklendi  ----");
    kullaniciBilgileriOkuLokal(kayituserId);
  }

  kullaniciBilgileriOkuLokal(String kayituserId) async {
    print("kullaniciBilgileriOkuLokal metodu çalıstı");
    var db = await _getDatabase();
    var sonuc = await db.rawQuery(
        "SELECT * FROM $_kullaniciTabloAdi WHERE $_kullaniciId  LIKE '$kayituserId'");
    print(sonuc.toString() + "sonuc  -*-*-*-*");
    return sonuc;
  }

  kullaniciFotoEkle(
      String kayituserId, Uint8List fotoByte, String fotoUrl) async {
    var db = await _getDatabase();

    await db.rawUpdate(
        "UPDATE $_kullaniciTabloAdi SET $_kullaniciFotoBytes = ? WHERE $_kullaniciId = ?",
        [fotoByte, kayituserId]);

    await db.rawUpdate(
        "UPDATE $_kullaniciTabloAdi SET $_kullaniciPhotoUrl = ? WHERE $_kullaniciId = ?",
        [fotoUrl, kayituserId]);

    print("kullanici fotoğrafı lokale eklendi  ----");
  }

  placeEkle(double yerLat, double yerLang, String yerId) async {
    var db = await _getDatabase();
    await db.insert(
      _yerTabloAdi,
      {
        _yerLat: yerLat,
        _yerLang: yerLang,
        _yerId: yerId,
      },
    );
    print("yer bilgileri eklendi");
  }

  placeSayisi() async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery("SELECT COUNT(*) FROM $_yerTabloAdi");
    return sonuc;
  }

 // yerOkuHepsini() async {
 //   print("yerOkuHepsini metodu okundu");
  //  var db = await _getDatabase();
  //  var sonuc = await db.query(_tokenTabloAdi, orderBy: '$_id DESC');
  //  var sonuc2 =
  //      await db.query(_kullaniciTabloAdi, orderBy: '$_kullaniciId DESC');

    //print("HEPSİ  " + sonuc.toString());
    //print("HEPSİ Kullanicilar " + sonuc2.toString());
 // }

  placeOku() async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery("SELECT * FROM $_yerTabloAdi");
    print(sonuc.toString());
  }

  placeYerOku() async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery("SELECT $_yerId FROM $_yerTabloAdi");
    print(sonuc.toString());
    return sonuc;
  }

  placeYerOku2(double lat, double lang) async {
    print("placeYerOku 2");
    var db = await _getDatabase();
    var sonuc = await db.rawQuery(
        "SELECT * FROM $_yerTabloAdi WHERE $_yerLat=$lat AND $_yerLang=$lang");
    print(sonuc.toString());
    return sonuc;
  }

  farkliYerOku() async {
    print("farkli yer oku");
    var db = await _getDatabase();
    var sonuc = await db
        .rawQuery("SELECT DISTINCT $_yerLat, $_yerLang FROM $_yerTabloAdi");
    print(sonuc.toString());
    return sonuc;
  }

  farkliYerEkle() async {
    var db = await _getDatabase();
    await db.insert(
      _yerTabloAdi,
      {
        _yerLat: 11,
        _yerLang: 15,
        _yerId: "yerIddddddd",
      },
    );
    print("yer bilgileri eklendi");
  }

  tabloOku() async {
    print("Tablo okundu");
    var db = await _getDatabase();
    var sonuc = await db.rawQuery("SELECT * FROM $_kullaniciTabloAdi");
    print(sonuc.toString());
    return sonuc;
  }
}

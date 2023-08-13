
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:space/models/publicMesajModel.dart';

class AdreseMesajPagenin extends StatefulWidget {
  @override
  State<AdreseMesajPagenin> createState() => _AdreseMesajPageninState();
}

class _AdreseMesajPageninState extends State<AdreseMesajPagenin> {
  List<MesajModel> _tumMesajlar;
  bool _isLoading = false;
  bool _hasMore = true;
  int _getirilecekElemanSayisi = 10;
  MesajModel _enSonGetirilenMesaj;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getMesaj(_enSonGetirilenMesaj);
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position == 0) {
          print("en tepedeyiz");
        } else {
          _getMesaj(_enSonGetirilenMesaj);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _tumMesajlar == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _kullaniciListesiniOlustur());
  }

  _getMesaj(MesajModel enSonGetirilenMesaj) async {
    if (!_hasMore) {
      print("getirilecek eleman yok vt rahatsız edilmeyecek");
      return;
    }
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot _querySnapshot;

    if (enSonGetirilenMesaj == null) {
      print("ilk defa kullanıcı getiriliyor");
      _querySnapshot = await FirebaseFirestore.instance
          .collection("--adreseMesaj")
          .doc(
              "d15b2145422e575c7033a9b4295c02f6e92e6a3ca7179cc75fbabd914dccc455")
          .collection("1")
          .orderBy("date", descending: true)
          .limit(_getirilecekElemanSayisi)
          .get();

      _tumMesajlar = [];
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("--adreseMesaj")
          .doc(
              "d15b2145422e575c7033a9b4295c02f6e92e6a3ca7179cc75fbabd914dccc455")
          .collection("1")
          .orderBy("date", descending: true)
          .startAfter([_tumMesajlar.last.date])
          .limit(_getirilecekElemanSayisi)
          .get();
    }

    if (_querySnapshot.docs.length < _getirilecekElemanSayisi) {
      _hasMore = false;
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      MesajModel _tekMesaj = MesajModel.mapNesne(snap.data(), snap.id);
      _tumMesajlar.add(_tekMesaj);
    }

    _enSonGetirilenMesaj = _tumMesajlar.last;

    setState(() {
      _isLoading = false;
    });
  }

  _kullaniciListesiniOlustur() {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index == _tumMesajlar.length) {
          print("yeni elemanlar yükleniyoır");
          return _yeniElemanlarYukleniyorIndicator();
        }

        return ListTile(
            title: Text(_tumMesajlar[index].userName,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),);
           
           
      },
      itemCount: _tumMesajlar.length + 1,
    );
  }

  _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Opacity(
          opacity: _isLoading ? 1 : 0,
          child: _isLoading ? CircularProgressIndicator() : null,
        ),
      ),
    );
  }

  
}
*/
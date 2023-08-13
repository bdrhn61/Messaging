

/*import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/counterpro.dart';
import 'package:space/models/Ben.dart';
import 'package:space/toastSnackBar.dart';

File _secilenresim;

class PhotoPicker extends StatefulWidget {
  @override
  PhotoPickerState createState() => PhotoPickerState();
}

class PhotoPickerState extends State<PhotoPicker>
    with SingleTickerProviderStateMixin {
  List<Widget> _photoList = [];
  List<AssetEntity> _selectedList = [];
  int currentPage = 0;
  int lastPage;
  int maxSelection = 1;
  FilterOptionGroup filter;
  AnimationController _controller;
  bool yuklensinMi;
  CounterPro _sayfaP;

  Color _renk = Colors.red;
  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchPhotos();
      }
    }
  }

  _fetchPhotos() async {
    FilterOptionGroup filter = new FilterOptionGroup();
    filter.setOption(AssetType.image, FilterOption());
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {
      //load the album list
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
          onlyAll: true, type: RequestType.image, filterOption: filter);
      for (int i = 0; i < albums.length; i++)
        print(albums[i].name + "---------------");

      List<AssetEntity> media =
          await albums[0].getAssetListPaged(currentPage, 60);
      List<Widget> temp = [];

      for (var asset in media) {
        temp.add(
          Padding(
            padding: const EdgeInsets.all(1),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              child: PhotoPickerItem(
                  asset: asset,
                  onSelect: (AssetEntity asset, bool selected) {
                    // selected is the current selection state, so be for touch
                    if (selected) {
                      print("kaldırıldı");
                      yuklensinMi = false;
                      //_controller.reset();

                      _controller.reverse();
                      setState(() => _renk = Colors.red);

                      _selectedList.remove(asset);
                      return !selected;
                    } else if (_selectedList.length < maxSelection) {
                      _selectedList.add(asset);
                      yuklensinMi = true;
                      print("secildi");
                      _controller.forward();

                      setState(() => _renk = Colors.green);
                      print(asset.file.toString());

                      //.getMediaUrl().toString());

                      return !selected;
                    }

                    return selected;
                  }),
            ),
          ),
        );
      }
      setState(() {
        _photoList.addAll(temp);
        currentPage++;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  @override
  void initState() {
    super.initState();
    yuklensinMi = false;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _fetchPhotos();
  }

  double angel = 0;
  Ben sayfaProvideriBen;
  @override
  Widget build(BuildContext context) {
    _sayfaP = Provider.of<CounterPro>(context, listen: false);
    sayfaProvideriBen = Provider.of<Ben>(context, listen: true);
    final double boy = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: <Widget>[
          Scaffold(
              floatingActionButton: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(boy / 38)),
                child: AnimatedContainer(
                  color: _renk,
                  duration: Duration(seconds: 1),
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                    child: IconButton(
                        icon: Icon(Icons.navigate_before),
                        onPressed: () {
                          try {
                            yukleVeyeGeriGel(context);
                          } catch (e) {
                            _sayfaP.gosterFalse();
                          }
                        }),
                  ),
                ),
              ),
              backgroundColor: Colors.black,
              body: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scroll) {
                  _handleScrollEvent(scroll);
                  return;
                },
                child: GridView.builder(
                    itemCount: _photoList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return _photoList[index];
                    }),
              )),
          ProgresBar(),
        ],
      ),
    );
  }

  Future<void> yukleVeyeGeriGel(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (yuklensinMi) {
      _sayfaP.gosterTrue();
      print("resim yükleniyor");
      showInSnackBar("please wait", context);
      var ref =
          FirebaseStorage.instance.ref("users").child(_auth.currentUser.uid);
      var upload = (await ref.putFile(File(_secilenresim.path)));

      String urlgaleri = await ref.getDownloadURL();
      FirebaseFirestore _veriTabani = FirebaseFirestore.instance;

      if (urlgaleri != null) {
        await _veriTabani
            .collection("--users")
            .doc(_auth.currentUser.uid)
            .set({"photoUrl": urlgaleri}, SetOptions(merge: true));

        //  await _db1.kullaniciFotoEkle(_auth.currentUser.uid,_fotoByte,urlgaleri);
        // _db1.yerOkuHepsini();
        //      sayfaProvideriBen.photoByteLokalSet(_fotoByte);
        // print( sayfaProvideriBen.benMapGetir().toString()+"-----------*********************-*-*-*-");
        //   print("veri tabanına kaydedildi" + sayfaProvideriBen.userid.toString());
        //  print("user id" + sayfaProvideriBen.userid.toString());
        //  print("user name" + sayfaProvideriBen.userName.toString());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("benimPhotoUrl", urlgaleri);
        sayfaProvideriBen.photoUrlSetNotNotify(urlgaleri);
      }

      _sayfaP.gosterFalse();
      Navigator.of(context).pop();

      //   Navigator.of(context).pop(urlgaleri); //_selectedList
      //debugPrint("URL" + urlgaleri);
    } else {
      if (_sayfaP.goster == 0)
        Navigator.of(context).pop(_selectedList);
      else
        print("çıkamazsınn");
    }
  }

  Future<bool> _onWillPop() {
    if (_sayfaP.goster == 0)
      Navigator.of(context).pop(_selectedList);
    else
      print("çıkamazsınn");
  }
}

class PhotoPickerItem extends StatefulWidget {
  final Key key;
  final AssetEntity asset;
  final bool Function(AssetEntity asset, bool isSelected) onSelect;

  const PhotoPickerItem({this.asset, this.onSelect, this.key});

  @override
  _PhotoPickerItemState createState() => _PhotoPickerItemState();
}

class _PhotoPickerItemState extends State<PhotoPickerItem> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.asset.thumbDataWithSize(200, 200),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return GestureDetector(
            onTap: () async {
              // isSelected = !isSelected;
              setState(() {
                isSelected = widget.onSelect(widget.asset, isSelected);
              });
              _secilenresim = await widget.asset.file;
            },
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.memory(
                    snapshot.data,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isSelected)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                if (isSelected)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5, bottom: 5),
                      child: Icon(
                        Icons.fiber_manual_record,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                if (isSelected)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5, bottom: 5),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          );
        return Container();
      },
    );
  }
}

class ProgresBar extends StatelessWidget {
  Widget build(BuildContext context) {
    var _sayfaProvideri = Provider.of<CounterPro>(context, listen: true);
    return Opacity(
      opacity: _sayfaProvideri.goster,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
        ),
      ),
    );
  }
}
*/
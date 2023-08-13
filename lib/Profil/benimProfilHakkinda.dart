import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:space/models/Ben.dart';

class BenimProfilHakkinda extends StatelessWidget {
  Map<String, dynamic> _hakkimda;
  int infovarMi = 0;
  Ben sayfaProvideriBen;
  BenimProfilHakkinda(this.sayfaProvideriBen);

  @override
  Widget build(BuildContext context) {
    final double en = MediaQuery.of(context).size.width;
    final double boy = MediaQuery.of(context).size.height;
    print(sayfaProvideriBen.hakkimdaMap.toString());

    return  
         
            
               Padding(
                 padding: const EdgeInsets.only(left:8.0,right:8.0),
                 child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: [
                    if (sayfaProvideriBen.hakkimdaMap["hakkimda"] != "")
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          width: en,
                          child: Center(
                              child:
                                  Text(sayfaProvideriBen.hakkimdaMap["hakkimda"])),
                        ),
                      ),
                   
                    if (sayfaProvideriBen.hakkimdaMap["cinsiyet"] != "")
                      birChip(sayfaProvideriBen.hakkimdaMap["cinsiyet"], boy,
                          "assets/images/hakkimda/gender-symbols.png"),
                    if (sayfaProvideriBen.hakkimdaMap["yas"] != "")
                      birChip(sayfaProvideriBen.hakkimdaMap["yas"], boy,
                          "assets/images/hakkimda/back-in-time.png"),
                    if (sayfaProvideriBen.hakkimdaMap["boy"] != "")
                      birChip(sayfaProvideriBen.hakkimdaMap["boy"], boy,
                          "assets/images/hakkimda/length.png"),
                    if (sayfaProvideriBen.hakkimdaMap["egitim"] != "")
                      birChip(sayfaProvideriBen.hakkimdaMap["egitim"], boy,
                          "assets/images/hakkimda/mortarboard.png"),
                    if (sayfaProvideriBen.hakkimdaMap["is"] != "")
                    birChip(sayfaProvideriBen.hakkimdaMap["is"], boy,
                        "assets/images/hakkimda/suitcase.png"),
                    //    if (_hakkimda["ilgi_Alanlari"] != "")
                    //     birChip(
                    //          _hakkimda["ilgi_Alanlari"],
                    //          boy,
                    //          "assets/images/flutter1.png"),
                    if (sayfaProvideriBen.hakkimdaMap["twitter"] != "")
                      birChip(sayfaProvideriBen.hakkimdaMap["twitter"], boy,
                          "assets/images/hakkimda/twitter.png"),
                    if (sayfaProvideriBen.hakkimdaMap["youtube"] != "")
                      birChip(sayfaProvideriBen.hakkimdaMap["youtube"], boy,
                          "assets/images/hakkimda/youtube.png"),
                    if (sayfaProvideriBen.hakkimdaMap["snapchat"] != "")
                      birChip(sayfaProvideriBen.hakkimdaMap["snapchat"], boy,
                          "assets/images/hakkimda/snapchat.png"),
                    if (sayfaProvideriBen.hakkimdaMap["İnstagram"] != "")
                      birChip(sayfaProvideriBen.hakkimdaMap["İnstagram"], boy,
                          "assets/images/hakkimda/instagram.png"),
                    bossaDondur(boy, en),
                   
                  ],
              
            
        
      
    
         ),
               );
  }

  birChip(hakkimda, double boy, String connectionString) {
    infovarMi++;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(boy / 15)),
      ),
      child: Padding(
        padding: EdgeInsets.all(boy / 55),
        child: Wrap(
          children: [
            Image.asset(
              connectionString,
              width: boy / 25,
              height: boy / 25,
            ),
            Container(
              height: boy / 25,
              child: Padding(
                padding: EdgeInsets.only(top: boy / 60, left: boy / 40),
                child: Text(
                  hakkimda,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bossaDondur(boy, en) {
    if (infovarMi == 0) {
      print(infovarMi.toString() +
          "  infovar mi------------------------------------------------------------");

      return Center(
        child: Container(
          height: boy / 4,
          child: Center(
            child: Text(
              "info yok",
              textScaleFactor: en / (en / 1.1),
              style: GoogleFonts.montserrat(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
        ),
      );
    } else {
      print(infovarMi.toString() +
          "  infovar mişşşş------------------------------------------------------------");
      return SizedBox();
    }
  }
}

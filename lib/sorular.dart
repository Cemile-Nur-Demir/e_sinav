//import 'dart:convert';
import 'dart:async';

import 'package:e_sinav/bitir.dart';
import 'package:flutter/material.dart';

class Sorular extends StatefulWidget {
  @override
  _SorularState createState() => _SorularState();
}

String zamaniFormatla(int milisaniye) {
  var saniye = milisaniye ~/ 1000; // ~/ Tam sayı bölme işlemidir
  var dakika = ((saniye % 3600) ~/ 60).toString().padLeft(2, '0');
  var saniyeler = (saniye % 60).toString().padLeft(2, '0');

  return "$dakika:$saniyeler";
}

class _SorularState extends State<Sorular> {
  String adSoyad = '';
  String ogrNo = '';

  int mevcutsoru = 0;
  String mevcutcevap = '';
  int puan = 0;
  int kullanilansure = 0;

  Stopwatch _sayac;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _sayac = Stopwatch();
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {});
    });
    mevcutsoru = 0;
    mevcutcevap = '';
    puan = 0;
    kullanilansure = 0;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void BitireYolla(){
    var data = [];
    data.add(adSoyad);
    data.add(ogrNo);
    data.add(puan.toString());
    data.add(zamaniFormatla(kullanilansure));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Bitir(),
          settings: RouteSettings(
            arguments: data,
          ),
        ));
  }

  var sorular = [
    {
      'soru': 'Fatih Sultan Mehmet\'in babası kimdir?',
      'cevaplar': ['I. Mehmet', 'II. Murat', 'Yıldırım Beyazıt'],
      'dogrucevap': 'II. Murat'
    },
    {
      'soru': 'Hangi yabancı futbolcu Fenerbahçe forması giymiştir?',
      'cevaplar': ['Simoviç', 'Schumacher', 'Prekazi'],
      'dogrucevap': 'Schumacher'
    },
    {
      'soru': 'Magna Carta hangi ülkenin kralıyla yapılmış bir sözleşmedir?',
      'cevaplar': ['İngiltere', 'Fransa', 'İspanya'],
      'dogrucevap': 'İngiltere'
    },
    {
      'soru': 'Hangisi tarihteki Türk devletlerinden biri değildir?',
      'cevaplar': ['Avar Kağanlığı', 'Emevi Devleti', 'Hun İmparatorluğu'],
      'dogrucevap': 'Emevi Devleti'
    },
    {
      'soru': 'Hangi ülke Asya kıtasındadır?',
      'cevaplar': ['Madagaskar', 'Peru', 'Singapur'],
      'dogrucevap': 'Singapur'
    },
    {
      'soru':
          'ABD başkanlarından John Fitzgerald Kennedy’e suikast düzenleyerek öldüren kimdir?',
      'cevaplar': ['Lee Harvey Oswald', 'Clay Shaw', 'Jack Ruby'],
      'dogrucevap': 'Lee Harvey Oswald'
    },
    {
      'soru':
          'Aşağıdaki hangi Anadolu takımı Türkiye Süper Liginde şampiyon olmuştur?',
      'cevaplar': ['Kocaelispor', 'Bursaspor', 'Eskişehirspor'],
      'dogrucevap': 'Bursaspor'
    },
    {
      'soru': 'Hangisi Kanuni Sultan Süleyman’ın eşidir?',
      'cevaplar': ['Safiye Sultan', 'Kösem Sultan', 'Hürrem Sultan'],
      'dogrucevap': 'Hürrem Sultan'
    },
    {
      'soru': 'Hangi hayvan memeli değildir?',
      'cevaplar': ['Penguen', 'Yunus', 'Yarasa'],
      'dogrucevap': 'Penguen'
    },
    {
      'soru': 'Osmanlı’da Lale devri hangi padişah döneminde yaşamıştır?',
      'cevaplar': ['III. Ahmet', 'IV. Murat', 'III. Selim'],
      'dogrucevap': 'III. Ahmet'
    },
  ];

  void kontrolEt() {
    if (mevcutsoru > 8) {
      mevcutsoru = 0;
      _timer.cancel();
      BitireYolla();
    } else {
      if (mevcutcevap == sorular[mevcutsoru]['dogrucevap']) {
        puan = puan + 10;
        mevcutsoru++;
        kullanilansure = kullanilansure + _sayac.elapsedMilliseconds;
        _sayac.reset();
      } else {
        puan = puan - 10;
        mevcutsoru++;
        kullanilansure = kullanilansure + _sayac.elapsedMilliseconds;
        _sayac.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = [];
    data = ModalRoute.of(context).settings.arguments;
    adSoyad = data[0];
    ogrNo = data[1];


    _sayac.start();
    if (_sayac.elapsedMilliseconds > 9999 && mevcutsoru < 9) {
      kullanilansure = kullanilansure + _sayac.elapsedMilliseconds;
      _sayac.reset(); // 10 saniyede cevap verilmezse diğer soruya geçiyor
      mevcutsoru++;
    }

    if (mevcutsoru == 9 && _sayac.elapsedMilliseconds > 9999) {
      Future.delayed(Duration.zero, () async {
        _sayac.reset(); // Sıfırlama
        _sayac.stop(); // Bitiş ekranına geldik artık
        _timer.cancel(); // Yeni ekrana geçtiğinde saymayı bitirsin
        mevcutsoru = 0;
        BitireYolla();
      });
    }

    List cevaplistesi = [];
    for (var u in sorular[mevcutsoru]['cevaplar']) {
      cevaplistesi.add(u);
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('e-Sınav', style: TextStyle(fontSize: 60.0)),
            Text('Ad-Soyad: ' + adSoyad, style: TextStyle(fontSize: 24.0)),
            Text('Öğrenci No: ' + ogrNo, style: TextStyle(fontSize: 24.0)),
            Text(
              'Mevcut Soru /Toplam Soru: ' +
                  mevcutsoru.toString() +
                  ' / ' +
                  sorular.length.toString(),
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Puan: ' + puan.toString(),
              style: TextStyle(fontSize: 16),
            ),
            Text(
              sorular[mevcutsoru]['soru'].toString(),
              style: TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    mevcutcevap = cevaplistesi[0].toString();
                  });
                  kontrolEt();
                },
                child: Text(
                  cevaplistesi[0],
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    mevcutcevap = cevaplistesi[1].toString();
                  });
                  kontrolEt();
                },
                child: Text(
                  cevaplistesi[1],
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    mevcutcevap = cevaplistesi[2].toString();
                  });
                  kontrolEt();
                },
                child: Text(
                  cevaplistesi[2],
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Text(zamaniFormatla(_sayac.elapsedMilliseconds),
                style: TextStyle(fontSize: 48.0)),
            Text('Kullanılan Süre: ' + zamaniFormatla(kullanilansure),
                style: TextStyle(fontSize: 48.0)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Text('Anasayfaya Dön'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

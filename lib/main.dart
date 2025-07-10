import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyStepperApp());
  }
}

class MyStepperApp extends StatefulWidget {
  const MyStepperApp({super.key});

  @override
  State<MyStepperApp> createState() => _MyStepperAppState();
}

class _MyStepperAppState extends State<MyStepperApp> {
  int _aktifStep = 0;
  String kullaniciIsmi = "", mail = "", sifre = "";
  late List<Step> tumStepler;
  var keyName = GlobalKey<FormFieldState>();
  var keyMail = GlobalKey<FormFieldState>();
  var keySifre = GlobalKey<FormFieldState>();
  bool hata = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tumStepler = _tumStepler();
    return Scaffold(
      appBar: AppBar(
        title: Text("Stepper Uygulaması"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Stepper(
          currentStep: _aktifStep,
          onStepTapped: (tiklananStepIndex) {
            setState(() {
              _aktifStep = tiklananStepIndex;
            });
          },

          onStepContinue: () {
            setState(() {
              ileriButonKontrolu();
            });
          },
          onStepCancel: () {
            setState(() {
              if (_aktifStep > 0) {
                _aktifStep--;
              } else {
                _aktifStep = 0;
              }
            });
          },
          steps: _tumStepler(),
        ),
      ),
    );
  }

  List<Step> _tumStepler() {
    List<Step> stepler = [
      Step(
        title: Text("Username Başlık"),
        subtitle: Text("Username Altbaşlık"),
        state: stateleriAyarla(
          0,
        ), // Baştaki circle ın içine hangi iconu yerleşeceğimizi belirttiğimiz yer.
        isActive:
            true, //true ise baştaki iconun rengini yakar, false ise gri olur.
        content: TextFormField(
          onSaved: (gelenName) {
            kullaniciIsmi = gelenName!;
          },
          key: keyName,
          validator: (girilenUserName) {
            if (girilenUserName!.length < 6) {
              return "En az 6 karakter olmalı";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: "Username",
            hintText: "Kullanıcı adı",
            border: OutlineInputBorder(),
          ),
        ),
      ),
      Step(
        title: Text("Mail Başlık"),
        subtitle: Text("Mail Altbaşlık"),
        isActive: true,
        state: stateleriAyarla(1),
        content: TextFormField(
          onSaved: (gelenMail) {
            mail = gelenMail!;
          },
          key: keyMail,
          validator: (girilenMail) {
            if (!girilenMail!.contains("@")) {
              return "Geçerli mail giriniz";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: "e-Mail",
            hintText: "Mail giriniz",
          ),
        ),
      ),

      Step(
        title: Text("Şifre Başlık"),
        subtitle: Text("Şifre Altbaşlık"),
        isActive: true,
        state: stateleriAyarla(2),
        content: TextFormField(
          onSaved: (gelenSifre) {
            sifre = gelenSifre!;
          },
          key: keySifre,
          validator: (girilenSifre) {
            if (girilenSifre!.length < 8) {
              return "En az 8 karakter olmalı";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(labelText: "Password", hintText: "Şifre"),
        ),
      ),
    ];
    return stepler;
  }

  StepState stateleriAyarla(int oAnkiStep) {
    if (_aktifStep == oAnkiStep) {
      if (hata) {
        return StepState.error;
      } else {
        return StepState.editing;
      }
    } else {
      if (hata) {
        return StepState.indexed;
      } else {
        return StepState.complete;
      }
    }
  }

  void ileriButonKontrolu() {
    switch (_aktifStep) {
      //0. indexin baslangıcı
      case 0:
        if (keyName.currentState!.validate()) {
          keyName.currentState!.save();
          hata = false;
          _aktifStep = 1;
        } else {
          hata = true;
        }
        break;
      //0. indexin bitişi
      //1. indexin baslangıcı
      case 1:
        if (keyMail.currentState!.validate()) {
          keyMail.currentState!.save();
          hata = false;
          _aktifStep = 2;
        } else {
          hata = true;
        }
        break;
      //1. indexin bitişi,
      //2. indexin baslangıcı
      case 2:
        if (keySifre.currentState!.validate()) {
          keySifre.currentState!.save();
          hata = false;
          _aktifStep = 2;
          formTamamlandi();
        } else {
          hata = true;
        }
        break;
      //2. indexin bitişi
    }
  }

  void formTamamlandi() {
    String result =
        "Girilen değerler: isim=> $kullaniciIsmi, email=> $mail, şifre=> $sifre";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.indigo,
        content: Text(
          result,
          style: TextStyle(color: Colors.white, fontSize: 38),
        ),
      ),
    );
  }
}

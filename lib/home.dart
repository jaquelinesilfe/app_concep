import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String resultado = "Seu endereço irá aparecer aqui";

  TextEditingController txtcep = TextEditingController();

  void buscacep() async {
    String cep = txtcep.text;

    String url = "https://viacep.com.br/ws/$cep/json/";
    //http://localhost:53620/#/SalvarEndereco

    http.Response response;

    response = await http.get(url);

    if (kDebugMode) {
      print("Resposta: " + response.body);
    }

    if (kDebugMode) {
      print("Status: " + response.statusCode.toString());
    }

    Map<String, dynamic> dados = json.decode(response.body);

    var logradouro = dados["logradouro"];
    String bairro = dados["bairro"];
    String localidade = dados["localidade"];
    String uf = dados["uf"];

    String endereco = "$logradouro,  $bairro, $localidade, $uf";

    if (kDebugMode) {
      print("Os dados do endereço é: " + endereco);
    }

    setState(() {
      resultado = endereco;
    });
  }

  void clearText() {
    txtcep.clear();
    setState(() {
      resultado = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Consulta Via CEP"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: txtcep,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      label: Text("Digite um cep: ex: 7465000")),
                  style:
                      const TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  child: const Text("Consultar"),
                  onPressed: buscacep,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  child: const Text("Limpar"),
                  onPressed: clearText,
                ),
                Text(
                  (resultado),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, height: 5.0),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  child: const Text("Compartilhar Endereço"),
                  onPressed: () async {
                    const urlPreview =
                        'https://viacep.com.br/ws/75650050/json/';
                    await Share.share("endereco\n\n$urlPreview");
                  },
                ),
              ],
              // Page
            ),
          ),
        ));
  }
}

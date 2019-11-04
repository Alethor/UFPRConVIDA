import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ufpr_convida/ui/tela_principal.dart';
import 'package:ufpr_convida/modelos/AccountCredentials.dart';
import 'package:http/http.dart' as http;
import 'package:ufpr_convida/util/globals.dart' as globals;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  //Variáveis da Tela, controladores para saber quais são os imputs do usuário
  final TextEditingController _usuarioController = new TextEditingController();
  final TextEditingController _senhaController = new TextEditingController();
  String url = globals.URL;

  String hint = "GRR:";
  int selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 1;
  }

  void SelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      if (val == 2){
        hint = "Email:";
      }
      else
        hint = "GRR:";
    });
  }

  //Método que puxa a tela principal quando tudo esta ok com o Login
  Future _abrirTela(BuildContext context) async {
    Map result = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new telaPrincipal();
    }));
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        //Barra superior
//      appBar: AppBar(
//        title: Text("UFPR ConVIDA"),
//        backgroundColor: Colors.blueAccent,
//        centerTitle: true,
//      ),

        //Corpo do aplicativo que ficará alternando
        body: Container(
          alignment: Alignment.topCenter,
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Image.asset(
                //Imagem LOGO da UFPR
                "assets/logo-ufprconvida-sembordas.png",

                width: 200.0,
                height: 200.0,
                //Possível mudança de cor
                //color: Colors.white70,
              ),
              Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //Campos de entrada de dados
                    children: <Widget>[
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Aluno", style: TextStyle(fontSize: 16)),
                          Radio(
                            value: 1,
                            groupValue: selectedRadio,
                            onChanged: (val) {
                              print("Radio: $val");
                              SelectedRadio(val);
                            },
                            //activeColor: Colors.indigo,
                          ),
                          Text("Servidor", style: TextStyle(fontSize: 16)),
                          Radio(
                            value: 2,
                            groupValue: selectedRadio,
                            onChanged: (val) {
                              print("Radio: $val");
                              SelectedRadio(val);
                            },
                            //activeColor: Colors.indigo,
                          ),
                        ],
                      ),
                      //GRR --> Ex. GRR2018XXXX

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _usuarioController,
                          decoration: InputDecoration(
                              hintText: hint,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5)),
                              icon: Icon(Icons.person)),
                        ),
                      ),
                      //Senha ******
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _senhaController,
                          decoration: InputDecoration(
                              hintText: "Senha: ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.5)),
                              icon: Icon(Icons.lock)),
                          //Para ocultar a senha:
                          obscureText: true,
                        ),
                      ),

                      Center(
                        //Linha para os botões
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            //Botao Entrar
                            Container(
                                margin: const EdgeInsets.all(4.5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        color: Color(0xFF295492),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        onPressed: () => _logar(),
                                        padding:
                                            EdgeInsets.fromLTRB(60, 12, 60, 12),
                                        child: Text('Entrar',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        color: Color(0xFF8A275D),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        onPressed: () {
                                          //Ao pressionar Cadastrar:
                                          Navigator.of(context).pushNamed("/signup");
                                        },
                                        padding:
                                            EdgeInsets.fromLTRB(43, 12, 43, 12),
                                        child: Text('Cadastrar',
                                            //Color(0xFF295492),(0xFF8A275D)
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18)),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  //Método que será chamado quando o usuario clicar no botao ENTRAR
  void _logar() async {
    if (_usuarioController.text.isNotEmpty &&
        _senhaController.text.isNotEmpty) {
      AccountCredentials account = new AccountCredentials(_usuarioController.text, _senhaController.text);

      String postBody = json.encode(account.toJson());
      print("POST: $postBody");

      String status = await createPost("$url/login", body: postBody);
      //Verificação
      if (status == "OK"){
        globals.userName = _usuarioController.text;
        _abrirTela(context);
      }
      else if (status == "ERRO"){
        var alert = AlertDialog(
          title: Text(
            "Login Incorreto!",
            style: TextStyle(color: Colors.redAccent, fontSize: 18.0),
          ),
          content: Text("Usuario ou Senha inválido(s)"),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  setState(() {
                    //Limpa os campos
                    _senhaController.clear();
                    _usuarioController.clear();
                  });
                  Navigator.pop(context);
                },
                child: Text("OK!")),
          ],
        );
        showDialog(context: context, builder: (context) => alert);
      }
      else
        throw Exception("Erro de login");

      //Chama outra página depois de tratar adquadamente
      // a entrada de dados!



    }
  }

  Future <String> createPost(String url, {String body}
      /*Aqui tem que ter HEADERS?*/) async {
    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    return http.post(url, body: body, headers: mapHeaders).then((http.Response response) {
      final int statusCode = response.statusCode;
      var j = json.decode(response.body);
      String tkn = j["token"];
      print("statusCode ${response.statusCode} - Token recebido:$tkn");

      globals.token = tkn;


      if ((statusCode == 200) || (statusCode == 201)) {
        return "OK"; //Post.fromJson(json.decode(response.body));
      } else {
        return "ERRO";
      }
    });
  }

}

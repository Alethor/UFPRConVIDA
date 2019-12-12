import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufpr_convida_2/app/shared/models/event.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:http/http.dart' as http;

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class EventsWidget extends StatefulWidget {
  @override
  _EventsWidgetState createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  String _url = globals.URL;
  var jsonData;
  String _imageAsset = "";
  DateFormat date = new DateFormat.yMMMMd("pt_BR");
  DateFormat hour = new DateFormat.Hm();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: FutureBuilder(
            //initialData: "Loading..",
            future: getAllEvents(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<Event> values = snapshot.data;
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              } else {
                return ListView.builder(
                    itemCount: values.length,
                    itemBuilder: (BuildContext context, int index) {

                      if(values[index].type == 'Saúde'){
                        _imageAsset = 'type-health.png';
                      }else if (values[index].type == 'Esporte e Lazer'){
                        _imageAsset = 'type-sport.png';
                      }else if (values[index].type == 'Festas e Comemorações'){
                        _imageAsset = 'type-party.png';
                      }else if (values[index].type == 'Cultura'){
                        _imageAsset = 'type-art.png';
                      }else if (values[index].type == 'Acadêmico'){
                        _imageAsset = 'type-graduation.png';
                      }else {
                        _imageAsset = 'type-others.png';
                      }

                      DateTime eventDate = DateTime.parse(values[index].dateStart);
                      DateTime eventHour = DateTime.parse(values[index].hrStart);

                      return SizedBox(
                        width: double.infinity,
                        height: 120,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              //Event's Info:
                              ListTile(
                                title: Text(
                                  values[index].name,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 21.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  "${date.format(eventDate)} - ${hour.format(eventHour)}",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300),
                                ),
                                leading: CircleAvatar(
                                  radius: 42.0,
                                  backgroundColor: Colors.white,
                                  child: Image.asset("assets/$_imageAsset"),
                                ),
                                isThreeLine: true,

                                //Just a Test:
                                trailing: PopupMenuButton<WhyFarther>(
                                  onSelected: (WhyFarther result) {
                                    setState(() {});
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<WhyFarther>>[
                                    const PopupMenuItem<WhyFarther>(
                                      value: WhyFarther.harder,
                                      child: Text('Working a lot harder'),
                                    ),
                                    const PopupMenuItem<WhyFarther>(
                                      value: WhyFarther.smarter,
                                      child: Text('Being a lot smarter'),
                                    ),
                                    const PopupMenuItem<WhyFarther>(
                                      value: WhyFarther.selfStarter,
                                      child: Text('Being a self-starter'),
                                    ),
                                    const PopupMenuItem<WhyFarther>(
                                      value: WhyFarther.tradingCharter,
                                      child: Text(
                                          'Placed in charge of trading charter'),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, '/event', arguments: {
                                    'id' : values[index].id
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }));
  }

  Future<List> getAllEvents() async {
    List<Event> parsed = [];
    Iterable list;
    http.Response response = await http.get("$_url/events");

    print("-------------------------------------------------------");
    print("Request on: $_url/events");
    print("Status Code: ${response.statusCode}");
    print("Loading All Events... ");
    print("-------------------------------------------------------");

    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Event>((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception("Falhou!");
    }

  }
}

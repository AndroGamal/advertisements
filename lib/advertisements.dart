import 'dart:convert';
import 'package:dumperplay/provider.dart';
import 'package:flutter/material.dart';
import 'package:dumperplay/main.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class advertisements {
  late MyHomePageState _h;
  late AlertDialog _show;
  late BuildContext _control;
  List<DropdownMenuItem<String>> _list = [];
  var _select;
  advertisements(MyHomePageState x) {
    _h = x;
    add_list("Egypt", "eg");
    add_list("USA", "us");
  }
  void show(Image image) {
    _show = AlertDialog(
        content: image,
        contentPadding: EdgeInsets.all(1.0),
        backgroundColor: Colors.grey[600],
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FloatingActionButton(
            backgroundColor: Colors.grey.shade800,
            onPressed: () {
              Navigator.of(_control).pop();
            },
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
        elevation: 10);
  }

  Future get_list(String s) async {
    Uri url = Uri.parse(s);
    var code = await http.get(url);
    return jsonDecode(code.body);
  }

  void add_list(String name, [String? value]) {
    _list.add(DropdownMenuItem(
      value: value ?? name,
      child: Row(children: [
        Icon(
          Icons.room,
          color: Colors.white,
        ),
        Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
      ]),
    ));
  }

  Widget container(String url) {
    Image image = Image.network(
      url,
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
    );
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: _h.context,
              builder: (context) {
                _control = context;
                return _show;
              });
          show(image);
        },
        child: Container(
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              image
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1.0,
              color: Colors.black,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 0), // changes position of shadow
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget create() {
    var prov = Provider.of<Myprovider>(_h.context);
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      DropdownButton(
        dropdownColor: Colors.grey[600],
        isExpanded: true,
        hint: Text(
          "  please select country",
          style: TextStyle(color: Colors.grey),
        ),
        items: _list,
        onChanged: (value) {
          _h.setState(() {
            _select = value.toString();
          });
        },
        value: _select,
      ),
      Expanded(
        child: Container(
          child: FutureBuilder(
            future: get_list('https://jsonplaceholder.typicode.com/photos'),
            builder: (context, AsyncSnapshot sn) {
              if (sn.hasData)
                return GridView.builder(
                    itemCount: sn.data.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, i) {
                      return container(sn.data[i]['url']);
                    });
              else
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
            },
          ),
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        RawMaterialButton(
          onPressed: () {
            prov.logout();
            _h.setState(() {
              MyHomePageState.index = 0;
            });
          },
          padding: EdgeInsets.all(10),
          child: Icon(Icons.logout, color: Colors.white),
        ),
        RawMaterialButton(
          onPressed: () {},
          padding: EdgeInsets.all(10),
          child: Icon(Icons.airplanemode_active, color: Colors.white),
        )
      ])
    ]));
  }
}

import 'package:dumperplay/Toastan.dart';
import 'package:dumperplay/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _statlogin();
  }
}

class _statlogin extends State<Login> {
  late TextEditingController _email, _pass;
  bool chick = true;
  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  Widget get_textfild(String hint,
      {TextInputType? type,
      TextEditingController? myController,
      TextInputType? keybourd}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
            controller: myController ?? TextEditingController(),
            showCursor: false,
            obscureText: type == TextInputType.visiblePassword ? chick : false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              isDense: true,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[50]),
              filled: true,
              fillColor: Colors.grey,
            ),
            keyboardType: type ?? TextInputType.text,
            cursorColor: Colors.transparent),
      ),
    );
  }

  Widget create() {
    var prov = Provider.of<Myprovider>(context);
    Toastan toast = Toastan();
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            get_textfild("E-mail",
                myController: _email, type: TextInputType.emailAddress),
            get_textfild("Password",
                myController: _pass, type: TextInputType.visiblePassword),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                    title: Text(
                      "Show password",
                      style: TextStyle(color: Colors.white),
                    ),
                    checkColor: Colors.black,
                    activeColor: Colors.white,
                    value: !chick,
                    onChanged: (value) {
                      setState(() {
                        chick = !(value as bool);
                      });
                    }),
              ),
            ),
            Padding(padding: EdgeInsets.all(50)),
            SizedBox(
              width: 80,
              child: ElevatedButton(
                onPressed: () async {
                  if (!await prov.login(_email.text, _pass.text)) {
                    toast.show_unusual(prov.failure, context);
                  }
                },
                child: prov.caseMyprovider == statmyprovide.try_auth
                    ? SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade700)),
              ),
            ),
            SizedBox(
              width: 80,
              child: ElevatedButton(
                onPressed: () async {
                  if (!await prov.Create_acount(_email.text, _pass.text))
                    toast.show_unusual(prov.failure, context);
                },
                child: prov.caseMyprovider == statmyprovide.try_auth
                    ? SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Sing up",
                        style: TextStyle(color: Colors.white),
                      ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade700)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.grey.shade900,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.grey.shade900),
        excludeHeaderSemantics: true,
        toolbarHeight: 0.0,
        backgroundColor: Colors.grey.shade900,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey.shade900,
      body: create(),
    );
  }
}

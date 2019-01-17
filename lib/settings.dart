import 'package:flutter/material.dart';

class Settings extends StatefulWidget {

  var currencies;
  var chosenCurrencies;

  Settings(this.currencies, this.chosenCurrencies);


  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

//  @override
//  void initState() {
//    currencies = ["aud", "cny", "idr", "eur", "jpy", "gbp", "nzd", "sgd"];
//    chosenCurrencies = ["aud", "cny", "eur"];
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: ListView(
          children: <Widget>[
            Container(
              height: 60.0,
              child: IconButton(icon: Icon(const IconData(0xe5e0, fontFamily: 'MaterialIcons')), alignment: Alignment(-1, 1), onPressed: (){ Navigator.pop(context);}),
            ),
            GridView.builder(
              itemCount: widget.currencies.length,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.65),
              itemBuilder: (BuildContext context, int index) {
                bool selected = false;

                for(var i=0; i<widget.chosenCurrencies.length; i++) {
                  if (widget.chosenCurrencies[i] == widget.currencies[index]) {
                    selected = true;
                  } else {};
                }

                return SelectBox(widget.currencies[index], selected);
              },
            ),
          ],
        ),
      ),
    );
  }
}


class SelectBox extends StatefulWidget {
  final String currency;
  bool selected;
  SelectBox(this.currency, this.selected);

  @override
  _SelectBoxState createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){ setState((){
        widget.selected = !widget.selected;
      });},
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: new BoxDecoration(
          color: widget.selected ? const Color(0xFF464646) : const Color(0xFFD8D8D8),
          borderRadius: new BorderRadius.all(const Radius.circular(11)),
        ),
        height: 106,
        width: 74,
        child: Column(
          children: <Widget>[
            Container(height: 20,),
            Image.asset(
              "assets/pngflags/${widget.currency}.png",
              height: 38,
              width: 38,
            ),
            Container(height: 20,),
            Text(
              widget.currency,
              style: TextStyle(color: widget.selected ? const Color(0xFFFFFFFF) : const Color(0xFF878787), fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}


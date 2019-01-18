
import './blocs/bloc_provider.dart';
import './blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'settings.dart';

FocusNode _nodeText1 = FocusNode();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exchange',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currencies;
  var allCurrencies = [];
  double value;
  var exchangeRate;

  Future fetchRates() async {
    final response =
        await http.get('https://api.exchangeratesapi.io/latest?base=USD');
    print("waiting...");
    if (response.statusCode == 200) {
      print("got response");
      print(response.body);
      setState(() {
        exchangeRate = json.decode(response.body);
      });

      var items = exchangeRate["rates"] as Map;
      for (var key in items.keys) {
        setState(() {
          allCurrencies.add(key.toLowerCase());
        });
      }
      print(allCurrencies);
    } else {
      throw Exception('cant get exchange rates');
    }
  }

  void setValue(_value, _index) {
    setState(() {
      print("setState called with ${_value}");
      value = double.parse(_value) /
          exchangeRate["rates"][currencies[_index].toUpperCase()];
      print("setState finished");
    });
  }

  @override
  void initState() {
    print("1");
    currencies = ["aud", "cny"];
    value = 1;
    print("2");
    fetchRates();
    super.initState();
    print("3");
  }

  @override
  Widget build(BuildContext context) {
    print("4");
    final StateBloc appBloc = BlocProvider.of<StateBloc>(context);
    print("5");
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ListView(
          children: <Widget>[
            Container(
              height: 60.0,
              child: IconButton(
                icon: Icon(const IconData(0xe8b8, fontFamily: 'MaterialIcons')),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Settings(allCurrencies, currencies)));
                },
                alignment: Alignment(0.95, 0.5),
                color: const Color(0xFF464646),
              ),
            ),
//            StreamBuilder<double>(
//              stream: appBloc.usdValue,
//              initialData: 1,
//              builder: (context, snapshot) => GridView.builder(
//                itemCount: currencies.length,
//                shrinkWrap: true,
//                primary: false,
//                padding: const EdgeInsets.all(20),
//                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: 2,
//                  crossAxisSpacing: 28.0,
//                  childAspectRatio: 0.65,
//                ),
//                itemBuilder: (BuildContext context, int index) {
//                  if (exchangeRate != null) {
//                    print(snapshot.data);
//                    double convertedValue = snapshot.data *
//                        exchangeRate["rates"][currencies[index].toUpperCase()];
//                    return CurrencyBox(convertedValue, currencies[index],
//                            (_value, _index) => setValue(_value, _index), index);
//                  } else {
//                    print("no exchange rate in state");
//                  }
//                },
//              ),
//            ),

            Container(
              height: 80.0,
            ),
            Container(
              height: 25.0,
              child: Image.asset(
                'assets/logo.png',
                width: 25.0,
              ),
            ),
            Container(
              height: 10.0,
            ),
            Text(
              'designed with coffee and love \n in a Ubud bungalow \n \n \n',
              style: TextStyle(color: const Color(0xFFA1A1A1), fontSize: 10.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyBox extends StatelessWidget {
  final double value;
  final String flag;
  final Function onValueChange;
  final int index;

  CurrencyBox(this.value, this.flag, this.onValueChange, this.index);

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {

//    final Bloc appBloc = BlocProvider.of<Bloc>(context);

    myController.text = '${value.toStringAsFixed(1)}';
//    myController.text = '${value}';

    return Container(
      margin: const EdgeInsets.only(bottom: 30.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(const Radius.circular(23.0)),
        color: const Color(0xFF464646),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 150.0,
//            height: 24.0,
            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Image.asset(
              "assets/pngflags/${flag}.png",
              height: 20.0,
              width: 20.0,
              alignment: Alignment(-1, 1),
            ),
          ),
          Text('${flag}',
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              )),
          Container(
            height: 40.0,
          ),
          Container(
            width: 120,
            child: TextField(
//              onChanged: (text){
//                print("changed to $text");
//                this.onValueChange(text, index);
//              },
//              onSubmitted: (value) {
//                this.onValueChange(value, index);
//              },

              onSubmitted: (value){
//                appBloc.valueChanged.add(double.parse(value));
              },

              controller: myController,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: 18,
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}

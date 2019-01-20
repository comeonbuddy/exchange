import 'package:exchange/loading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import './blocs/bloc_provider.dart';
import './blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'settings.dart';

FocusNode _nodeText1 = FocusNode();

Future<void> main() async{
  return runApp(
    BlocProvider<StateBloc>(
        child: MyApp(),
        bloc: StateBloc(),
    ),
  );
}

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

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  var currencies;

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
                          builder: (context) => Settings()));
                },
                alignment: Alignment(0.95, 0.5),
                color: const Color(0xFF464646),
              ),
            ),

            StreamBuilder(
              stream: appBloc.usdValue,
              initialData: 1,
              builder: (context, usdValueSnapshot) => StreamBuilder(
                stream: appBloc.getExchangeRates,
                builder: (context, exchangeRatesSnapshot) => StreamBuilder(
                  stream: appBloc.getSelectedCurrencies,
                  builder: (context, selectedCurrenciesSnap) {
                    if(selectedCurrenciesSnap.hasData && exchangeRatesSnapshot.hasData && usdValueSnapshot.hasData){

                      return StaggeredGridView.countBuilder(
                          itemCount: selectedCurrenciesSnap.data.length,
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.all(20),
                          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 20.0,

                          itemBuilder: (context, int index) {
                            double convertedValue = usdValueSnapshot.data *
                                exchangeRatesSnapshot
                                    .data["rates"][selectedCurrenciesSnap
                                    .data[index].toUpperCase()];
                            return CurrencyBox(
                                convertedValue,
                                selectedCurrenciesSnap.data[index],
                                exchangeRatesSnapshot.data["rates"][selectedCurrenciesSnap.data[index].toUpperCase()]
                            );
                          });
                    } else {
                      return Loading();
                    }
                  }
                ),
              ),
            ),

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
  final double rate;

  CurrencyBox(this.value, this.flag, this.rate);

  final myController = TextEditingController();

  @override
  Widget build(context) {

    final StateBloc appBloc = BlocProvider.of<StateBloc>(context);

    myController.text = '${value.toStringAsFixed(1)}';

    return Container(
//      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(const Radius.circular(23.0)),
        color: const Color(0xFF464646),
      ),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment(-1, 1),
            margin: const EdgeInsets.only(top: 20.0, bottom: 10, left:10.0),
            child: Image.asset(
              "assets/pngflags/${flag}.png",
              height: 30,
              width: 30,
            ),
          ),
          Text('${flag}',
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: 42.0,
                fontWeight: FontWeight.bold,
              )),
          Container(
            height: 10.0,
          ),
          Container(
            width: 120,
            child: TextField(
                  onSubmitted: (value){
                    appBloc.valueChanged.add(double.parse(value)/rate);
                  },

                  controller: myController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFFFFFFF),
                    fontSize: 25,
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
          ),
          Container(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}

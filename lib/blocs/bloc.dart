import 'dart:async';
import 'dart:convert';
import 'package:exchange/blocs/bloc_provider.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateBloc implements BlocBase {

  var selectedCurrencies;


  StreamController<double> _usdValueController = StreamController<double>.broadcast();
  Stream<double> get usdValue => _usdValueController.stream;
  StreamSink get valueChanged => _usdValueController.sink;

  StreamController _exchangeRates = StreamController.broadcast();
  Stream get getExchangeRates => _exchangeRates.stream;
  StreamSink get _addExchangeRates => _exchangeRates;


  StreamController _allCurrencies = BehaviorSubject();
  ValueObservable get getAllCurrencies => _allCurrencies.stream;
  StreamSink get addAllCurrencies => _allCurrencies.sink;

  StreamController _selectedCurrencies = BehaviorSubject();
  ValueObservable get getSelectedCurrencies => _selectedCurrencies.stream;
  StreamSink get modifySelectedCurrencies => _selectedCurrencies.sink;


  StreamController _modifyCurrency = StreamController.broadcast();
  Stream get _modifiedCurrency => _modifyCurrency.stream;
  StreamSink get changeCurrency => _modifyCurrency.sink;

  StateBloc() {
    initialize();
    _modifiedCurrency.listen(_onCurrencyChanged);
  }

  Future _onCurrencyChanged(currency) async {

    if(selectedCurrencies.contains(currency)){
      selectedCurrencies.remove(currency);
    } else {
      selectedCurrencies.add(currency);
    }

    modifySelectedCurrencies.add(selectedCurrencies);
    print("updated currencies are ${selectedCurrencies}");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("userSavedCurrencies", selectedCurrencies);
  }

  Future initialize() async {

    //fetch rates
    final response = await http.get('https://api.exchangeratesapi.io/latest?base=USD');
    print("waiting...");
    if (response.statusCode == 200) {
      print("got response - ${response.body}");

      var exchangeRates = json.decode(response.body);
      var allCurrencies = [];

      _addExchangeRates.add(exchangeRates);
      print("exchange rate updated");

      var items = exchangeRates["rates"] as Map;
      for (var key in items.keys) {
          allCurrencies.add(key.toLowerCase());
      }
      print(allCurrencies);
      addAllCurrencies.add(allCurrencies);
    } else {
      throw Exception('cant get exchange rates');
    };

    //get selected currencies from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List savedCurrencies = prefs.getStringList("userSavedCurrencies");
    selectedCurrencies = savedCurrencies??['cny','aud','usd'];

    //define selected currencies
//    selectedCurrencies = ['cny','aud','usd'];
    modifySelectedCurrencies.add(selectedCurrencies);
    print('selected currencies inititated');

  }


  void dispose(){
    _usdValueController.close();
    _exchangeRates.close();
    _selectedCurrencies.close();
    _modifyCurrency.close();
    _allCurrencies.close();
  }
}
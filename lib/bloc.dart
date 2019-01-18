import 'dart:async';

class Bloc implements BaseBloc {
  final _usdValueController = StreamController<double>();
  final _customCurrencyController = StreamController<List>();

  Stream<double> get usdValue => _usdValueController.stream;
  Stream<List> get customCurrency => _customCurrencyController.stream;

  Function(double) get valueChanged => _usdValueController.sink.add;
  Function(List) get customCurrencyChanged => _customCurrencyController.sink.add;

  

  @override
  void dispose(){
    _usdValueController?.close();
    _customCurrencyController?.close();
  }

}

abstract class BaseBloc {
  void dispose();
}
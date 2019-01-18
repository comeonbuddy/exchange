import 'dart:async';
import 'package:exchange/blocs/bloc_provider.dart';

class StateBloc implements BlocBase {

  StreamController<double> _usdValueController = StreamController<double>.broadcast();
  Stream<double> get usdValue => _usdValueController.stream;
  StreamSink get valueChanged => _usdValueController.sink;


  void dispose(){
    _usdValueController.close();
  }
}
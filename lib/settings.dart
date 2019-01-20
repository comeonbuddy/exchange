import 'package:exchange/blocs/bloc.dart';
import 'package:exchange/blocs/bloc_provider.dart';
import 'package:exchange/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class Settings extends StatelessWidget {

  @override
  Widget build(context) {

    final StateBloc appBloc = BlocProvider.of<StateBloc>(context);
    print(appBloc);

    return Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: ListView(
          children: <Widget>[
            Container(
              height: 60.0,
              child: IconButton(icon: Icon(const IconData(0xe5e0, fontFamily: 'MaterialIcons')), alignment: Alignment(-1, 1), onPressed: (){ Navigator.pop(context);}),
            ),
            StreamBuilder(
                stream: appBloc.getAllCurrencies,
                initialData: appBloc.getAllCurrencies.value,
                builder: (context, allCurrenciesSnap) => StreamBuilder(
                    stream: appBloc.getSelectedCurrencies,
                    initialData: appBloc.getSelectedCurrencies.value,
                    builder: (context, selectedCurrenciesSnap) {
                      print('alllll --> ${allCurrenciesSnap.data}');
                      print('selecteddd --> ${selectedCurrenciesSnap.data}');


                      if (allCurrenciesSnap.hasData || selectedCurrenciesSnap.hasData) {

                        return StaggeredGridView.countBuilder(
                          itemCount: allCurrenciesSnap.data.length,
                          physics: ScrollPhysics(),
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(15),
                          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
//                          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                              crossAxisCount: 4,
//                              crossAxisSpacing: 15,
//                              childAspectRatio: 0.6),
                          itemBuilder: (BuildContext context, int index) {
                            bool selected = false;

                            for(var i=0; i<selectedCurrenciesSnap.data.length; i++) {
                              if (selectedCurrenciesSnap.data[i] == allCurrenciesSnap.data[index]) {
                                selected = true;
                              }
                            }
                            return SelectBox(allCurrenciesSnap.data[index], selected);
                          },
                        );

                      } else {
                        return Loading();
                      }
                    }
                )
            ),
          ],
        ),
      );
  }
}


class SelectBox extends StatelessWidget {
  final String currency;
  final bool selected;
  SelectBox(this.currency, this.selected);

  @override
  Widget build(BuildContext context) {

    final StateBloc appBloc = BlocProvider.of<StateBloc>(context);

    return GestureDetector(
      onTap: (){
        appBloc.changeCurrency.add(currency);
        print("tabbed");
      },
      child: Container(
        decoration: new BoxDecoration(
          color: selected ? const Color(0xFF464646) : const Color(0xFFD8D8D8),
          borderRadius: new BorderRadius.all(const Radius.circular(11)),
        ),
        child: Column(
          children: <Widget>[
            Container(height: 20,),
            Image.asset(
              "assets/pngflags/${currency}.png",
              height: 38,
              width: 38,
            ),
            Container(height: 10,),
            Text(
              currency,
              style: TextStyle(color: selected ? const Color(0xFFFFFFFF) : const Color(0xFF878787), fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Container(height: 20,),
          ],
        ),
      ),
    );
  }
}


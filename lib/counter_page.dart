import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_reactions/counter_controller.dart';

class CounterPage extends StatefulWidget {
  CounterPage({Key key}) : super(key: key);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final controller = CounterController();
  List<ReactionDisposer> disposers = [];

  @override
  void initState() {
    super.initState();
    disposers = [
      // Sempre acontece quando o valor da primeira função for atingido
      reaction<bool>(
        (r) => controller.counter % 2 == 0,
        (isEven) {
          return Fluttertoast.showToast(
              msg: 'É par!',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        },
      ),

      // Sempre retorna um booleano e somente uma vez
      when(
        (r) => controller.counter >= 10,
        () => Fluttertoast.showToast(
            msg: 'É maior, ou igual, a dez',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0),
      ),

      // Roda sempre que o observable mudar, inclusive no 0
      autorun(
        (r) => Fluttertoast.showToast(
            msg: "${controller.counter}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0),
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    disposers.forEach((dispose) => dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MobX Reactions @ Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Observer(builder: (_) {
              return Text(
                '${controller.counter}',
                style: Theme.of(context).textTheme.headline4,
              );
            }),
            Text(
              'The button plus 2 is:',
            ),
            Observer(builder: (_) {
              return Text(
                '${controller.totalCounter}',
                style: Theme.of(context).textTheme.headline4,
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

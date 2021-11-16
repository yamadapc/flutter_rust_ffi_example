import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust_ffi_example/rust_bindings.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppLayout();
  }
}

class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MacosApp(
        home: MacosWindow(
      sidebar: Sidebar(
          minWidth: 200,
          topOffset: 0,
          builder: (context, controller) {
            return SidebarItems(
                currentIndex: currentIndex,
                onChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                items: const [
                  SidebarItem(label: Text("Main")),
                  SidebarItem(label: Text("Development")),
                  SidebarItem(label: Text("Settings")),
                  SidebarItem(label: Text("About")),
                ]);
          }),
      child: IndexedStack(
          index: 0,
          children: const [MyHomePage(title: 'Flutter Demo Home Page')]),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MacosScaffold(
      titleBar: const TitleBar(title: Text("macOS")),
      children: [
        ContentArea(
          builder: (buildContext, container) {
            return Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'Click the button to reload rust library',
                  ),
                  ButtonsRow()
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

class ButtonsRow extends StatefulWidget {
  const ButtonsRow({
    Key? key,
  }) : super(key: key);

  @override
  State<ButtonsRow> createState() => _ButtonsRowState();
}

class _ButtonsRowState extends State<ButtonsRow> {
  DynamicLibrary? library;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CupertinoButton(
          child: const Text("Reload rust library"),
          onPressed: () {
            onClickReload();
          }),
      CupertinoButton(
          child: const Text("Run rust function"),
          onPressed: () {
            onClickRun();
          })
    ], mainAxisAlignment: MainAxisAlignment.center);
  }

  void onClickReload() {
    setState(() {
      library = DynamicLibrary.open(
          "/Users/yamadapc/projects/flutter_rust_ffi_example/target/debug/libflutter_rust_ffi_example.dylib");
    });
  }

  void onClickRun() {
    var lib = library;
    if (lib == null) {
      return;
    }

    var rustLib = RustBinding(lib);
    rustLib.hello_world();
  }
}

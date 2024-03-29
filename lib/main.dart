import 'package:english_words/english_words.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
// import 'dart:io'

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'flutter_application_1',
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFEED8D8),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFEC0F0F)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}


class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
        favorites.remove(current);
    }else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build (BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = AskAIPage();
        break;
      case 2:
        page = LocatePage();
        break;
      default:
      throw UnimplementedError('No widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
              body: SafeArea(
                child: page
                // child: Container(
                //   color: Theme.of(context).colorScheme.primaryContainer,
                //   child: page(),
                // ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.question_answer),
                    label: 'Ask AI',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.location_on),
                    label: 'Locate',
                  ),
                ],
                currentIndex: selectedIndex,
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                  print('selected: $value');
                },
            ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var currentPair = appState.current;
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge!.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

    IconData icon;
    if (appState.favorites.contains(currentPair)) {
      icon = Icons.favorite; 
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A random fucked up idea:', style: style,),
            SizedBox(height: 5,),
            BigCard(currentPair: currentPair),
            SizedBox(height: 15,),
        
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('button clicked');
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
                
                SizedBox(width: 10,),

                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                    print('Liked');
                  }, 
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.currentPair,
  });

  final WordPair currentPair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.onSurface,
      fontWeight: FontWeight.w700,
      fontSize: 30.0
    );

    return Card(
      elevation: 6,
      color : theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          currentPair.asPascalCase, 
          semanticsLabel: "${currentPair.first} ${currentPair.second}", 
          style: style,),
      ),
    );
  }
}

class LocatePage extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 20,
    );

    final listStyle = theme.textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 13,
    );

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet', style: style,),
      );
    }
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: Text('You have ${appState.favorites.length} favorites:', style: style,),
        ),

        for(var currentPair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(currentPair.asPascalCase,style: listStyle,),
          ),
      ],
    );
  }
}

class AskAIPage extends StatefulWidget {
  @override
  State<AskAIPage> createState() => _AskAIPageState();
}

class _AskAIPageState extends State<AskAIPage> {

  final _formKey = GlobalKey<FormState>();
  var _userInput;

  @override
  Widget build (BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 20,
      color: Color(0xFF109758),
    );
    // var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Ask AI", style: style,)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        // alignment: Alignment.,
                        child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              print('$_userInput');
                            }
                          },
                          // child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ask me a question...',
                    ),
                    validator: (value) {
                      if(value!.isEmpty) {
                        return ('Ask me anything!');
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userInput = value;
                    },
                  ),
                  // SizedBox(height: 15,),
                ],
              ),
            )
          ),
        ]   
      )   
    );
  }
}

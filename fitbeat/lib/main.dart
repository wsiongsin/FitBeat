import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/cupertino.dart';
import './screens/exercises_screen.dart';
import './screens/home_screen.dart';
import './screens/history_screen.dart';
import './screens/music_screen.dart';
import './screens/start_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'FitBeat', 
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      home: HomePage(routeObserver: routeObserver),
      theme: ThemeData(colorScheme: ColorSchemes.lightSlate(), radius: 1.1,
      surfaceBlur: 19,),
    
    );
  //  return const CupertinoApp(
  //     title: 'FitBeat', 
  //     debugShowCheckedModeBanner: false,
  //     theme: CupertinoThemeData(
  //       primaryColor: Color.fromARGB(255, 0, 64, 221),
  //     ),
  //     home: HomePage(),
  //   );
  }
  
}

class HomePage extends StatefulWidget {

  final RouteObserver<PageRoute> routeObserver;

  const HomePage({required this.routeObserver, super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int _selectedIndex = 0;
  bool _isNavBarVisible = true;

  late List<Widget> screens;


  void showNavbar() {
    setState(() {
      _isNavBarVisible = true;
    });
  }

  void hideNavbar() {
    setState(() {
      _isNavBarVisible = false;
    });
  }


@override void initState() {
  super.initState();
  screens  = [
    HomeScreen(),
    HistoryScreen(),
    StartScreen(showNavbar: showNavbar, hideNavbar: hideNavbar),
    ExercisesScreen(),
    MusicScreen(),
  ];
}


  

NavigationBarAlignment alignment = NavigationBarAlignment.spaceAround;
bool expands = false;
NavigationLabelType labelType = NavigationLabelType.none;
bool customButtonStyle = true;


NavigationButton buildButton(String label, IconData icon) {
  return NavigationButton(
    style: customButtonStyle
        ? const ButtonStyle.muted(density: ButtonDensity.icon)
        : null,
    selectedStyle: customButtonStyle
        ? const ButtonStyle.fixed(density: ButtonDensity.icon)
        : null,
    label: Text(label),
    child: Icon(icon),
  );
}

@override
Widget build(BuildContext context) {


return
    SizedBox(
    width: 500,
    height: 400,
    child: Scaffold(
      footers: _isNavBarVisible ? [
        const Divider(),
        NavigationBar(
          alignment: alignment,
          labelType: labelType,
          expands: expands,
          onSelected: (index) {
            if (mounted) {
            setState(() {
            _selectedIndex = index;
          });
      }},
            index: _selectedIndex,
          children: [
            buildButton('Home', BootstrapIcons.house),
            buildButton('History', BootstrapIcons.clockHistory),
            buildButton('Start', BootstrapIcons.plusCircle),
            buildButton('Exercises', BootstrapIcons.activity),
            buildButton('Music', BootstrapIcons.musicNote),
          ],
        ),
      ] : [],
         // Use CupertinoTabView for the main body content
    child: SafeArea(
      child: CupertinoTabView(
        builder: (BuildContext context) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // Align buttons in a row
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.bell),
                    onPressed: () {
                      // TODO: Navigate to notification screen
                    },
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.profile_circled),
                    onPressed: () {
                      // TODO: Navigate to profile screen
                    },
                  ),
                ],
              ),
            ),
            child: SafeArea(
              // Render the currently selected screen
              child: screens[_selectedIndex],
            ),
          );
        },
      )
    )
  ));
}
}

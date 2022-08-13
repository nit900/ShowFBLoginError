import 'package:flutter/material.dart';
import 'package:mirror_on_the_wall/succesful_logged_in_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: MyHomePage.routeName,
      routes: {
        MyHomePage.routeName: (context) =>
            const MyHomePage(title: 'Mirror On The Wall Login Screen'),
        SuccessfulLoggedInScreen.routeName: (context) =>
            const SuccessfulLoggedInScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const String routeName = '/FlutterDemoLoginScreen';
  static UserModel? currentUser;
  static AccessToken? accessToken;
  static Future<void> SignOut() async {
    await FacebookAuth.i.logOut();
    MyHomePage.currentUser = null;
    MyHomePage.accessToken = null;
  }

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
  bool errorLogging = false;

  Future<void> SignIn() async {
    final LoginResult result = await FacebookAuth.i.login();
    print(result.status);
    if (result.status == LoginStatus.success) {
      errorLogging = false;
      MyHomePage.accessToken = result.accessToken;
      print('${MyHomePage.accessToken} got from token');

      final data = await FacebookAuth.i.getUserData();
      print('Got user data: $data');
      UserModel model = UserModel.fromJson(data);

      MyHomePage.currentUser = model;

      setState(() {});
      Navigator.pushNamed(context, SuccessfulLoggedInScreen.routeName);
    } else {
      setState(() {
        errorLogging = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool tryingLoggin = false;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: tryingLoggin != false
            ? const SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CircularProgressIndicator(),
              )
            : errorLogging != true
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      setState(() {
                        tryingLoggin = true;
                        print(tryingLoggin);
                      });
                      await SignIn();
                    },
                    label: const Text('Login with facebook'),
                  )
                : GestureDetector(
                    onTap: () {
                      errorLogging = false;
                      MyHomePage.currentUser = null;
                    },
                    child: const Text(
                      'There was an error logging in',
                      style: TextStyle(fontSize: 30, color: Colors.red),
                    ),
                  ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class UserModel {
  final String? email;
  final String? id;
  final String? name;
  final PictureModel? pictureModel;
  const UserModel({this.email, this.id, this.name, this.pictureModel});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'],
        id: json['id'] as String?,
        email: json['email'],
        pictureModel: PictureModel.fromJson(
          json['picture']['data'],
        ),
      );
}

class PictureModel {
  final String? url;
  final int? width;
  final int? height;
  const PictureModel({this.url, this.width, this.height});

  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
      url: json['url'], width: json['width'], height: json['height']);
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mirror_on_the_wall/main.dart';

class SuccessfulLoggedInScreen extends StatefulWidget {
  static const String routeName = '/successful_logged_in_screen';
  const SuccessfulLoggedInScreen({Key? key}) : super(key: key);

  @override
  State<SuccessfulLoggedInScreen> createState() =>
      _SuccessfulLoggedInScreenState();
}

class _SuccessfulLoggedInScreenState extends State<SuccessfulLoggedInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,
      appBar: AppBar(
        title: const Text('Main Page Of Mirror Screen'),
        leading: GestureDetector(
          onTap: () async {
            await MyHomePage.SignOut();
            Navigator.pop(context);
          },
          child: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(child: _buildWidget()),
    );
  }
}

Widget _buildWidget() {
  UserModel? user = MyHomePage.currentUser;
  if (user != null) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: user.pictureModel!.width! / 6,
              backgroundImage: NetworkImage(user.pictureModel!.url!),
            ),
            title: Text(user.name!),
            subtitle: Text(user.email!),
          ),
        ],
      ),
    );
  }
  return Center(
    child: GestureDetector(
      onTap: () {
        print(MyHomePage.accessToken);
      },
      child: Text(
        'You are not logged in',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

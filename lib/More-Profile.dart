import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_diet_diary/User_input/GeneralInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataObjects/DatabaseHelper.dart';
import 'DataObjects/User.dart';
import 'User_input/GeneralInfo.dart';

class Profile_Section extends StatefulWidget {
  @override
  _Profile_SectionState createState() => _Profile_SectionState();
}

class _Profile_SectionState extends State<Profile_Section> {
  static const TextStyle generalStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  static TextStyle titleStyle = TextStyle(fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.w600);
  static TextStyle subTitleStyle = TextStyle(fontSize: 16, color: Colors.grey[600]);

  Future userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = _getUserFuture();
  }

  _getUserFuture() async {
    DatabaseHelper dbHelper = new DatabaseHelper();
    SharedPreferences sp = await SharedPreferences.getInstance();

    int currentUserID = sp.getInt("currentUserID");
    return await dbHelper.getUserByID(currentUserID);
  }

  Widget buildProfile(User user) {
    return SingleChildScrollView(
      child: ListView(physics: NeverScrollableScrollPhysics(), shrinkWrap: true, children: [
        SizedBox(height: 30),
        Card(
          elevation: 0.25,
          child: Padding(
            padding: EdgeInsets.only(left: 25, top: 15, right: 25),
            child: Column(
              children: [
                Text("General Information",
                    style: TextStyle(fontSize: 20, color: Colors.grey[700], fontWeight: FontWeight.w600)),
                SizedBox(height: 10),
                ListTile(
                    contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    leading: const Icon(Icons.today),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Age', style: titleStyle),
                        Text((user.age).toString(), style: subTitleStyle)
                      ],
                    )),
                Divider(height: 3),
                ListTile(
                    contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    leading: const Icon(FontAwesomeIcons.tape),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Height', style: titleStyle),
                        Text((user.height).toString() + "cm", style: subTitleStyle)
                      ],
                    )),
                Divider(height: 3),
                ListTile(
                    contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    leading: const Icon(FontAwesomeIcons.weight),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Weight', style: titleStyle),
                        Text((user.weight).toString() + "kg", style: subTitleStyle)
                      ],
                    )),
                Divider(height: 3),
                ListTile(
                    contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    leading: const Icon(FontAwesomeIcons.venusMars),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Gender', style: titleStyle),
                        Text((user.gender).toString(), style: subTitleStyle)
                      ],
                    )),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  leading: const Icon(FontAwesomeIcons.chartLine),
                  title: Text('Activity Level', style: titleStyle),
                  subtitle: Text(user.activityLevel, style: subTitleStyle),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          elevation: 0.25,
          child: Padding(
            padding: EdgeInsets.only(left: 25, top: 15, right: 25),
            child: Column(children: [
              Text("Goals", style: TextStyle(fontSize: 20, color: Colors.grey[700], fontWeight: FontWeight.w600)),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                leading: const Icon(FontAwesomeIcons.bullseye),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Goal', style: titleStyle),
                    Text((user.goal).toString(), style: subTitleStyle)
                  ],
                ),
              ),
              Divider(height: 3),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                leading: const Icon(FontAwesomeIcons.utensils),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Calorie Goal', style: titleStyle),
                    Text((user.dailyIntake).toStringAsFixed(0) + " kcal", style: subTitleStyle)
                  ],
                ),
              ),
              Divider(height: 3),
              user.targetDays != null
                  ? ListTile(
                      contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      leading: const Icon(FontAwesomeIcons.calendarDay),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Target Days', style: titleStyle),
                          Text((user.targetDays).toString(), style: subTitleStyle)
                        ],
                      ),
                    )
                  : new Container(width: 0, height: 0),
              Divider(height: 3),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                leading: const Icon(FontAwesomeIcons.weight),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Weight Goal', style: titleStyle),
                    Text((user.targetWeight).toString() + "kg", style: subTitleStyle)
                  ],
                ),
              )
            ]),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ]),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 26.0,
              width: 26.0,
              child: IconButton(
                padding: new EdgeInsets.all(0.0),
                iconSize: 26,
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Text(
              'Profile',
              style: generalStyle,
            ),
            SizedBox(
              height: 26.0,
              width: 26.0,
              child: IconButton(
                padding: new EdgeInsets.all(0.0),
                iconSize: 26,
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralInfo_Section()));
                },
              ),
            )
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Container(
          child: FutureBuilder(
              future: userFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  default:
                    if (snapshot.hasError) return Text("Error " + snapshot.error.toString());
                    return buildProfile(snapshot.data);
                }
              })),
    );
  }
}

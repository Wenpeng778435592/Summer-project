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
  static const TextStyle generalStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const TextStyle buttonStyle =
      TextStyle(fontSize: 18, color: Colors.black);

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
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Profile", style: generalStyle),
                OutlinedButton(
                    child: Text("Edit", style: buttonStyle),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GeneralInfo_Section()));
                    })
              ]),
              SizedBox(
                height: 40,
              ),
              Row(children: [Text("General Information", style: buttonStyle)]),
              Divider(
                height: 15,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(Icons.today),
                title: const Text('Age'),
                subtitle: new Text((user.age).toString()),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.tape),
                title: const Text('Height'),
                subtitle: new Text((user.height).toString() + " cm"),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.weight),
                title: const Text('Weight'),
                subtitle: new Text((user.weight).toString() + " kg"),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.venusMars),
                title: const Text('Gender'),
                subtitle: new Text(user.gender),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.chartLine),
                title: const Text('Activity Level'),
                subtitle: new Text(user.activityLevel),
              ),
              SizedBox(
                height: 40,
              ),
              Row(children: [Text("Goals", style: buttonStyle)]),
              Divider(
                height: 15,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.bullseye),
                title: const Text('Goal'),
                subtitle: new Text((user.goal).toString()),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.utensils),
                title: const Text('Calorie Goal'),
                subtitle: new Text((user.calorieGoal).toString()),
              ),
              user.targetDays != null
                  ? ListTile(
                      leading: const Icon(FontAwesomeIcons.calendarDay),
                      title: const Text('Target Days'),
                      subtitle: new Text((user.targetDays).toString()),
                    )
                  : new Container(width: 0, height: 0),
              ListTile(
                leading: const Icon(FontAwesomeIcons.weight),
                title: const Text('Weight Goal'),
                subtitle: new Text((user.targetWeight).toString() + " kg"),
              )
            ]));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            Text('Profile',
              style: generalStyle,),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_outlined),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralInfo_Section()));

              },
            ),
          ],
        ),
        backgroundColor: Colors.amber[800],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          
          Container(
            padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
            child: RaisedButton(
            child:Text('View User Information', style: generalStyle,),
            color: Colors.amber,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralInfo_Section()));
            },
        ),
          ),
        ],

      ),

    );
  }
}





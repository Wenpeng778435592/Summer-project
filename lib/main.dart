import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home()
  ));//MyApp is a widget/class
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today'),
        centerTitle: false,
        backgroundColor: Colors.amber[600],
      ),
      body: Center(
        child: Image(
          // image: AssetImage('assets/sample_1.jpg')
          image: NetworkImage('https://images.unsplash.com/photo-1531113463068-6f334622d795?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80')
        ),
        // child: Icon(
        //   Icons.ac_unit,
        //   color: Colors.lightBlue,
        //   size: 50,
        // ),
        // child: RaisedButton.icon(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.access_alarm_rounded
        //   ),
        //   label: Text('alarm'),
        //   color: Colors.amber[600],
        // ),
        // child: IconButton(
        //   onPressed: () {
        //     print('hello there');
        //   },
        //   icon: Icon(Icons.account_balance_outlined),
        //   color: Colors.amber[600],
        // )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              backgroundColor: Colors.deepOrangeAccent
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              title: Text('Food'),
              backgroundColor: Colors.deepOrangeAccent
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.line_weight),
              title: Text('Weight'),
              backgroundColor: Colors.deepOrangeAccent
          ),

        ],

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Text(
          '+',
          style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.black
    ),
        ),backgroundColor: Colors.amber[600],
    ),
    );
  }
}



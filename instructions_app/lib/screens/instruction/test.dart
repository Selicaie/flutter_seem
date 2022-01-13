import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter TabBar',
      home: new Home(),
      theme: new ThemeData(primaryColor: Colors.black),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    tabController = new TabController(length: 2, vsync: this);

    var tabBarItem = new TabBar(
      tabs: [
        new Tab(
          icon: new Icon(Icons.list),
        ),
        new Tab(
          icon: new Icon(Icons.grid_on),
        ),
      ],
      controller: tabController,
      indicatorColor: Colors.white,
    );

    var listItem = new ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: new Card(
            elevation: 5.0,
            child: new Container(
              alignment: Alignment.center,
              margin: new EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: new Text("ListItem $index"),
            ),
          ),
          onTap: () {
            // showDialog(
            //     barrierDismissible: false,
            //     context: context,
            //     //child: 
            //     // new CupertinoAlertDialog(
            //     //   title: new Column(
            //     //     children: <Widget>[
            //     //       new Text("ListView"),
            //     //       new Icon(
            //     //         Icons.favorite,
            //     //         color: Colors.red,
            //     //       ),
            //     //     ],
            //     //   ),
            //     //   content: new Text("Selected Item $index"),
            //     //   actions: <Widget>[
            //     //     new FlatButton(
            //     //         onPressed: () {
            //     //           Navigator.of(context).pop();
            //     //         },
            //     //         child: new Text("OK"))
            //     //   ],
            //     ));
          },
        );
      },
    );

    var gridView = new GridView.builder(
        itemCount: 20,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
            child: new Card(
              elevation: 5.0,
              child: new Container(
                alignment: Alignment.center,
                child: new Text('Item $index'),
              ),
            ),
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                // child: new CupertinoAlertDialog(
                //   title: new Column(
                //     children: <Widget>[
                //       new Text("GridView"),
                //       new Icon(
                //         Icons.favorite,
                //         color: Colors.green,
                //       ),
                //     ],
                //   ),
                //   content: new Text("Selected Item $index"),
                //   actions: <Widget>[
                //     new FlatButton(
                //         onPressed: () {
                //           Navigator.of(context).pop();
                //         },
                //         child: new Text("OK"))
                //   ],
                // ),
              );
            },
          );
        });

    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Flutter TabBar"),
          bottom: tabBarItem,
        ),
        body: new TabBarView(
          controller: tabController,
          children: [
            listItem,
            gridView,
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:instructions_app/data/rest_ds.dart';
// import 'package:instructions_app/models/instructionList.dart';
// import 'package:instructions_app/models/instructions.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:toast/toast.dart';


// class UserInstructionsPage extends StatefulWidget {
//   UserInstructionsPage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _UserInstructionsPageState createState() => _UserInstructionsPageState();
// }

// class _UserInstructionsPageState extends State<UserInstructionsPage> {

//   // Future object to fetch response from API (Response in future)
//   Future<InstructionListModel> instructionListFuture;
//   String id ;
//   bool admin;
//   @override
//   Widget build(BuildContext context) {
  
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: Container(
//           padding: const EdgeInsets.all(16.0),
//           child: FutureBuilder<InstructionListModel>(
//               future: instructionListFuture,
//               builder: (context, snapshot) {
//                 // to show progress loading view add switch statment to handle connnection states.
//                 switch (snapshot.connectionState) {
//                   case ConnectionState.waiting:
//                     {
//                       // here we are showing loading view in waiting state.
//                       return loadingView();
//                     }
//                   case ConnectionState.active:
//                     {
//                       break;
//                     }
//                   case ConnectionState.done:
//                     {
//                       // in done state we will handle the snapshot data.
//                       // if snapshot has data show list else set you message.
//                       if (snapshot.hasData) {
//                         // hasdata same as data!=null
//                         if (snapshot.data.intructionList != null) {
//                           if (snapshot.data.intructionList.length> 0) {
//                             // here inflate data list
//                             return ListView.builder(
//                                 itemCount: snapshot.data.intructionList.length,
//                                 itemBuilder: (context, index) {
//                                   return generateColum(
//                                       snapshot.data.intructionList[index],index);
//                                 });
//                           } else {
//                             // display message for empty data message.
//                             return noDataView("No data found");
//                           }
//                         } else {
//                           // display error message if your list or data is null.
//                           return noDataView("No data found");
//                         }
//                       } else if (snapshot.hasError) {
//                         // display your message if snapshot has error.
//                         return noDataView("Something went wrong");
//                       } else {
//                         return noDataView("Something went wrong");
//                       }
//                       break;
//                     }
//                   case ConnectionState.none:
//                     {
//                       break;
//                     }
//                 }
//               }),
//         ));
//   }

//   // Here we created row for the bear list.
//   Widget generateColum(Instruction item,int position) => Card(
//         child: ListTile(
//           leading: CircleAvatar(
//               backgroundColor:  HexColor(item.color),
//               child:Text((position+1).toString()),
//             ),//Image.network(item.imageUrl),
//           title: Text(
//             item.message,
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//           subtitle:
//               Text(item.status+",    "+item.time),          
//         ),
//       );

//   // Progress indicator widget to show loading.
//   Widget loadingView() => Center(
//         child: CircularProgressIndicator(
//           backgroundColor: Colors.red,
//         ),
//       );

//   // View to empty data message
//   Widget noDataView(String msg) => Center(
//         child: Text(
//           msg,
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
//         ),
//       );

//   @override
//   void initState() {
//     // here first we are checking network connection
//      //getData();
//     isConnected().then((internet) {
//       if (internet) {
//         // set state while we fetch data from API
//         setState(() {
//           // calling API to show the data
//           // you can also do it with any button click.
//           instructionListFuture = getInstructionListData(); 
//         });
      
//       } else {
//         /*Display dialog with no internet connection message*/
//       }
//     }
//     );
//     super.initState();
//   }
 

// }
// class HexColor extends Color {
//   static int _getColorFromHex(String hexColor) {
//     hexColor = hexColor.toUpperCase().replaceAll("#", "");
//     if (hexColor.length == 6) {
//       hexColor = "FF" + hexColor;
//     }
//     return int.parse(hexColor, radix: 16);
//   }

//   HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
// }

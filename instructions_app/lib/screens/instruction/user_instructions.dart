import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instructions_app/components/Colors.dart';
import 'package:instructions_app/components/loading.dart';
import 'package:instructions_app/components/player_widget.dart';
import 'package:instructions_app/data/rest_ds.dart';
import 'package:instructions_app/models/instructions.dart';
import 'package:instructions_app/utils/connect_screen_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:async';


class UserInstructionsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserInstructionsState(); 
  
}

class UserInstructionsState extends State  {  
  List<Instruction> instructions = List<Instruction>();    
  String id ;
  bool _admin;
  int count = 0;  
  bool _isLoading = false;
  RestDatasource api = new RestDatasource();
  Timer _timer;
   @override
  void initState() {
    super.initState();
     if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    // if (Platform.isIOS) {
    //   if (audioCache.fixedPlayer != null) {
    //     audioCache.fixedPlayer.startHeadlessService();
    //   }
    //   advancedPlayer.startHeadlessService();
    // }
    _loadUserInfo();
    setState(() => _isLoading = true);  
    getData();
    setUpTimedFetch();
  }
 _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(()=> _admin = (prefs.getBool('admin')??false));                   
  }
    @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Seems"),
        backgroundColor: Colors.deepOrange),
        body:finalWidget(),
       
      // floatingActionButton: 
      // new Visibility( 
      //   visible: _admin,
      //   child: new FloatingActionButton(
      //     onPressed:() {
      //    Navigator.of(context).pushNamed("/sendinstruction");
      //   },
      //     tooltip: 'Send Instruction',
      //     child: new Icon(Icons.add),
      //   ), )
     
  );
  }
  Widget finalWidget(){
    if(instructions == null)
      return noDataView("No data found");

    if(_isLoading && instructions.length==0)
    return loadingView();//Loading();
    else if(!_isLoading && instructions.length>0)
    return Container(child: instructioListItems(),
    decoration: BoxDecoration(image: 
    DecorationImage(image:AssetImage('assets/home2.jpg'),
    fit:BoxFit.cover ),)
    );
    else
    return noDataView("No data found");

  }
  Widget noDataView(String msg) => Center(
        child: Text(
          msg,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      );
  ListView instructioListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return generateColum(instructions[position],position);    
      },
    );
  }
  Widget loadingView() => Center(
        child: CircularProgressIndicator(
         // backgroundColor: Colors.red,
        ),
      );
  Widget generateColum(Instruction item,int position) => Card(
        elevation: 2.0,
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor:  HexColor(item.color),
              child:Text((position+1).toString()),
            ),//Image.network(item.imageUrl),
          title: Text(
            item.message??'',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle:
              Text(getSubTitle(item)),
           onTap: () {
            submitTab(item);
          },
          //trailing:(item.url != null) ?PlayerWidget(url: item.url) : null   
           trailing:(item.url != null) ? IconButton(icon: Icon(Icons.play_arrow), onPressed: () {playRemoteFile(item.url);}) : null   
                  
        ),
        shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0))
      );
 submitTab(Instruction item){
      //setState(()=>_isLoading = true);       
            //acknowledgetData(item.id.toString());
            debugPrint("Tapped on " + item.id.toString());
            //navigateToDetail(this.instructions[position]);
  }
  String getSubTitle(Instruction item) {
    bool admin = item.admin;
     if(item.admin)
     return item.name+",    "+item.status+",    "+item.time;
     else
     return item.status+",    "+item.time;
     
  }
  acknowledgetData(String instructionId)  {  
    api.acknowledgeInstructions(instructionId).then((List<Instruction> lst) {
      if(lst!=null)
      {
             
        setState(() {
                   instructions = lst;
                   count = instructions.length;
                    //_isLoading = false;
                });
        debugPrint("Items " + count.toString());
      }   
      else
      {
        Toast.show("No seems were found!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }   
    });
    //.catchError((error) => setState(() => _isLoading = false)); 
    //.catchError((Exception error) => Toast.show("Load  instruction data failed!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM)); 
  }
  setUpTimedFetch() {
     _timer = Timer.periodic(Duration(milliseconds: 20000 ), (timer) {
     api.getInstructions().then((List<Instruction> lst) {
      if(lst!=null)
      {
             
        setState(() {
                   instructions = lst;
                   count = instructions.length;
                  _isLoading = false;
                });
        debugPrint("Items " + count.toString());
      }
      else
      {
        Toast.show("No seems were found!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
    }).catchError((error) => setState(() => _isLoading = false)); 

    });
    
  }

   getData()  { 
    api.getInstructions().then((List<Instruction> lst) {
      if(lst!=null)
      {
             
        setState(() {
                   instructions = lst;
                   count = instructions.length;
                  _isLoading = false;
                });
        debugPrint("Items " + count.toString());
      }
      else
      {
        Toast.show("No seems were found!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
    }).catchError((error) => setState(() => _isLoading = false)); 
    //Toast.show("Load  instruction data failed!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM)
  }
  void playRemoteFile(url){
    // AudioPlayer player = new AudioPlayer();
    //  int result = await player.play("https://bit.ly/2CH50TO");//await player.play(url);
    // if (result == 1) {
    //   // success
    // }
    // await player.play("'https://luan.xyz/files/audio/ambient_c_motion.mp3'");
    print('Play Now :'+ url);
     showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: PlayerWidget(url: url),
        );
      });
  }
  @override
dispose(){
 _timer.cancel();
  super.dispose();
}



  // @override
  // void onError(String errorTxt) {
  //   // TODO: implement onError
  //    Toast.show(errorTxt, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  // }

  // @override
  // void onSuccess(item) {
  //   // TODO: implement onSuccess
           
  //       setState(() {
  //                  instructions = item;
  //       count = instructions.length;
  //               });
  //       debugPrint("Items " + count.toString());
  // }
  
}
 

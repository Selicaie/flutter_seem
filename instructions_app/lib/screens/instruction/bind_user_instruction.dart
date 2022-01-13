import 'package:flutter/material.dart';
import 'package:instructions_app/components/Colors.dart';
import 'package:instructions_app/components/loading.dart';
import 'package:instructions_app/data/rest_ds.dart';
import 'package:instructions_app/models/instructions.dart';
import 'package:instructions_app/models/instructionsUser.dart';
import 'package:instructions_app/screens/instruction/user_instruction_details.dart';
import 'package:toast/toast.dart';


class BindUserInstructionsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BindUserInstructionsState(); 
  
}

class BindUserInstructionsState extends State  {  
  List<InstructionUser> instructions = List<InstructionUser>();    
  String id ;
  bool admin;
  int count = 0;  
  bool _isLoading = false;
  RestDatasource api = new RestDatasource();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();
   @override
  void initState() {
    super.initState();
    setState(() => _isLoading = true);  
    getData();
  }
 
    @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: new AppBar(
        title: new Text("User Groups"),
        backgroundColor: Colors.deepOrange),
        body:
        finalWidget(),
       
      floatingActionButton: FloatingActionButton(
        onPressed:() {
           //Navigator.of(context).pushNamed("/instructionUserDetail");
          navigateToDetail(InstructionUser(0,'',0,0,''));
        }
        ,
        tooltip: "Add new user instruction",
        child: new Icon(Icons.add),
      ),
  );
  }
  Widget finalWidget()
  {
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
    else if(!_isLoading && instructions.length>0)
     instructioListItems();
    // {
    //  return  RefreshIndicator(
    // key: _refreshIndicatorKey,
    // onRefresh: getData(),
    // child: instructioListItems(),);
    // } 
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
  Widget generateColum(InstructionUser item,int position) => Card(
        elevation: 2.0,
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor:  HexColor(item.color),
              child:Text((position+1).toString()),
            ),//Image.network(item.imageUrl),
          title: Text(
            item.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),          
           onTap: () {
              navigateToDetail(item);
            //submitTab(item);
          },          
        ),
        
      );
 submitTab(InstructionUser item)
  {
      //setState(()=>_isLoading = true);       
            // acknowledgetData(item.id.toString());
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
  getData()  { 
    api.getInstructionsUser().then((List<InstructionUser> lst) {
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
        Toast.show("No instructions were found!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
    }).catchError((error) => setState(() => _isLoading = false)); 
    //Toast.show("Load  instruction data failed!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM)
  }
  void navigateToDetail(InstructionUser instructionUser) async {
    bool result = await Navigator.push(context, 
        MaterialPageRoute(builder: (context) => UserInstructionDetails(instructionUser)),
    );
    debugPrint(result.toString());
    if (result == true) {
        getData();
    }
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


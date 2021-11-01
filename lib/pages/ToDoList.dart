// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({ Key? key }) : super(key: key);

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  
  String userTask = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("ToDoList", style: TextStyle(color: Colors.white),), centerTitle: true,
          actions: [
            TextButton(onPressed: ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if(prefs.getKeys().isEmpty != true){
                setState(() {
                  prefs.getKeys().forEach((element){
                    prefs.remove(element);
                  });
                });
              }
            }, child: Text("Remove all", style: TextStyle(color: Colors.white),))
          ],),
        body:
          FutureBuilder(
            future: getPrefs(),
            builder: (BuildContext context, AsyncSnapshot<dynamic>snapshot){
              if(snapshot.data == null){
                return Container(child: Text("Empty"),);
              }else{
              return ListView.builder(
                itemCount: snapshot.data.getKeys().length,
                itemBuilder: (BuildContext context, index){
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: Card(
                      color: Colors.blue[200],
                      margin: EdgeInsets.fromLTRB(0,10,0,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(snapshot.data.getString('$index')),
                        ),
                        Container(
                          child: Row(children: [
                            IconButton(onPressed: (){
                              showDialog(context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("Task №${index + 1}"),
                                  content: TextField(
                                    controller: TextEditingController(text:"${snapshot.data.getString("$index")}"),
                                    decoration: InputDecoration( hintText: '${snapshot.data.getString("$index")}'),
                                    onChanged: (String value){
                                      userTask = value;
                                    },
                                  ),
                                  actions: [
                                    Column(
                                      children: [
                                        TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Close")),
                                        TextButton(onPressed: (){
                                          setState(() {
                                            snapshot.data.setString('$index', userTask);
                                          });
                                          Navigator.pop(context, true);
                                        }, child: Text("Confirm")),
                                        TextButton(onPressed: (){
                                          setState(() {
                                            snapshot.data.remove('$index');
                                          });
                                          sortKeys();
                                          Navigator.pop(context, true);
                                        }, child: Text("Delete"))
                                      ],
                                    )
                                  ],
                                );
                              });
                            }, icon: Icon(Icons.rate_review_outlined, color: Colors.blue)),
                            IconButton(onPressed: (){
                              setState(() {
                                snapshot.data.remove('$index');                           
                              });
                              sortKeys();
                            }, icon: Icon(Icons.delete, color: Colors.blue))
                          ],),
                        )
                      ],),
                    )
                  );
                },
              );
              }
            },
          ),
        floatingActionButton: FloatingActionButton(onPressed:(){
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text("New task"),
              content: TextField(
                onChanged: (String value){
                  userTask = value;
                },),
              actions: [
                TextButton(onPressed: ()async{
                  nextEmpty();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState(() {
                    prefs.setString(counter.toString(), userTask);
                  });
                }, child: Text("Add"))
              ],
            );
          });
          },
          child: Icon(Icons.add, color: Colors.white,),),
      )
    );
  }
}

Future getPrefs()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs;
}

int counter = 0;

void nextEmpty()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  counter = 0;
  while (true){
    if(prefs.getString(counter.toString()) == null){
      break;
    }
    counter++;
  }
}

void sortKeys()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getKeys().isEmpty != true){
    List<dynamic> list = prefs.getKeys().toList();
    list.forEach((element) { element = int.parse(element);});
    list.sort();
    for( int i = 0; i < list.length; i++){
      if( i != int.tryParse(list[i])){
        prefs.setString('$i', prefs.getString('${list[i]}')!);
        prefs.remove('${list[i]}');
      }
    }
  }
}
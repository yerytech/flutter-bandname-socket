import 'dart:developer';

import 'package:bandname/models/band.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
List<Band> bands=[
  Band(id: '1',name: 'Metalica',votes: 5),
  Band(id: '2',name: 'Beatle',votes: 4),
  Band(id: '3',name: 'Heroes',votes: 2),
  Band(id: '4',name: 'Cafe',votes: 3),
  Band(id: '5',name: 'Cubana',votes: 2),
];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const  Text('BandNames',style: TextStyle(color:Colors.black87),),
      backgroundColor: Colors.white,
      
      ),
      
      body: ListView.builder(
        itemCount:bands.length,
        itemBuilder: (context, i)=>_bandTile(bands[i]) 
        
      ), floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,child: const  Icon(Icons.add),),
   );
  }

  Widget _bandTile(Band band ) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        log('$direction');
        log('${band.id}');
        // todo llamar borrado en el server 
      },
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.center,
          child: Text('Delete Band',style: TextStyle(color: Colors.white),),),
      ),
      key: Key(band.id!),
      child: ListTile(
             leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(band.name!.substring(0,2)),
             ),title: Text(band.name!),
             trailing: Text('${band.votes!}',style: const TextStyle(fontSize: 20) ,),
             onTap: (){
              log(band.name!);    },
          ),
    );
  }
   

   addNewBand(){
      final textController= TextEditingController();
      showAdaptiveDialog(context: context, builder: (context){
         return  AlertDialog.adaptive(
          title: const Text('New Band Name '),
          content: TextField(
           controller: textController,

          ), actions: [MaterialButton(
            textColor: Colors.blue,
            onPressed: (){

              log(textController.text);
            },
            child: const Text('Add'))],
         );
      });
     
       }
     
     
     
   }




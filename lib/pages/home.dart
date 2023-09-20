
import 'package:bandname/models/band.dart';
import 'package:bandname/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


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
  void initState() {
      final cherckService= Provider.of<SocketService>(context,listen: false);
    cherckService.socket.on('active-bands',_handleActiveBands);
    super.initState();
  } 

  _handleActiveBands(dynamic payload){
    bands= (payload as List).map((band) => Band.fromMap(band)).toList();
         setState(() {
           
         }); 
    
  }
  @override
  void dispose() { 
    final cherckService= Provider.of<SocketService>(context,listen: false);
    cherckService.socket.off('active-bands');
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    final cherckService= Provider.of<SocketService>(context);

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:const  Text('BandNames',style: TextStyle(color:Colors.black87),),
      backgroundColor: Colors.white, elevation: 1,
      actions: [Container(
        margin: const EdgeInsets.only(right: 10),
        child: cherckService.serverStatus==ServerStatus.online? const Icon(Icons.check_circle,color: Colors.green,):
        const Icon(Icons.check_circle,color: Colors.red,),
      )],
      
      ),
      
      body: Column(children: [

        _showGraph(),
        Expanded(child: ListView.builder(
        itemCount:bands.length,
        itemBuilder: (_, i)=>_bandTile(bands[i]) 
        
      ),),   
      ],) ,floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,child: const  Icon(Icons.add),),
   );
  }

  Widget _bandTile(Band band ) {
      final socketsSevice = Provider.of<SocketService>(context,listen: false);
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (_)=> socketsSevice.socket.emit('delete-band',{'id':band.id}),
        
      
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
                 socketsSevice.socket.emit('vote-band',{'id':band.id});
               },
          ),
    );
  }
   

   addNewBand(){ 
        final socketsSevice = Provider.of<SocketService>(context,listen: false);
      final textController= TextEditingController();
      showAdaptiveDialog(
        barrierDismissible: false,
        context: context, builder: (_)=>
          AlertDialog.adaptive(
          title: const Text('New Band Name '),
          content: TextField(
           controller: textController,

          ), actions: [  MaterialButton(
            textColor: Colors.blue,
            onPressed:(){
              if(textController.text.length>1){
                socketsSevice.socket.emit('add-band',{'name':textController.text});
                  
              }
                  Navigator.pop(context);
            },
            child: const Text('Add')),  MaterialButton(
            textColor: Colors.blue,
            onPressed: (){
              
              Navigator.pop(context);
            },
            child: const Text('Close'))],
         )
      ); 
    
   
     
       }
       
        Widget  _showGraph() {
           Map<String, double> dataMap = {};
           for (var band in bands) {
            dataMap.putIfAbsent(band.name!, () =>band.votes!.toDouble());
           }
        //     "Flutter": 5,.fo
        //  "React": 3,
        //   "Xamarin": 2,
        //  "Ionic": 2,
        //   };
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PieChart(
              chartType: ChartType.ring,
              dataMap: dataMap),
          );

         } 


     
   }




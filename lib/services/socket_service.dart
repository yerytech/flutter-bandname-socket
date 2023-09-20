




import 'package:flutter/material.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online, offline,coneccting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus =ServerStatus.coneccting;
   IO.Socket? _socket;

   ServerStatus get serverStatus => _serverStatus;
   IO.Socket get socket =>_socket!;

  SocketService(){
   _initConfig();

  }


  void _initConfig(){
    // Dart client
  _socket = IO.io('http://192.168.0.109:3000/',{
    'transports':['websocket'],
    'autoConet':true,
  });
  _socket!.onConnect((_) {
  
    _serverStatus = ServerStatus.online;
    notifyListeners();
    
  });
  
  _socket!.onDisconnect((_){
    _serverStatus = ServerStatus.offline;
    notifyListeners();  
  });
 



  }


}
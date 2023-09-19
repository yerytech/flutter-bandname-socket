


import 'package:flutter/material.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online, offline,coneccting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus =ServerStatus.coneccting;

  get serverStatus => _serverStatus;

  SocketService(){
   _initConfig();

  }


  void _initConfig(){
    // Dart client
  IO.Socket socket = IO.io('http://localhost:3000/',{
    'transports':['websocket'],
    'autoConet':true,
  });
  socket.onConnect((_) {
  
    _serverStatus = ServerStatus.online;
    notifyListeners();
    
  });
  
  socket.onDisconnect((_){
    _serverStatus = ServerStatus.offline;
    notifyListeners();  
  });
  socket.on('Nuevo-mensaje',(payload){
    print('Nuevo mensaje: $payload');
  });

     



  }


}
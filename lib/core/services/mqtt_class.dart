
import 'dart:convert';
import 'dart:developer';

import 'package:bsg/core/models/mqtt_model.dart';
import 'package:bsg/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


class MQTTManager{  
  // Private instance of client
  final MQTTAppState _currentState;  
  final String username;
  final String password;
  final String server;
  final String topic;


  MqttClient _client;

  // Constructor
  MQTTManager({  
    @required MQTTAppState state,@required String username,@required String password, @required String server,@required topic
}
):_currentState = state,server = server,username = username,password = password,topic = topic;
  

  Future<void> initializeMQTTClient() async {

    _client = MqttServerClient(server,'ClientId');
    _client.port = 1883;
    _client.keepAlivePeriod = 15;     
    _client.onDisconnected = onDisconnected;        
    // _client.autoReconnect = true;    
    _client.logging(on: false);

    // /// Add the successful connection callback
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
  
    final MqttConnectMessage connMess = MqttConnectMessage() 
        .withClientIdentifier("ClientId")              
        .keepAliveFor(20)                
        .startClean()               
        .authenticateAs(username, password)// Non persistent session for testing
        .withWillQos(MqttQos.exactlyOnce);

    log('EXAMPLE::Mosquitto client connecting....');
    _client.connectionMessage = connMess;

  }

  // Connect to the host
  void connect() async{
    assert(_client != null);
    try {
      log('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client.connect(username,password);
    } on Exception catch (e) {
      log('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    log('Disconnected');
    _client.disconnect();
  }
  
  void publish(String message){
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    log('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus.returnCode == MqttConnectReturnCode.notAuthorized) {
      log('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  /// The successful connect callback
  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    log('EXAMPLE::Mosquitto client connected....');
    _client.subscribe(topic, MqttQos.atLeastOnce);
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =  MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      var val = json.decode(pt);
      _currentState.setReceivedText(val);
      printWrapped("+++++++++++ $pt");

      /// The above may seem a little convoluted for users only interested in the
      /// payload, some users however may be interested in the received publish message,
      /// lets not constrain ourselves yet until the package has been in the wild
      /// for a while.
      /// The payload is a byte buffer, this will be specific to the topic
      log(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    });
    log(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }
}
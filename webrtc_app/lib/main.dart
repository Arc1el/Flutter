import 'dart:convert';

import "package:flutter/material.dart";
import "package:flutter_webrtc/flutter_webrtc.dart";
import 'package:socket_io_client/socket_io_client.dart' as IO;


void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final IO.Socket socket;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? pc;

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  Future init() async{
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await connectSocket();
    await joinRoom();
  }

  Future connectSocket() async{
    socket = IO.io("http://localhost:3000", IO.OptionBuilder().setTransports(['websocket']).build());
    socket.onConnect((data) => print("connection success!"));

    socket.on("joined", (data){
      _sendOffer();
    });

    socket.on("offer", (data) async{
      data = jsonDecode(data);
      await _gotOffer(RTCSessionDescription(data['sdp'], data['type']));
      await _sendAnswer();
    });

    socket.on("answer", (data){
      data = jsonDecode(data);
      _gotAnswer(RTCSessionDescription(data['sdp'], data['type']));

    });

    socket.on("ice", (data){
      data = jsonDecode(data);
      _gotIce(RTCIceCandidate(data['candidate'], data['sdpMid'], data['sdpMLineIndex']));

    });

  }

  Future joinRoom() async{
    //설정
    final config = {
      //스턴서버
      'iceServers': [
        {"url" : "stun:stun.l.google.com:19302"},
      ]
    };

    final sdpConstraints = {
      'mandatory' : {
        'OfferToReceiveAudio' : true,
        'OfferToREceiveVideo' : true,
      },
      'optional' : []
    };

    pc = await createPeerConnection(config, sdpConstraints);

    final mediaConstraints = {
      'audio' : true,
      'video' : {
        'facingMode' : 'user'
      }
    };

    _localStream = await Helper.openCamera(mediaConstraints);

    //리스트 반환
    _localStream!.getTracks().forEach((track) {
      pc!.addTrack(track, _localStream!);
    });

    _localRenderer.srcObject = _localStream;

    pc!.onIceCandidate = (ice) {
      //ice를 상대방에게 전달
      _sendIce(ice);

    };

    pc!.onAddStream = (stream) {
      _remoteRenderer.srcObject = stream;
    };

    socket.emit("join");
  }

  Future _sendOffer() async {
    print("send offer");
    var offer = await pc!.createOffer();
    pc!.setLocalDescription(offer);
    socket.emit("offer", jsonEncode(offer.toMap()));
  }

  Future _gotOffer(RTCSessionDescription offer) async {
    print("got offer");
    pc!.setRemoteDescription(offer);
  }

  Future _sendAnswer() async {
    print("send answer");
    var answer = await pc!.createAnswer();
    pc!.setLocalDescription(answer);
    socket.emit('answer', jsonEncode(answer.toMap()));
  }

  Future _gotAnswer(RTCSessionDescription answer) async {
    print("got answer");
    pc!.setRemoteDescription(answer);
  }

  Future _sendIce(RTCIceCandidate ice) async {
    print("send ice");
    socket.emit("ice", jsonEncode(ice.toMap()));
  }

  Future _gotIce(RTCIceCandidate ice) async {
    print("got ice");
    pc!.addCandidate(ice);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : Row(
        children: [
          Expanded(child: RTCVideoView(_localRenderer)),
          Expanded(child: RTCVideoView(_remoteRenderer))
        ],
      ),
    );
  }
}















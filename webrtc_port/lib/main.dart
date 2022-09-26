import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';

void main() {
  runApp(const MyApp());
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
  MediaStream? _remoteStream;

  late final device;
  //final Map<String, dynamic> routerRtpCapabilities = await mySignaling.request('getRouterCapabilities');
  late final Map<String, dynamic> routerRtpCapabilities;

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  Future init() async{
    await connectSocket();
    await get_router_capabilities();
    await load_device();
    await init_transports();
    await get_producers();
  }

  Future get_router_capabilities() async{
    routerRtpCapabilities = Map();
  }

  Future load_device() async{
    device.load(routerRtpCapabilities : rtp)
  }

  Future init_transports() async{

  }

  Future get_producers() async{

  }

  Future connectSocket() async{
    socket = IO.io("http://localhost:3000", IO.OptionBuilder().setTransports(['websocket']).build());
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : Row(
        children : [
          Expanded(child : RTCVideoView(_localRenderer)),
          Expanded(child : RTCVideoView(_remoteRenderer))
        ],
      ),
    );
  }
}

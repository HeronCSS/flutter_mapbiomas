import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mapbiomas/graph_config.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LatLng>? alertas = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    getData();
  }


  List<CircleMarker> markers = List.empty(growable: true);



  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MapBiomas'),
      ),
      body: Stack(children: [
        FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(-15.6009, -47.6629),
            initialZoom: 5,
          ),
            mapController: mapController, children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          CircleLayer(circles: markers)
        ]),
      ]),
    );
  }
  getMarkers(){
    if(alertas != null || alertas!.isNotEmpty){
      for (int i = 0; i < alertas!.length; i++) {
        markers.add(
            CircleMarker(point: alertas![i], radius: 5, color: Colors.red.withOpacity(0.3)));
      }
    }
    return markers;
  }
  getData() async{
    alertas = await GraphQLService().getAlertas();
    getMarkers();
  }
}

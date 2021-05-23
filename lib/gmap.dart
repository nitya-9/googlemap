import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Gmap extends StatefulWidget {
  const Gmap({Key key}) : super(key: key);

  @override
  _GmapState createState() => _GmapState();
}

class _GmapState extends State<Gmap> {
  Set<Marker>_markers = LinkedHashSet<Marker>();
  Set<Polygon>_polygon = LinkedHashSet<Polygon>();
  Set<Polyline>_polylines = LinkedHashSet<Polyline>();
  Set<Circle>_circle = LinkedHashSet<Circle>();

  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;

  @override
  void initState(){
    super.initState();
    _setMarkerIcon();
    _setPolygon();
    _setPolylines();
    _setCircle();
  }

  void _setMarkerIcon()async{
    _markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(),'assets/noodle_icon.png');
  }

  void _setPolygon(){
    List<LatLng> polygonLatlongs = List<LatLng>();
    polygonLatlongs.add(LatLng(37.78493, -122.42932));
    polygonLatlongs.add(LatLng(37.78693, -122.41942));
    polygonLatlongs.add(LatLng(37.78923, -122.41542));
    polygonLatlongs.add(LatLng(37.78923, -122.42582));

    _polygon.add(
        Polygon(
          polygonId:  PolygonId('0'),
          points: polygonLatlongs,
          fillColor: Colors.white,
          strokeWidth: 1,
    )
    );
  }

  void _setPolylines(){
    List<LatLng> polylineLatLongs = List<LatLng>();
    polylineLatLongs.add(LatLng(37.74493, -122.42932));
    polylineLatLongs.add(LatLng(37.74693, -122.41942));
    polylineLatLongs.add(LatLng(37.74923, -122.41542));
    polylineLatLongs.add(LatLng(37.74923, -122.42582));

    _polylines.add(
        Polyline(
          polylineId:  PolylineId('0'),
          points: polylineLatLongs,
          color : Colors.purple,
          width: 1,
        )
    );
  }

  void _setCircle(){
    _circle.add(
      Circle (
        circleId: CircleId('0'),
        center: LatLng(37.76493,-122.42432),
        radius: 1000,
        strokeWidth: 2,
        fillColor: Color.fromRGBO(102,51, 153,.5)
      ),
    );
  }

  void _setMapStyle () async {
    String style = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    _mapController.setMapStyle(style);
  }

  void _onMapCreated(GoogleMapController controller){
    _mapController = controller;

    setState(() {
      _markers.add(Marker(markerId: MarkerId('0'),
        position: LatLng(37.77483,-122.42942),
        infoWindow: InfoWindow(
            title: 'san frans',
            snippet: 'nice city'
          ),
        icon: _markerIcon,
        ),
      );
    });
    _setMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(children: <Widget>[
      GoogleMap(
        onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
          target: LatLng(37.77483,-122.42942),
          zoom: 12,
            ),
        markers: _markers,
        polygons: _polygon,
        polylines: _polylines,
        circles: _circle,
        myLocationButtonEnabled: true,
        
        ),
    Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
      child: Text('Map'),
             )
         ],
       ),
    );
  }
}
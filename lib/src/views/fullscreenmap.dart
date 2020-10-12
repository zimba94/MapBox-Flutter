import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter/services.dart';

class FullScreenMap extends StatefulWidget {

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {

  final center = LatLng(19.303759, -99.717262);

  final oscuroStyle = "mapbox://styles/simba94/ckg74ofu00fm119pdzx2m8571";
  final streetStyle = "mapbox://styles/simba94/ckg754sx25ao319s2aplfcqa7";

  String selectedStyle = "mapbox://styles/simba94/ckg74ofu00fm119pdzx2m8571";
  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

   void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(url);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[

        //Simbolos

        FloatingActionButton(
          child: Icon(Icons.add_circle_outline),
          onPressed: (){
            mapController.addSymbol(SymbolOptions(
              geometry: center,
              iconSize: 3,
              //iconImage:"assetImage", o
              //iconImage:"networtImage",
              iconImage:"veterinary-15",
              textField: "Veterinaria",
              textOffset: Offset(0, 2)
            ));
          },
        ),

        SizedBox( height: 5,),

        //ZoomIn

        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: (){
            mapController.animateCamera(CameraUpdate.zoomIn());
          },
        ),

        SizedBox( height: 5,),

        //ZoomIn

        FloatingActionButton(
          child: Icon(Icons.zoom_out),
          onPressed: (){
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
        ),

        SizedBox( height: 5,),

        //Cambiar estilo
        FloatingActionButton(
          child: Icon(Icons.add_to_home_screen),
          onPressed: (){
            if (selectedStyle == oscuroStyle) {
              selectedStyle = streetStyle;
            } else {
              selectedStyle = oscuroStyle;
            }
            _onStyleLoaded();
            setState(() {
              
            });
          } ,
        ),
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
        styleString: selectedStyle,
        accessToken: 'pk.eyJ1Ijoic2ltYmE5NCIsImEiOiJjazZxeGRpNWowMDRxM2ZsYWw1YTQ3ZWJsIn0.Wh1lLWXr-dm5L5cS9YaJVA',
        onMapCreated: _onMapCreated,
        initialCameraPosition:
        CameraPosition(
          target: center,
          zoom: 20  
        ),
      );
  }
}
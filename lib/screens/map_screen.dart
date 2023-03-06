import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register/login.dart';
import 'package:flutter_login_register/src/ui/startScreen.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Map<String, Marker> _markers = {};
  late LatLng _currentLocation;
  bool _isLoading = false;
  late String _loggedInUserEmail;

  Stream<Set<Marker>> get _markersStream {
    return FirebaseFirestore.instance
        .collection('usersLocations')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final userId = doc.id;

        final geoPoint = doc['location'] as GeoPoint;
        final location = LatLng(geoPoint.latitude, geoPoint.longitude);
        return Marker(
          markerId: MarkerId(userId),
          position: location,
          infoWindow: InfoWindow(
            title: userId,
            snippet: location.toString(),
          ),
        );
      }).toSet();
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getUserEmail();
    _checkIfUserExists(FirebaseAuth.instance.currentUser!.uid).then((exists) {
      if (!exists) {
        FirebaseAuth.instance.signOut();
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,

      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      _saveUserLocation();

      Timer.periodic(const Duration(seconds: 10), (timer) {
        _saveUserLocation();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getUserEmail() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      setState(() {
        _loggedInUserEmail = user['email'];
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveUserLocation() async {
    if (_currentLocation == null) {
      return;
    }

    try {
      setState(() {
       
        _checkIfUserExists(FirebaseAuth.instance.currentUser!.uid)
            .then((exists) {
          if (!exists) {
            FirebaseAuth.instance.signOut();
          }
          setState(() {
            _isLoading = false;
          });
        });
      });

      
      await FirebaseFirestore.instance
          .collection('usersLocations')
          .doc(_loggedInUserEmail)
          .set({
        'location': GeoPoint(_currentLocation.latitude, _currentLocation.longitude),
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
//traer id de usuario

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mapa BiciBúho',
          style: TextStyle(
            color: Colors.white, // define el color del texto en la AppBar
            fontWeight: FontWeight
                .bold, // define el peso de la fuente del texto en la AppBar
            fontSize:
                20.0, // define el tamaño de la fuente del texto en la AppBar
            fontFamily:
                'Roboto', // define la fuente de la fuente del texto en la AppBar
          ),
        ),
        backgroundColor: Color.fromARGB(
            255, 171, 206, 235), // define el color de fondo de la AppBar
        elevation: 0, // elimina la sombra debajo de la AppBar
        centerTitle: true, // centra el título en la AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<Set<Marker>>(
              stream: _markersStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation,
                      zoom: 15,
                    ),
                    markers: snapshot.data!,
                    onMapCreated: (GoogleMapController controller) async {
                      await _getUserLocation();
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _currentLocation,
                            zoom: 8,
                          ),
                        ),
                      );
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onCameraMove: (position) {
                      setState(() {
                        _currentLocation = position.target;
                        _checkIfUserExists(
                                FirebaseAuth.instance.currentUser!.uid)
                            .then((exists) {
                          if (!exists) {
                            AlertDialog(
                              title: Text('Alerta'),
                              content: Text('Su cuenta ha sido eliminada'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StartScreen()),
                                    );
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            );
                            FirebaseAuth.instance.signOut();
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        });

                        //verificar si existe un usuario

                        if (_markers.containsKey('me')) {
                          _markers.remove('me');
                        }
                        _markers['me'] = Marker(
                          markerId: MarkerId('me'),
                          position: _currentLocation,
                          infoWindow: InfoWindow(
                            title: 'Me',
                            snippet: _currentLocation.toString(),
                          ),
                        );
                      });
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }

  Future<bool> checkIfUserExists(String userId) async {
    try {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      return user.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  String getUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const StartScreen(),
      ),
    );
  }

  Future<bool> _checkIfUserExists(String userId) async {
    try {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      return user.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

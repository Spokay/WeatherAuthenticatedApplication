import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zoubida/components/meteo_card.dart';
import 'package:zoubida/services/auth_service.dart';
import 'package:zoubida/services/location_service.dart';
import 'package:zoubida/services/weather_service.dart';

import '../components/error_widget_component.dart';

class HomePage extends StatefulWidget {
  final String title = "Accueil";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  WeatherService weatherService = WeatherService();
  TextEditingController locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  MeteoCard? meteoCard;
  LocationService locationService = LocationService();
  Future<Position>? locationData;
  Widget? errorWidget;


  Future<void> formSubmit() async{
    buildMeteoCard(city: locationController.text);
  }
  Future<void> buildMeteoCard({String? city, Map<String, double>? coords}) async {
    Future<Map<String, dynamic>> response = city != null ? weatherService.getWeatherForAWeekByCityName(city) : weatherService.getWeatherForAWeekByCoordinates(coords!['lat']!, coords['long']!);

    MeteoCard meteoPages = MeteoCard(cardData: await response);
    setState(() {
      meteoCard = meteoPages;
    });
  }

  Future<void> locate() async{
    try{
      locationData = locationService.determinePosition();
    }on Exception catch (_, e){
      errorWidget = ErrorWidgetComponent(errorMessage: e.toString());
    }
    Position? pos = await locationData;
    if(pos != null){
      /*List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);*/
      buildMeteoCard(
          coords: {
            'lat': pos.latitude,
            'long': pos.longitude
          }
      );
    }else{
      throw Exception("Vous devez activer la localisation pour utiliser cette fonctionnalité");
    }
  }

  Future<void> searchForLastPosition() async{
    Position? pos = await Geolocator.getLastKnownPosition();
    if(pos != null){
      buildMeteoCard(
          coords: {
            'lat': pos.latitude,
            'long': pos.longitude
          }
      );
    }
  }

  @override
  void initState() {
    super.initState();
    searchForLastPosition();
  }

  Widget buildThis() {
    return Container(
      constraints: const BoxConstraints.expand(width: double.infinity, height: 200),
      child: FutureBuilder(
          future: Future(() => meteoCard),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return snapshot.data!;
            }else if(snapshot.hasError){
              return ErrorWidgetComponent(errorMessage: snapshot.error.toString());
            }
            return const Text('Cherchez une ville', textAlign: TextAlign.center,);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            Container(
              margin: const EdgeInsets.all(10),
              width: 40,
              height: 40,
              child: FloatingActionButton(
                onPressed: () {
                  authService.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil('/authenticate', (route) => false);
                },
                child: const Icon(Icons.logout_rounded),
              ),
            )
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(15),
            width: width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width, maxHeight: 100),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(width: width, height: 40),
                          height: 40,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: locationController,
                                ),
                              ),
                              IconButton(
                                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(0, 0, 0, 0.3))),
                                onPressed:
                                  locate,
                                icon: const Icon(Icons.location_searching),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints.expand(width: width* 0.5, height: 40),
                          child: ElevatedButton(
                            onPressed: formSubmit,
                            child: const Text("Chercher")
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: buildThis()
                ),
                FutureBuilder(
                    future: Future(() => errorWidget),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return snapshot.data!;
                      }else if(snapshot.hasError){
                        return ErrorWidgetComponent(errorMessage: snapshot.error.toString());
                      }
                      return const Text("");
                    }),
              ],
            ),
          ),
      )
    );
  }
}

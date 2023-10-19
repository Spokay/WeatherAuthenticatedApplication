import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeteoCard extends StatefulWidget {
  final Map<String, dynamic> cardData;
  const MeteoCard({super.key, required this.cardData});

  @override
  State<MeteoCard> createState() => _MeteoCardState();
}

class _MeteoCardState extends State<MeteoCard> {
  final Map<String, String> _days = {"1": "Lundi", "2": "Mardi", "3": "Mercredi", "4": "Jeudi", "5": "Vendredi", "6": "Samedi", "7": "Dimanche"};
  final Map<String, String> _months = {"1": "Janvier", "2": "Fevrier", "3": "Mars", "4": "Avril", "5": "Mai", "6": "Juin", "7": "Juillet", "8": "Aout", "9": "Septembre", "10": "Octobre", "11": "Novembre", "12": "Décembre"};

  String getHourStringFromApiData(DateTime dateTime){
    String str = dateTime.hour < 10 ? "0" : "";
    str += "${dateTime.hour}:";
    str += dateTime.minute < 10 ? "0" : "";
    str += "${dateTime.minute}";
    return str;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> res = [];
    List<dynamic> days = widget.cardData["forecast"]["forecastday"];
    for (var dayElement in days) {
      DateTime date = DateTime.parse(dayElement["date"]);
      var meteoCard = Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text(
                "${widget.cardData['location']['name']} | ${_days[date.weekday.toString()]} ${date.day} ${_months[date.month.toString()]}",
                style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text( textAlign: TextAlign.center,
                      "Heure",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      textAlign: TextAlign.center,
                      "Climat",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      textAlign: TextAlign.center,
                      "Température",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              for (var hour in dayElement["hour"]) Card(
                color: const Color.fromRGBO(0, 0, 0, 0.1),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              getHourStringFromApiData(DateTime.parse(hour['time'])),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: NetworkImage("http:${hour['condition']['icon']}"),
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "${hour["temp_c"]}°C",
                              textAlign: TextAlign.center
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      res.add(meteoCard);
    }
    PageView pageView = PageView(
      children: res,
    );
    return pageView;
  }
}

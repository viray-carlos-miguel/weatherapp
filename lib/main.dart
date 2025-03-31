import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Homepage(),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String location = "";
  String temp = "";
  IconData? weatherStatus;
  String weather = "";
  String humidity = "";
  String windSpeed = "";
  Map<String, dynamic> WeatherData = {};

  final TextEditingController _controller = TextEditingController();

  Future<void> getWeatherData() async {
    if (location.isEmpty) {
      showErrorDialog("Please enter a city name.");
      return;
    }

    try {
      String link =
          "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=a8bc31268d99cb60d6b8c7b2f883fe6f";
      final response = await http.get(Uri.parse(link));

      if (response.statusCode == 200) {
        WeatherData = jsonDecode(response.body);

        setState(() {
          temp = (WeatherData["main"]["temp"] - 273.15).toStringAsFixed(0) + "°";
          weather = WeatherData["weather"][0]["description"];
          humidity = "${WeatherData["main"]["humidity"]}%";
          windSpeed = "${WeatherData["wind"]["speed"]} kph";

          if (weather.contains("clear")) {
            weatherStatus = CupertinoIcons.sun_max;
          } else if (weather.contains("cloud")) {
            weatherStatus = CupertinoIcons.cloud;
          } else if (weather.contains("haze")) {
            weatherStatus = CupertinoIcons.sun_haze;
          } else {
            weatherStatus = CupertinoIcons.question_circle;
          }
        });
      } else {
        showErrorDialog("City Not Found");
      }
    } catch (e) {
      showErrorDialog("No Internet Connection");
    }
  }

  void showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: [
            CupertinoButton(
              child: const Text(
                'Close',
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            if (message == "No Internet Connection")
              CupertinoButton(
                child: const Text(
                  'Retry',
                  style: TextStyle(color: CupertinoColors.systemGreen),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  getWeatherData();
                },
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Iweather"),
        trailing: CupertinoButton(
          child: const Icon(CupertinoIcons.settings),
          onPressed: () {},
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoTextField(
                controller: _controller,
                placeholder: "Enter City Name",
                onChanged: (value) {
                  location = value;
                },
                onSubmitted: (_) => getWeatherData(),
                suffix: CupertinoButton(
                  child: const Icon(CupertinoIcons.search),
                  onPressed: getWeatherData,
                ),
              ),
              const SizedBox(height: 20),
              temp.isNotEmpty
                  ? Column(
                children: [
                  Text('Location: $location', style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 10),
                  Text(temp, style: const TextStyle(fontSize: 60)),
                  Icon(weatherStatus, color: CupertinoColors.systemOrange, size: 100),
                  const SizedBox(height: 5),
                  Text(weather, style: const TextStyle(fontSize: 18)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Humidity: $humidity'),
                      const SizedBox(width: 10),
                      Text('Wind: $windSpeed'),
                    ],
                  ),
                ],
              )
                  : const Center(child: CupertinoActivityIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
void main()=>runApp(CupertinoApp(
  debugShowCheckedModeBanner: false,
  home : Homepage(),));

class Homepage extends StatefulWidget {
  const Homepage ({super.key});

  @override
  State<Homepage> createState() => _State();
}

class _State extends State<Homepage> {
  @override
  String location = "";
  String temp = "";
  IconData ? weatherStatus;
  String weather = "";
  String humidity = "";
  String windSpeed = "";
  
  Map<String,dynamic> WeatherData = {};

  Future<void> getWeatherData() async {

try {
  String link = "https://api.openweathermap.org/data/2.5/weather?q="+ location +"&appid=a8bc31268d99cb60d6b8c7b2f883fe6f";
  final response = await http.get(
      Uri.parse(link)
  );
  WeatherData = jsonDecode(response.body);
 try {
   setState(() {
     temp = (WeatherData["main"]["temp"]-273.15).toStringAsFixed(0) + "°";
     weather = WeatherData["weather"][0]["description"];
     humidity = (WeatherData["main"]["humidity"]).toString() + "%";
     windSpeed = WeatherData["wind"]["speed"].toString() + " kph";

     if (weather!.contains("clear")){
       weatherStatus = CupertinoIcons.sun_max ;
     } else if (weather!.contains("cloud")) {
       weatherStatus = CupertinoIcons.cloud;
     } else if (weather!.contains("haze")){
       weatherStatus = CupertinoIcons.sun_haze;
     }
   });
 } catch (e){
   showCupertinoDialog(context: context, builder: (context){
     return CupertinoAlertDialog(
       title: Text('Message'),
       content: Text('City Not Found'),
       actions: [
         CupertinoButton(child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed),), onPressed: (){
           Navigator.pop(context);
         })
       ],
     );
   });
 }
  print(WeatherData["cod"]);
  if (WeatherData["cod"] == 200) {
    print(WeatherData["wind"]["speed"].toString() + " kph");

  }else {
    print("Invalid City");
  }
} catch (e){
  showCupertinoDialog(context: context, builder: (context){
    return CupertinoAlertDialog(
      title: Text('Message'),
      content: Text('No Internet Connection'),
      actions: [
        CupertinoButton(child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed),), onPressed: (){
          Navigator.pop(context);
        }),
        CupertinoButton(child: Text('Retry', style: TextStyle(color: CupertinoColors.systemGreen),), onPressed: (){
          Navigator.pop(context);
          getWeatherData();
        }),
      ],
    );
  });
}

  }

  @override
  void initState() {
    getWeatherData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Iweather"),
          trailing: CupertinoButton(child: Icon(CupertinoIcons.settings), onPressed: (){}),
        ),
        child: SafeArea(child: temp != "" ?Center(
          child: Column(
            children: [
              SizedBox(height: 49,),
              Text('My Location',style: TextStyle(fontSize: 35),),
              SizedBox(height: 5,),
              Text('$location'),
              SizedBox(height: 10,),
              Text('$temp',style: TextStyle(fontSize: 60)),

              Icon(weatherStatus, color: CupertinoColors.systemOrange, size: 100,),
              SizedBox(height: 5,),
              Text('$weather'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('H: $humidity'),
                  SizedBox(width:10,),
                  Text('W: $windSpeed')
                ],
              )


            ],
          ),
        ) : Center(child: CupertinoActivityIndicator(),)));
  }
}

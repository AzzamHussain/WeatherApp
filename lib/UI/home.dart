import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/UI/detail_page.dart';
import 'package:weatherapp/models/city.dart';
import 'package:weatherapp/models/utils.dart';
import 'package:weatherapp/widgets/weather_item.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Utils myUtils = Utils();

  // Initialization
  int temperature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading..';
  int humidity = 0;
  int windSpeed = 0;

  var currentDate = 'Loading..';
  String imageUrl = '';
  String location = 'Karachi'; // Our default city

  // Get the selected cities data
  var selectedCities = City.getSelectedCities();
  List<String> cities = ['Karachi']; // Default city

  List consolidatedWeatherList = []; // To hold weather data after API call

  // API call URL
  String searchWeatherUrl =
      'https://api.openweathermap.org/data/2.5/weather'; // Weather API URL
  //'https://pro.openweathermap.org/data/2.5/weather';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  void fetchWeatherData() async {
    // Fetch weather data based on the selected location coordinates
    var url = Uri.parse(searchWeatherUrl).replace(queryParameters: {
      'lat': '24.866779', // Example latitude value
      'lon': '67.031129', // Example longitude value
      'appid':
          'b1c17fe32507a568219a87890e40b75f', // Replace with your OpenWeatherMap API key
    });

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      setState(() {
        // Update weather data variables
        temperature = (result['main']['temp'] - 273.15).round();
        maxTemp = (result['main']['temp_max'] - 273.15).round();
        humidity = result['main']['humidity'];
        windSpeed = result['wind']['speed'].round();
        weatherStateName = result['weather'][0]['main'];
        imageUrl = ''; // Set image URL based on weather state
        currentDate = DateFormat.yMd().add_jms().format(DateTime.now());
      });
    } else {
      // Handle error
      print('Failed to fetch weather data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create a size variable for the media query
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Our profile image
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  'assets/profile.png',
                  width: 40,
                  height: 40,
                ),
              ),
              // Our location dropdown
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/pin.png',
                    width: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: location,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: cities.map((String location) {
                        return DropdownMenuItem(
                            value: location, child: Text(location));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          location = newValue!;
                          fetchWeatherData(); // Fetch weather data for the selected location
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            Text(
              currentDate,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: size.width,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: myUtils.primaryColor.withOpacity(.5),
                    offset: const Offset(0, 25),
                    blurRadius: 10,
                    spreadRadius: -12,
                  )
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -40,
                    left: 20,
                    child: imageUrl == ''
                        ? const Text('')
                        : Image.asset(
                            'assets/' + imageUrl + '.png',
                            width: 150,
                          ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: Text(
                      weatherStateName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            temperature.toString(),
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  colors: <Color>[
                                    Color(0xffABCFF2),
                                    //Color(0xff9AC6F3)
                                    Colors.white
                                  ],
                                ).createShader(
                                    Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                            ),
                          ),
                        ),
                        Text(
                          'o',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: <Color>[
                                  Color(0xffABCFF2),
                                  Color(0xff9AC6F3)
                                ],
                              ).createShader(
                                  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weatherItem(
                    text: 'Wind Speed',
                    value: windSpeed,
                    unit: 'km/h',
                    imageUrl: 'assets/windspeed.png',
                  ),
                  weatherItem(
                      text: 'Humidity',
                      value: humidity,
                      unit: '',
                      imageUrl: 'assets/humidity.png'),
                  weatherItem(
                    text: 'Max Temp',
                    value: maxTemp,
                    unit: 'C',
                    imageUrl: 'assets/max-temp.png',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            // Add your weather forecast widgets here
          ],
        ),
      ),
    );
  }
}

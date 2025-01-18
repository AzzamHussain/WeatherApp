import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date
import 'package:weatherapp/models/utils.dart';
import 'welcome.dart'; // Navigation target widget

// Encapsulation: WeatherScreen class encapsulates data (location, weather list, selectedId)
// and behavior (StatefulWidget lifecycle) in a single reusable unit.
class WeatherScreen extends StatefulWidget {
  final String location; // Example of encapsulation through properties
  final List<Map<String, dynamic>> consolidatedWeatherList;
  final int selectedId;

  const WeatherScreen({
    Key? key,
    required this.location,
    required this.consolidatedWeatherList,
    required this.selectedId,
  }) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

// Abstraction: Hides implementation details of state management behind a simple interface.
class _WeatherScreenState extends State<WeatherScreen> {
  late String imageUrl; // Late initialization demonstrates delayed initialization for flexibility.

  @override
  Widget build(BuildContext context) {
    // Using utility classes demonstrates modular design (Abstraction).
    Utils myUtils = Utils();

    // Polymorphism: LinearGradient uses a common interface to provide custom gradients.
    final Shader linearGradient = const LinearGradient(
      colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    // Accessing inherited properties from the parent class (Inheritance).
    int selectedIndex = widget.selectedId;

    // Image URL determined dynamically demonstrates encapsulation of logic.
    var weatherStateName =
        widget.consolidatedWeatherList[selectedIndex]['weather_state_name'];
    imageUrl = weatherStateName.replaceAll(' ', '').toLowerCase();

    return Scaffold(
      backgroundColor: myUtils.secondaryColor, // Using utility class (Abstraction).
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: myUtils.secondaryColor,
        elevation: 0.0,
        title: Text(widget.location), // Accessing properties of parent class (Inheritance).
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                // Navigation demonstrates abstraction by hiding complex routing logic.
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Welcome()));
              },
              icon: const Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Composition: WeatherScreen uses multiple smaller widgets to create a complex UI.
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              height: 150,
              width: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.consolidatedWeatherList.length,
                itemBuilder: (BuildContext context, int index) {
                  var futureWeatherName = widget
                      .consolidatedWeatherList[index]['weather_state_name'];
                  var weatherURL =
                      futureWeatherName.replaceAll(' ', '').toLowerCase();
                  var parsedDate = DateTime.parse(widget
                      .consolidatedWeatherList[index]['applicable_date']);
                  var newDate =
                      DateFormat('EEEE').format(parsedDate).substring(0, 3);

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.only(right: 20),
                    width: 80,
                    decoration: BoxDecoration(
                      color: index == selectedIndex
                          ? Colors.white
                          : const Color(0xff9ebcf9),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                          color: Colors.blue.withOpacity(.3),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Accessing encapsulated data and using it for display.
                        Text(
                          "${widget.consolidatedWeatherList[index]['the_temp'].round()}C",
                          style: TextStyle(
                            fontSize: 17,
                            color: index == selectedIndex
                                ? Colors.blue
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.asset(
                          'assets/$weatherURL.png', // Polymorphism in action (dynamic URL).
                          width: 40,
                        ),
                        Text(
                          newDate,
                          style: TextStyle(
                            fontSize: 17,
                            color: index == selectedIndex
                                ? Colors.blue
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * .55,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Example of modular design (Abstraction).
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

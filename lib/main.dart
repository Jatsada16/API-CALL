import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แอปพยากรณ์อากาศ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'หน้าแรกของแอปพยากรณ์อากาศ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> weatherData = {};
  final TextEditingController _controller = TextEditingController();

  Future<void> fetchWeatherData(String city) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=aee42cb84385ba435fe5715fd08b8aad'));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      throw Exception('ไม่สามารถดึงข้อมูลสภาพอากาศได้');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'กรอกชื่อเมือง',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  fetchWeatherData(_controller.text);
                },
                child: Text('แสดงสภาพอากาศ'),
              ),
              SizedBox(height: 20),
              weatherData.isEmpty
                  ? CircularProgressIndicator()
                  : Column(
                      children: <Widget>[
                        Text(
                          'เมือง: ${weatherData['name']}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          'อุณหภูมิ ปัจจุบัน: ${(weatherData['main']['temp'] - 273.15).toStringAsFixed(2)} °C',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'อุณหภูมิ ต่ำสุด: ${(weatherData['main']['temp_min'] - 273.15).toStringAsFixed(2)} °C',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'อุณหภูมิ สูงสุด: ${(weatherData['main']['temp_max'] - 273.15).toStringAsFixed(2)} °C',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'ความกดอากาศ: ${weatherData['main']['pressure']} hPa',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'ความชื้น: ${weatherData['main']['humidity']}%',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'ระดับน้ำทะเล: ${weatherData['main']['sea_level']} hPa',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'ร้อยละของเมฆ: ${weatherData['clouds']['all']}%',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'ปริมาณฝนใน 1 ชั่วโมงล่าสุด: ${weatherData['rain'] != null ? weatherData['rain']['1h'] : 'ไม่มีข้อมูล'} mm',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'เวลาพระอาทิตย์ตก: ${DateTime.fromMillisecondsSinceEpoch(weatherData['sys']['sunset'] * 1000).toLocal()}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Image.network(
                          'http://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@2x.png',
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

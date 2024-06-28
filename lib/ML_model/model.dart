import 'package:flutter/material.dart';
import 'package:sports_project/ML_model/diabetics..dart';
import 'package:sports_project/ML_model/food_plan.dart';
import 'package:sports_project/component/conest.dart';


class HealthMetricsScreen extends StatefulWidget {

  static String id = 'HealthMetricScreen';

  @override
  _HealthMetricsScreenState createState() => _HealthMetricsScreenState();
}

class _HealthMetricsScreenState extends State<HealthMetricsScreen> {
  var selectedGender;
  var selectedActivity;
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final bmiController = TextEditingController();
  final bmrController = TextEditingController();
  final calorieController = TextEditingController();

  double recommendedCalories = 0;

  void _calculateMetrics() {
    final double weight = double.tryParse(weightController.text) ?? 0;
    final double height = double.tryParse(heightController.text) ?? 0;
    final int age = int.tryParse(ageController.text) ?? 0;

    if (weight > 0 &&
        height > 0 &&
        age > 0 &&
        selectedGender != null &&
        selectedActivity != null) {
      final double bmi = weight / (height * height);
      double bmr;
      if (selectedGender == "Male") {
        bmr = 10 * weight + 6.25 * (height * 100) - 5 * age + 5;
      } else {
        bmr = 10 * weight + 6.25 * (height * 100) - 5 * age - 161;
      }

      double calorieIntake;
      switch (selectedActivity) {
        case "Low":
          calorieIntake = bmr * 1.2;
          break;
        case "Medium":
          calorieIntake = bmr * 1.55;
          break;
        case "High":
          calorieIntake = bmr * 1.725;
          break;
        default:
          calorieIntake = bmr * 1.2;
      }

      setState(() {
        bmiController.text = bmi.toStringAsFixed(2);
        bmrController.text = bmr.toStringAsFixed(2);
        calorieController.text = calorieIntake.toStringAsFixed(2);
        recommendedCalories = calorieIntake;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid values for all fields.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    bmiController.dispose();
    bmrController.dispose();
    calorieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DietPage()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'for High BP and Diabetes',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.arrow_right_alt_outlined,
                      color: kPrimaryColor,
                      size: 50,
                    ),
                    SizedBox(
                        width:
                        5), // Optional: Add some space between the icon and the text
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    Text(
                      "KEEP  IN IDEAL WEIGHT",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: kPrimaryColor,
                      ),
                    ),
                  ]),
                ],
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Age',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 16),
              Container(
                alignment: Alignment.center,
                width: 400,
                height: 50,
                margin: const EdgeInsets.only(left: 40, right: 40),
                padding: const EdgeInsets.only(left: 20, right: 50),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15)),
                child: DropdownButton(
                  hint: Text(
                    "Gender ",
                    style: TextStyle(fontFamily: 'fuzzy'),
                  ),
                  underline: SizedBox(),
                  iconSize: 50,
                  items: ["Male", "Female"]
                      .map((e) => DropdownMenuItem(
                    child: Text("$e"),
                    value: e,
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedGender = val;
                    });
                  },
                  value: selectedGender,
                ),
              ),
              SizedBox(height: 16),
              Container(
                alignment: Alignment.center,
                width: 400,
                height: 50,
                margin: const EdgeInsets.only(left: 40, right: 40),
                padding: const EdgeInsets.only(left: 20, right: 50),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15)),
                child: DropdownButton(
                  hint: Text(
                    "Activity Level",
                  ),
                  underline: SizedBox(),
                  iconSize: 50,
                  items: ["Low", "Medium", "High"]
                      .map((e) => DropdownMenuItem(
                    child: Text("$e"),
                    value: e,
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedActivity = val;
                    });
                  },
                  value: selectedActivity,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Weight (Kg)',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 16),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Height (m)',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _calculateMetrics,
                style: ElevatedButton.styleFrom(
                  foregroundColor: kPrimaryColor, // Background color
                  backgroundColor: Colors.grey[200], // Text color
                  padding: EdgeInsets.symmetric(
                      horizontal: 30, vertical: 10), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(30.0), // Rounded corners
                  ),
                ),
                child: Text('Calculate BMI & BMR & calories'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: bmiController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'BMI',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 16),
              TextField(
                controller: bmrController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'BMR',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 16),
              TextField(
                controller: calorieController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Recommended Calories',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 5),
              MaterialButton(
                color: kPrimaryColor,
                textColor: Colors.white,
                minWidth: 300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodPlanPage(
                        recommendedCalories: recommendedCalories,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Your Plane",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
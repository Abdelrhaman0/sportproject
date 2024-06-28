import 'package:flutter/material.dart';
import 'package:sports_project/ML_model/model.dart';
import 'package:sports_project/component/conest.dart';

class DietPage extends StatefulWidget {
  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  int totalCalories = 0;
  String selectedGender = 'Man';
  int maxCalories = 2500; // Default for Man

  void setGender(String gender) {
    setState(() {
      selectedGender = gender;
      maxCalories = gender == 'Man' ? 2500 : 2200;
      totalCalories = 0; // Reset calories when changing gender
    });
  }

  void addCalories(int calories) {
    if (totalCalories + calories <= maxCalories) {
      setState(() {
        totalCalories += calories;
      });
    } else {
      // Show a message to the user if they exceed the limit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have exceeded your daily calorie limit!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HealthMetricsScreen()),
            );
          },
        ),
        title: Text('Diet Plan for High BP and Diabetes'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGenderSelection(),
            SizedBox(height: 20),
            _buildCalorieTracker(),
            SizedBox(height: 20),
            _buildSectionTitle('Recommended Daily Calories'),
            SizedBox(height: 10),
            _buildCaloriesInfo(),
            SizedBox(height: 20),
            _buildSectionTitle('Diet Plan'),
            SizedBox(height: 10),
            DietSection(
              meal: 'Breakfast',
              items: [
                DietItem('Oatmeal with fresh fruits and nuts', 150),
                DietItem('Whole grain toast with avocado', 120),
                DietItem('Low-fat yogurt with berries', 100),
              ],
              addCalories: addCalories,
            ),
            DietSection(
              meal: 'Lunch',
              items: [
                DietItem('Grilled chicken salad with mixed greens', 300),
                DietItem('Quinoa and vegetable stir-fry', 350),
                DietItem('Lentil soup with whole grain bread', 250),
              ],
              addCalories: addCalories,
            ),
            DietSection(
              meal: 'Dinner',
              items: [
                DietItem('Baked salmon with steamed vegetables', 400),
                DietItem('Brown rice with grilled tofu and broccoli', 350),
                DietItem('Vegetable curry with whole grain rice', 300),
              ],
              addCalories: addCalories,
            ),
            DietSection(
              meal: 'Snacks',
              items: [
                DietItem('Fresh fruit', 50),
                DietItem('Nuts and seeds', 100),
                DietItem('Vegetable sticks with hummus', 80),
                DietItem('Low-fat cheese', 70),
              ],
              addCalories: addCalories,
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Dietary Tips'),
            _buildDietaryTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      children: [
        ListTile(
          title: const Text('Man'),
          leading: Radio<String>(
            value: 'Man',
            groupValue: selectedGender,
            onChanged: (String? value) {
              if (value != null) {
                setGender(value);
              }
            },
          ),
        ),
        ListTile(
          title: const Text('Woman'),
          leading: Radio<String>(
            value: 'Woman',
            groupValue: selectedGender,
            onChanged: (String? value) {
              if (value != null) {
                setGender(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalorieTracker() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Calories Today:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '$totalCalories kcal',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
    );
  }

  Widget _buildCaloriesInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Men: 2,000 - 2,500 kcal/day',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Women: 1,800 - 2,200 kcal/day',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDietaryTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.info, color: Colors.green),
          title: Text('Eat a variety of foods to ensure a balanced diet.'),
        ),
        ListTile(
          leading: Icon(Icons.info, color: Colors.green),
          title: Text('Limit salt intake to reduce blood pressure.'),
        ),
        ListTile(
          leading: Icon(Icons.info, color: Colors.green),
          title: Text('Choose whole grains over refined grains.'),
        ),
        ListTile(
          leading: Icon(Icons.info, color: Colors.green),
          title: Text('Include plenty of fruits and vegetables in your diet.'),
        ),
        ListTile(
          leading: Icon(Icons.info, color: Colors.green),
          title: Text(
              'Opt for lean protein sources such as fish, poultry, and legumes.'),
        ),
      ],
    );
  }
}

class DietSection extends StatelessWidget {
  final String meal;
  final List<DietItem> items;
  final Function(int) addCalories;

  DietSection(
      {required this.meal, required this.items, required this.addCalories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          meal,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...items.map((item) => ListTile(
          leading: Icon(Icons.check, color: Colors.green),
          title: Text(item.name),
          trailing: Text('${item.calories} kcal'),
          onTap: () => addCalories(item.calories),
        )),
        SizedBox(height: 10),
      ],
    );
  }
}

class DietItem {
  final String name;
  final int calories;

  DietItem(this.name, this.calories);
}
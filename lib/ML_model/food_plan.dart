
import 'package:flutter/material.dart';

class FoodPlanPage extends StatefulWidget {
  final double recommendedCalories;

  FoodPlanPage({required this.recommendedCalories});

  @override
  _FoodPlanPageState createState() => _FoodPlanPageState();
}

class _FoodPlanPageState extends State<FoodPlanPage> {
  List<Map<String, dynamic>> selectedMeals = [];
  double totalCalories = 0;

  List<Map<String, dynamic>> meals = [
    {
      "meal": "Breakfast",
      "description":
      "Oatmeal with fresh berries, sliced almonds, and a drizzle of honey",
      "calories": 300,
      "protein": 5,
      "carbs": 55,
      "fat": 7
    },
    {
      "meal": "Snack",
      "description": "Greek yogurt with honey and a handful of granola",
      "calories": 150,
      "protein": 10,
      "carbs": 15,
      "fat": 3
    },
    {
      "meal": "Lunch",
      "description":
      "Grilled chicken breast served with quinoa, mixed greens, cherry tomatoes, and a light vinaigrette",
      "calories": 450,
      "protein": 40,
      "carbs": 30,
      "fat": 15
    },
    {
      "meal": "Snack",
      "description": "Apple slices paired with almond butter",
      "calories": 200,
      "protein": 4,
      "carbs": 25,
      "fat": 10
    },
    {
      "meal": "Dinner",
      "description":
      "Salmon fillet seasoned with herbs and lemon, accompanied by roasted vegetables (zucchini, bell peppers, and carrots)",
      "calories": 500,
      "protein": 35,
      "carbs": 20,
      "fat": 25
    },
    {
      "meal": "Breakfast",
      "description":
      "Scrambled eggs with diced vegetables (bell peppers, spinach, and onions) served on whole wheat toast",
      "calories": 350,
      "protein": 20,
      "carbs": 30,
      "fat": 15
    },
    {
      "meal": "Snack",
      "description":
      "Mixed nuts (almonds, walnuts, and cashews) with dried fruits (raisins and apricots)",
      "calories": 250,
      "protein": 8,
      "carbs": 20,
      "fat": 18
    },
    {
      "meal": "Lunch",
      "description":
      "Turkey and avocado wrap with whole wheat tortilla, fresh spinach, and diced tomatoes",
      "calories": 400,
      "protein": 30,
      "carbs": 40,
      "fat": 15
    },
    {
      "meal": "Snack",
      "description": "Carrot sticks served with hummus dip",
      "calories": 150,
      "protein": 4,
      "carbs": 20,
      "fat": 8
    },
    {
      "meal": "Dinner",
      "description":
      "Grilled steak seasoned with garlic and herbs, served with a side of sweet potato mash and steamed asparagus",
      "calories": 600,
      "protein": 45,
      "carbs": 40,
      "fat": 25
    },
    {
      "meal": "Breakfast",
      "description":
      "Smoothie bowl made with blended mixed berries, topped with granola, chia seeds, and a drizzle of almond butter",
      "calories": 400,
      "protein": 15,
      "carbs": 60,
      "fat": 10
    },
    {
      "meal": "Snack",
      "description":
      "Cheese (cheddar and mozzarella) paired with whole wheat crackers",
      "calories": 300,
      "protein": 12,
      "carbs": 25,
      "fat": 18
    },
    {
      "meal": "Lunch",
      "description":
      "Quinoa salad with chickpeas, cherry tomatoes, cucumbers, red onions, and a lemon-herb dressing",
      "calories": 450,
      "protein": 20,
      "carbs": 60,
      "fat": 15
    },
    {
      "meal": "Snack",
      "description": "Banana with a spread of natural peanut butter",
      "calories": 250,
      "protein": 6,
      "carbs": 30,
      "fat": 12
    },
    {
      "meal": "Dinner",
      "description":
      "Baked chicken thighs seasoned with paprika and thyme, served with brown rice and sautéed green beans",
      "calories": 550,
      "protein": 40,
      "carbs": 45,
      "fat": 20
    },
    {
      "meal": "Breakfast",
      "description":
      "Avocado toast on whole grain bread, topped with sliced tomatoes and a sprinkle of feta cheese",
      "calories": 350,
      "protein": 10,
      "carbs": 30,
      "fat": 20
    },
    {
      "meal": "Snack",
      "description":
      "Trail mix with a mix of dried cranberries, almonds, pumpkin seeds, and dark chocolate chips",
      "calories": 200,
      "protein": 5,
      "carbs": 25,
      "fat": 10
    },
    {
      "meal": "Lunch",
      "description":
      "Spinach and feta stuffed chicken breast served with quinoa and roasted Brussels sprouts",
      "calories": 500,
      "protein": 45,
      "carbs": 30,
      "fat": 25
    },
    {
      "meal": "Snack",
      "description": "Cottage cheese with sliced peaches",
      "calories": 150,
      "protein": 12,
      "carbs": 20,
      "fat": 5
    },
    {
      "meal": "Dinner",
      "description":
      "Pasta with marinara sauce, topped with grilled shrimp, and a side of garlic bread",
      "calories": 600,
      "protein": 30,
      "carbs": 80,
      "fat": 20
    },
  ];

  void _addMeal(Map<String, dynamic> meal) {
    if (totalCalories + meal['calories'] <= widget.recommendedCalories) {
      setState(() {
        selectedMeals.add(meal);
        totalCalories += meal['calories'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${meal['meal']} added to your plan!')),
      );
    } else {
      _showCalorieLimitAlert();
    }
  }

  void _removeMeal(Map<String, dynamic> meal) {
    setState(() {
      selectedMeals.remove(meal);
      totalCalories -= meal['calories'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${meal['meal']} removed from your plan!')),
    );
  }

  void _showCalorieLimitAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Calorie Limit Exceeded"),
          content: Text(
              "Adding this meal will exceed your recommended calorie intake."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.restaurant_menu),
            Text("Recommended Plan"),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your recommended daily calorie is ${widget.recommendedCalories.toStringAsFixed(2)} calories.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Recommended Food Plan:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _generateFoodPlan(),
              ),
            ),
            _calorieSummaryCard(widget.recommendedCalories - totalCalories),
          ],
        ),
      ),
    );
  }

  List<Widget> _generateFoodPlan() {
    return meals.map((meal) {
      bool isSelected = selectedMeals.contains(meal);
      return GestureDetector(
        onTap: () {
          if (isSelected) {
            _removeMeal(meal);
          } else {
            _addMeal(meal);
          }
        },
        child: _foodItem(meal, isSelected),
      );
    }).toList();
  }

  Widget _foodItem(Map<String, dynamic> meal, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          tileColor: isSelected ? Colors.green[50] : Colors.white,
          title: Text(
            meal['meal'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(meal['description'], style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              Text(
                "Protein: ${meal['protein']}g, Carbs: ${meal['carbs']}g, Fat: ${meal['fat']}g",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${meal['calories']} cal",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Icon(
                Icons.local_dining,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _calorieSummaryCard(double remainingCalories) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        color: Colors.green,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Remaining Calories:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "${remainingCalories.toStringAsFixed(2)} calories",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'home_screen.dart';

class FindNowScreen extends StatefulWidget {
  @override
  _FindNowScreenState createState() => _FindNowScreenState();
}

class _FindNowScreenState extends State<FindNowScreen> {
  int _currentQuestionIndex = 0;
  List<String> _answers = List.filled(3, '');

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What type of destination do you prefer?',
      'options': ['Beach', 'Mountains', 'City'],
      'icon': Icons.landscape,
    },
    {
      'question': 'What activities do you enjoy most?',
      'options': ['Water sports', 'Hiking', 'Cultural experiences'],
      'icon': Icons.directions_run,
    },
    {
      'question': 'What is your preferred climate?',
      'options': ['Tropical', 'Cool', 'Moderate'],
      'icon': Icons.wb_sunny,
    },
  ];

  void _selectAnswer(String answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _showRecommendations();
      }
    });
  }

  void _showRecommendations() {
    String recommendation = _getRecommendation();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Recommended Destination',
              style: TextStyle(color: Color(0xFF008575))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recommendation, style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: Text('Try Again',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _currentQuestionIndex = 0;
                        _answers = List.filled(3, '');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF008575),
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Done', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF008575),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _getRecommendation() {
    if (_answers[0] == 'Beach' &&
        _answers[1] == 'Water sports' &&
        _answers[2] == 'Tropical') {
      return 'Boracay: Known for its stunning white beaches and crystal-clear waters, perfect for water sports enthusiasts.';
    } else if (_answers[0] == 'Mountains' &&
        _answers[1] == 'Hiking' &&
        _answers[2] == 'Cool') {
      return 'Baguio City: The Summer Capital of the Philippines, offering cool climate and beautiful mountain trails.';
    } else if (_answers[0] == 'City' &&
        _answers[1] == 'Cultural experiences' &&
        _answers[2] == 'Moderate') {
      return 'Vigan: A UNESCO World Heritage site known for its well-preserved Spanish colonial architecture and rich history.';
    } else {
      return 'Palawan: A diverse destination offering beaches, mountains, and cultural experiences with a tropical climate.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Your Dream Destination'),
        backgroundColor: Color(0xFF008575),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[50]!, Colors.teal[100]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  _questions[_currentQuestionIndex]['icon'],
                  size: 80,
                  color: Color(0xFF008575),
                ),
                SizedBox(height: 30),
                Text(
                  _questions[_currentQuestionIndex]['question'],
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF008575)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ..._questions[_currentQuestionIndex]['options'].map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      child: Text(
                        option,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () => _selectAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF008575),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

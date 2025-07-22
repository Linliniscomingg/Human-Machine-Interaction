import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:workout_fitness/common_widget/round_button.dart';
import 'package:workout_fitness/data/services/Preferences.dart';
import 'package:workout_fitness/view/exercise/exercise_view_2.dart';

import '../../common/color_extension.dart';
import '../../common_widget/exercises_row.dart';
import '../workout/workout_view.dart';
import '../workout/workout_view_2.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> dataArr = [];
  List<Map<String, dynamic>> trainingDayArr = [];
  Map<String, dynamic> userInfo = {};
  bool isLoading = true;

  Map<String, List<bool>> completedExercises = {};

  @override
  void initState() {
    super.initState();
    _loadUserInfoAndWorkoutPlans();
  }

  Future<void> _loadUserInfoAndWorkoutPlans() async {
    // Retrieve user information
    userInfo = Preferences.getUserInfo();

    // Customize workout plans based on user's profile
    setState(() {
      dataArr = _generateWorkoutCategories();
      trainingDayArr = _generateTrainingDays();
      _loadCompletedExercises();
      isLoading = false;
    });
  }

  void _loadCompletedExercises() {
    // Initialize completedExercises for each workout
    for (var workout in trainingDayArr) {
      completedExercises[workout['name']] = List.generate(
          workout['exercises'].length,
              (index) => workout['exercises'][index]['isCompleted'] ?? false
      );
    }
  }

  void _saveExerciseCompletion(String workoutName, int exerciseIndex) {
    setState(() {
      completedExercises[workoutName]![exerciseIndex] = true;
    });
  }

  List<Map<String, dynamic>> _generateWorkoutCategories() {
    // Customize workout categories based on user's injury status and physical condition
    List<Map<String, dynamic>> categories = [
      {
        "name": "Low Impact",
        "image": "assets/img/PelvicTilts.png",
      },
      {
        "name": "Cardio",
        "image": "assets/img/SitExercise.png",
      },
      {
        "name": "Strength",
        "image": "assets/img/CoreExerciseHeelSlide.png",
      }
    ];

    // Filter out inappropriate exercises based on injury status
    if (userInfo['injuryStatus'] != null) {
      switch (userInfo['injuryStatus']) {
        case 1: // Minor injury
          categories = categories.where((cat) => cat['name'] != 'Strength').toList();
          break;
        case 2: // Moderate injury
          categories = categories.where((cat) => cat['name'] == 'Low Impact').toList();
          break;
        case 3: // Serious injury
          categories = []; // No exercise recommended
          break;
      }
    }

    return categories;
  }

  List<Map<String, dynamic>> _generateTrainingDays() {
    // Customize training days based on user's age, weight, and injury status
    List<Map<String, dynamic>> trainingPlans = [
      {
        "name": "Adaptive Workout 1",
        "difficulty": _calculateWorkoutDifficulty(),
        "exercises": _customizeExercises(1),
      },
      {
        "name": "Adaptive Workout 2",
        "difficulty": _calculateWorkoutDifficulty(),
        "exercises": _customizeExercises(2),
      },
      {
        "name": "Recovery Workout",
        "difficulty": "Low",
        "exercises": _customizeExercises(3),
      }
    ];

    return trainingPlans;
  }

  String _calculateWorkoutDifficulty() {
    // Calculate workout difficulty based on user's age and fitness level
    if (userInfo['birthday'] == null) return "Moderate";

    int age = _calculateAge(userInfo['birthday']);

    if (age < 25) return "High";
    if (age < 40) return "Moderate";
    if (age < 55) return "Low";
    return "Very Low";
  }

  int _calculateAge(DateTime birthday) {
    DateTime now = DateTime.now();
    int age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    return age;
  }

  List<Map<String, dynamic>> _customizeExercises(int workoutDay) {
    // Customize exercises based on user's injuries and physical condition
    List<Map<String, dynamic>> baseExercises = [
      {
        "number": "1",
        "title": "Warm-up",
        "time": "5 min",
        "difficulty": "Low",
        "isCompleted": false
      },
      {
        "number": "2",
        "title": "Main Exercise",
        "time": "15-20 min",
        "difficulty": "Moderate",
        "isCompleted": false
      },
      {
        "number": "3",
        "title": "Cool-down",
        "time": "5 min",
        "difficulty": "Low",
        "isCompleted": false
      }
    ];

    // Modify exercises based on specific injuries
    if (userInfo['injuries'] != null) {
      List<String> injuries = userInfo['injuries'] ?? [];
      baseExercises = baseExercises.map((exercise) {
        if (injuries.contains('Knee') && exercise['title'] == 'Main Exercise') {
          exercise['title'] = 'Low-Impact Cardio';
          exercise['time'] = '10 min';
        }
        if (injuries.contains('Back') && exercise['title'] == 'Main Exercise') {
          exercise['title'] = 'Gentle Stretching';
          exercise['time'] = '15 min';
        }
        return exercise;
      }).toList();
    }

    return baseExercises;
  }

  void _markFirstExerciseCompleted(String workoutName, String exerciseTitle) {
    // Add the completed exercise to SharedPreferences
    Preferences.addCompletedExercise(exerciseTitle);

    // Update the UI to reflect the completed exercise
    setState(() {
      for (var workout in trainingDayArr) {
        if (workout['name'] == workoutName) {
          for (int i = 0; i < workout['exercises'].length; i++) {
            var exercise = workout['exercises'][i];
            if (exercise['title'] == exerciseTitle) {
              exercise['isCompleted'] = true;
              completedExercises[workoutName]![i] = true;
              break;
            }
          }
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    // Ensure completedExercises is initialized before using
    if (completedExercises.isEmpty) {
      _loadCompletedExercises();
    }

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: TColor.primary),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0.1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              "assets/img/black_white.png",
              width: 25,
              height: 25,
            )),
        title: Text(
          "Personalized Fitness Plan",
          style: TextStyle(
              color: TColor.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Workout Categories Carousel
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: SizedBox(
                width: media.width,
                height: media.width * 0.2,
                child: dataArr.isEmpty
                    ? Center(child: Text("No suitable workout categories", style: TextStyle(color: TColor.secondaryText)))
                    : CarouselSlider.builder(
                  options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 0.5,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.65,
                      enlargeFactor: 0.4,
                      enlargeStrategy: CenterPageEnlargeStrategy.zoom),
                  itemCount: dataArr.length,
                  itemBuilder: (BuildContext context, int itemIndex, int index) {
                    var dObj = dataArr[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2)),
                          ]),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(dObj["image"].toString(),
                                width: double.maxFinite,
                                height: double.maxFinite,
                                fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              dObj["name"].toString(),
                              style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Training Days Carousel
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: media.width,
                height: media.width * 1.1,
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 0.6,
                      enlargeCenterPage: true,
                      viewportFraction: 0.85,
                      enableInfiniteScroll: false,
                      enlargeFactor: 0.4,
                      enlargeStrategy: CenterPageEnlargeStrategy.zoom),
                  itemCount: trainingDayArr.length,
                  itemBuilder: (BuildContext context, int itemIndex, int index) {
                    var tObj = trainingDayArr[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2)),
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            tObj["name"].toString(),
                            style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Difficulty: ${tObj['difficulty']}",
                            style: TextStyle(
                                color: TColor.secondaryText.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          ...List.generate(
                              (tObj['exercises'] as List).length,
                                  (exerciseIndex) {
                                var exercise = (tObj['exercises'] as List)[exerciseIndex];
                                return ExercisesRow(
                                  number: exercise['number'],
                                  title: exercise['title'],
                                  time: exercise['time'],
                                  isActive: exerciseIndex == 0 &&
                                      !completedExercises[tObj['name']]![exerciseIndex],
                                  isCompleted: completedExercises[tObj['name']]![exerciseIndex],
                                  isLast: exerciseIndex == (tObj['exercises'] as List).length - 1,
                                  onPressed: () {},
                                );
                              }),
                          const Spacer(),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: RoundButton(
                                title: "Start",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ExerciseView2(),
                                    ),
                                  ).then((_) {
                                    // When returning from ExerciseView2, mark the first exercise as completed
                                    _markFirstExerciseCompleted(tObj['name'], tObj['exercises'][0]['title']);
                                  });
                                }
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
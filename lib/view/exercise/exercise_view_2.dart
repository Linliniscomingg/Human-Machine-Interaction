import 'package:flutter/material.dart';
import 'package:workout_fitness/view/workout/workout_detail_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/tab_button.dart';
import '../../data/services/Preferences.dart';

class ExerciseView2 extends StatefulWidget {
  const ExerciseView2({super.key});

  @override
  State<ExerciseView2> createState() => _ExerciseView2State();
}

class _ExerciseView2State extends State<ExerciseView2> {
  int isActiveTab = 0;
  List recommendedWorkouts = [];

  List kneeWorkouts = [
    {
      "name": "Straight Leg Raises",
      "imageUrl": "assets/img/StraightLegRaise.png",
      "videoUrl": "assets/video/StraightLegRaise.mp4",
      "description":
          "A fundamental rehabilitation exercise that targets the quadriceps muscles without putting stress on the knee joint. This exercise is particularly effective in the early stages of recovery as it helps maintain muscle strength while protecting the knee. The controlled lifting motion helps rebuild muscle memory and stability, making it essential for patients recovering from knee surgery or injury.",
      "difficulty": 1
    },
    {
      "name": "Heel Slides",
      "imageUrl": "assets/img/CoreExerciseHeelSlide.png",
      "videoUrl": "assets/video/CoreExerciseHeelSlide.mp4",
      "description":
          "A gentle yet effective exercise that focuses on regaining knee mobility and flexibility. It's one of the safest ways to begin restoring range of motion after knee surgery or injury. The sliding motion helps maintain the natural movement patterns of the knee while minimizing stress on the joint, making it an excellent starting point for rehabilitation.",
      "difficulty": 1
    },
    {
      "name": "Wall Sits",
      "imageUrl": "assets/img/SitExercise.png",
      "videoUrl": "assets/video/SitExercise.mp4",
      "description":
          "A functional strengthening exercise that builds endurance in the muscles supporting the knee. This exercise mimics common daily activities like sitting and standing, making it particularly valuable for returning to normal activities. It's an excellent progression exercise once basic strength and stability have been established.",
      "difficulty": 2
    },
  ];

  List backWorkouts = [
    {
      "name": "Bird Dog",
      "imageUrl": "assets/img/DogBird.png",
      "videoUrl": "assets/video/DogBird.mp4",
      "description":
          "A stabilization exercise that enhances core strength and spinal balance while training coordination. Named for its resemblance to a hunting dog's pointing stance, this exercise simultaneously works the back and abdominal muscles. It's particularly effective for developing core stability and improving posture, making it valuable for both rehabilitation and injury prevention.",
      "difficulty": 1
    },
    {
      "name": "Pelvic Tilts",
      "imageUrl": "assets/img/PelvicTilts.png",
      "videoUrl": "assets/video/PelvicTilts.mp4",
      "description":
          "A gentle, foundational exercise that focuses on developing awareness and control of the pelvis and lower back position. This movement helps reconnect the brain with core muscles that may have become inhibited due to pain or injury. It's often used as a starting point in back rehabilitation programs due to its subtle yet effective nature.",
      "difficulty": 1
    },
    {
      "name": "Back Bridge",
      "imageUrl": "assets/img/CoreExerciseBridge.png",
      "videoUrl": "assets/video/CoreExerciseBridge.mp4",
      "description":
          "A fundamental strength exercise that targets multiple muscle groups in the posterior chain. This exercise strengthens the entire back side of the body while being gentle on the spine. It's particularly effective for developing gluteal strength and improving the stability of the lower back, making it valuable for both rehabilitation and general fitness.",
      "difficulty": 2
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadRecommendedWorkouts();
  }

  void _loadRecommendedWorkouts() {
    // Retrieve user information
    final userInfo = Preferences.getUserInfo();

    // Extract relevant information
    final injuryStatus = userInfo['injuryStatus'] ?? 0;
    final injuries = userInfo['injuries'] ?? [];

    // Initialize recommended workouts list
    List recommendations = [];

    print(Preferences.getJwtSecret());
    // In chi tiết thông tin để kiểm tra
    print("Injury Status: $injuryStatus");
    print("Injuries: $injuries");

    // Gợi ý bài tập dựa trên loại chấn thương
    if (injuries != null && injuries.isNotEmpty) {
      if (injuries.contains('Knee')) {
        recommendations = kneeWorkouts
            .where((workout) => _filterByInjuryStatus(workout, injuryStatus))
            .toList();
        isActiveTab = 0; // Set tab to Knee exercises
      } else if (injuries.contains('Back')) {
        recommendations = backWorkouts
            .where((workout) => _filterByInjuryStatus(workout, injuryStatus))
            .toList();
        isActiveTab = 1; // Set tab to Back exercises
      }
    }

    // Nếu không có bài tập nào được gợi ý, sử dụng bài tập mặc định
    if (recommendations.isEmpty) {
      switch (injuryStatus) {
        case 0: // Không có chấn thương
          recommendations = kneeWorkouts;
          break;
        case 1: // Chấn thương nhẹ
          recommendations = kneeWorkouts
              .where((workout) => workout['difficulty'] == 1)
              .toList();
          break;
        case 2: // Chấn thương nặng
          recommendations = kneeWorkouts
              .where((workout) => workout['difficulty'] <= 1)
              .toList();
          break;
        default:
          recommendations = kneeWorkouts;
      }
    }

    // Cập nhật state với các bài tập được gợi ý
    setState(() {
      recommendedWorkouts = recommendations;
    });
  }

// Hàm phụ trợ để lọc bài tập dựa trên mức độ tổn thương
  bool _filterByInjuryStatus(Map workout, int injuryStatus) {
    switch (injuryStatus) {
      case 0: // Không có chấn thương
        return true;
      case 1: // Chấn thương nhẹ
        return workout['difficulty'] == 1;
      case 2: // Chấn thương nặng
        return workout['difficulty'] <= 1;
      default:
        return true;
    }
  }

  List get currentWorkouts => recommendedWorkouts.isNotEmpty
      ? recommendedWorkouts
      : (isActiveTab == 0 ? kneeWorkouts : backWorkouts);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: TColor.primary,
        centerTitle: true,
        elevation: 0,
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
          "Exercise",
          style: TextStyle(
              color: TColor.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: TColor.white, boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
            ]),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TabButton2(
                    title: "Knee",
                    isActive: isActiveTab == 0,
                    onPressed: () {
                      setState(() {
                        isActiveTab = 0;
                        recommendedWorkouts = kneeWorkouts
                            .where((workout) => workout['difficulty'] == 1)
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TabButton2(
                    title: "Back",
                    isActive: isActiveTab == 1,
                    onPressed: () {
                      setState(() {
                        isActiveTab = 1;
                        recommendedWorkouts = backWorkouts
                            .where((workout) => workout['difficulty'] == 1)
                            .toList();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: ListView.builder(
                  key: ValueKey<int>(isActiveTab),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemCount: currentWorkouts.length,
                  itemBuilder: (context, index) {
                    var wObj = currentWorkouts[index] as Map? ?? {};
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WorkoutDetailView(workoutData: wObj)));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  wObj["imageUrl"].toString(),
                                  width: media.width,
                                  height: media.width * 0.45,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  width: media.width,
                                  height: media.width * 0.45,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    wObj["name"],
                                    style: TextStyle(
                                        color: TColor.secondaryText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WorkoutDetailView(
                                                        workoutData: wObj)));
                                      },
                                      icon: Image.asset("assets/img/more.png",
                                          width: 20, height: 20))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

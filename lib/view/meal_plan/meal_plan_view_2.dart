import 'package:flutter/material.dart';
import 'package:workout_fitness/data/services/Preferences.dart';

import '../../common/color_extension.dart';
import '../../common_widget/tab_button.dart';

class MealPlanView2 extends StatefulWidget {
  const MealPlanView2({super.key});

  @override
  State<MealPlanView2> createState() => _MealPlanView2State();
}

class _MealPlanView2State extends State<MealPlanView2> {
  int isActiveTab = 0;
  List recommendedMeals = [];

  // Danh sách các loại thực phẩm phù hợp với từng chấn thương
  List dietaryRecommendations = [
    // Chế độ ăn cho chấn thương đầu gối
    {
      'injury_type': 'knee',
      'meals': [
        {
          "name": "Anti-Inflammatory Breakfast",
          "title": "Salmon, Spinach, Turmeric Smoothie",
          "image": "assets/img/f1.png",
          "benefits": "Reduces inflammation, supports joint health"
        },
        {
          "name": "Joint Recovery Snack",
          "title": "Chia Seeds, Berries, Almond Milk",
          "image": "assets/img/f2.png",
          "benefits": "High in omega-3, supports bone strength"
        },
        {
          "name": "Protein-Rich Lunch",
          "title": "Grilled Chicken, Quinoa, Roasted Vegetables",
          "image": "assets/img/f3.png",
          "benefits": "Muscle recovery, low inflammation"
        }
      ]
    },
    // Chế độ ăn cho chấn thương lưng
    {
      'injury_type': 'back',
      'meals': [
        {
          "name": "Back Health Breakfast",
          "title": "Eggs, Avocado, Whole Grain Toast",
          "image": "assets/img/f1.png",
          "benefits": "Supports muscle repair, reduces inflammation"
        },
        {
          "name": "Spine Support Snack",
          "title": "Walnuts, Yogurt, Honey",
          "image": "assets/img/f2.png",
          "benefits": "Calcium-rich, supports bone health"
        },
        {
          "name": "Recovery Dinner",
          "title": "Salmon, Sweet Potato, Broccoli",
          "image": "assets/img/f4.png",
          "benefits": "Omega-3, antioxidants for healing"
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadPersonalizedMealPlan();
  }

  void _loadPersonalizedMealPlan() {
    // Lấy thông tin người dùng
    final userInfo = Preferences.getUserInfo();

    // Trích xuất thông tin liên quan
    final injuryStatus = userInfo['injuryStatus'] ?? 0;
    final injuries = userInfo['injuries'] ?? [];

    print("Injury Status: $injuryStatus");
    print("Injuries: $injuries");

    // Khởi tạo danh sách các bữa ăn được đề xuất
    List recommendations = [];

    // Gợi ý dựa trên loại chấn thương
    if (injuries != null && injuries.isNotEmpty) {
      for (var injury in injuries) {
        final matchingDiet = dietaryRecommendations.firstWhere(
                (diet) => diet['injury_type'] == injury,
            orElse: () => dietaryRecommendations[0]
        );

        // Lọc bữa ăn dựa trên mức độ chấn thương
        recommendations = _filterMealsByInjuryStatus(matchingDiet['meals'], injuryStatus);

        // Nếu tìm thấy bữa ăn, dừng vòng lặp
        if (recommendations.isNotEmpty) break;
      }
    }

    // Nếu không có bữa ăn nào được gợi ý, sử dụng mặc định
    if (recommendations.isEmpty) {
      recommendations = _getDefaultMeals(injuryStatus);
    }

    // Cập nhật state
    setState(() {
      recommendedMeals = recommendations;
    });
  }

  List _filterMealsByInjuryStatus(List meals, int injuryStatus) {
    switch (injuryStatus) {
      case 0: // Không có chấn thương
        return meals;
      case 1: // Chấn thương nhẹ
        return meals.take(2).toList(); // Chọn 2 bữa ăn đầu tiên
      case 2: // Chấn thương nặng
        return meals.take(1).toList(); // Chọn bữa ăn đầu tiên
      default:
        return meals;
    }
  }

  List _getDefaultMeals(int injuryStatus) {
    switch (injuryStatus) {
      case 0:
        return dietaryRecommendations[0]['meals'];
      case 1:
        return dietaryRecommendations[0]['meals'].take(2).toList();
      case 2:
        return dietaryRecommendations[0]['meals'].take(1).toList();
      default:
        return dietaryRecommendations[0]['meals'];
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
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
          "Meal Plan",
          style: TextStyle(
              color: TColor.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(children: [
        Container(
          decoration: BoxDecoration(color: TColor.white, boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
          ]),
          child: Row(
            children: [

            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //   child: Row(
        //     children: [
        //       IconButton(
        //         onPressed: () {},
        //         icon: Image.asset(
        //           "assets/img/black_fo.png",
        //           width: 20,
        //           height: 20,
        //         ),
        //       ),
        //       Expanded(
        //         child: Text(
        //           "Sunday, AUG 26",
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //               color: TColor.secondaryText,
        //               fontSize: 20,
        //               fontWeight: FontWeight.w700),
        //         ),
        //       ),
        //       IconButton(
        //         onPressed: () {},
        //         icon: Image.asset(
        //           "assets/img/next_go.png",
        //           width: 20,
        //           height: 20,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              itemCount: recommendedMeals.length,
              itemBuilder: (context, index) {
                var mealObj = recommendedMeals[index] as Map? ?? {};
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(color: TColor.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          mealObj["image"].toString(),
                          width: media.width,
                          height: media.width * 0.55,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        mealObj["name"],
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        mealObj["title"],
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14),
                      ),
                      Text(
                        "Benefits: ${mealObj["benefits"]}",
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ]),
    );
  }
}
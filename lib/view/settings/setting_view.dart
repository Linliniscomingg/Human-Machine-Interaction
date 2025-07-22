import 'package:flutter/material.dart';
import 'package:workout_fitness/common_widget/setting_select_row.dart';
import 'package:workout_fitness/common_widget/setting_switch_row.dart';
import 'package:workout_fitness/view/settings/connect_view.dart';
import 'package:workout_fitness/view/settings/select_language_view.dart';
import '../../common/color_extension.dart';
import '../../data/services/Preferences.dart';
import '../login/on_boarding_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  List settingArr = [
    {"name": "Reminders", "type": "switch", "value": "false"},
    {"name": "Language", "type": "select", "value": "ENGLISH"},
    {"name": "Connected", "type": "select", "value": "Facebook"},
    {"name": "Warm-Up", "type": "switch", "value": "false"},
    {"name": "Cool-Down", "type": "switch", "value": "false"},
  ];

  void _logOut() async {
    bool isCleared = await Preferences.clearPreferences();
    if (isCleared) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingView()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error logging out. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: TColor.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemBuilder: (context, index) {
                var tObj = settingArr[index] as Map? ?? {};

                if (tObj["type"] == "switch") {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SettingSwitchRow(
                      tObj: tObj,
                      onChanged: (newVal) {
                        settingArr[index]["value"] = newVal ? "true" : "false";
                        setState(() {});
                      },
                    ),
                  );
                } else if (tObj["type"] == "select") {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SettingSelectRow(
                      tObj: tObj,
                      onPressed: () {
                        if (tObj["name"] == "Language") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectLanguageView(
                                didSelect: (newVal) {},
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConnectView(
                                didSelect: (newVal) {},
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.black26,
                  thickness: 1,
                  height: 16,
                );
              },
              itemCount: settingArr.length,
            ),
          ),
        ],
      ),
    );
  }
}
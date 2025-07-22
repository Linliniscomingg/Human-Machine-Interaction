import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:math';


class Constraint {
  final PoseLandmarkType joint;
  final PoseLandmarkType p1;
  final PoseLandmarkType p2;
  final double targetAngle;
  final double tolerance;
  final String message;

  const Constraint({
    required this.joint,
    required this.p1,
    required this.p2,
    required this.targetAngle,
    this.tolerance = 15,
    required this.message,
  });

  bool check(Pose pose) =>
      (_calculateAngle(pose.landmarks[joint]!, pose.landmarks[p1]!, pose.landmarks[p2]!) - targetAngle).abs() <= tolerance;

  double _calculateAngle(PoseLandmark joint, PoseLandmark p1, PoseLandmark p2) {
    final v1 = Point(p1.x - joint.x, p1.y - joint.y);
    final v2 = Point(p2.x - joint.x, p2.y - joint.y);

    final dot = v1.x * v2.x + v1.y * v2.y;
    final mag1 = sqrt(v1.x * v1.x + v1.y * v1.y);
    final mag2 = sqrt(v2.x * v2.x + v2.y * v2.y);

    return acos(dot / (mag1 * mag2)) * 180 / pi;
  }
}
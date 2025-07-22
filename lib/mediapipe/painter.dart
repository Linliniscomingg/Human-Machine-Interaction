import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';


class PosePainter extends CustomPainter {
  final Pose pose;
  final Size imageSize;
  final Size screenSize;
  final Color color;

  PosePainter({
    required this.pose,
    required this.imageSize,
    required this.screenSize,
    required this.color
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = color;

    pose.landmarks.forEach((key, point) {
      final scaledPoint = Offset(
        screenSize.width - point.x * screenSize.width / imageSize.width,
        point.y * screenSize.height / imageSize.height,
      );
      canvas.drawCircle(scaledPoint, 4, paint);
    });

    _drawPoseConnections(canvas, pose, paint);
  }

  void _drawPoseConnections(Canvas canvas, Pose pose, Paint paint) {
    void drawLine(PoseLandmarkType from, PoseLandmarkType to) {
      final fromPoint = pose.landmarks[from];
      final toPoint = pose.landmarks[to];
      if (fromPoint != null && toPoint != null) {
        final scaledFrom = Offset(
          screenSize.width - fromPoint.x * screenSize.width / imageSize.width,
          fromPoint.y * screenSize.height / imageSize.height,
        );
        final scaledTo = Offset(
          screenSize.width - toPoint.x * screenSize.width / imageSize.width,
          toPoint.y * screenSize.height / imageSize.height,
        );
        canvas.drawLine(scaledFrom, scaledTo, paint);
      }
    }


    // face
    drawLine(PoseLandmarkType.leftEar, PoseLandmarkType.leftEye);
    drawLine(PoseLandmarkType.leftEye, PoseLandmarkType.nose);
    drawLine(PoseLandmarkType.rightEar, PoseLandmarkType.rightEye);
    drawLine(PoseLandmarkType.rightEye, PoseLandmarkType.nose);
    drawLine(PoseLandmarkType.leftMouth, PoseLandmarkType.rightMouth);


    // torso
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
    drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);


    // arms
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    drawLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
    drawLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftThumb);
    drawLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftIndex);
    drawLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftPinky);
    drawLine(PoseLandmarkType.leftIndex, PoseLandmarkType.leftPinky);

    drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
    drawLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
    drawLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightThumb);
    drawLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightIndex);
    drawLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightPinky);
    drawLine(PoseLandmarkType.rightIndex, PoseLandmarkType.rightPinky);


    // legs
    drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
    drawLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
    drawLine(PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel);
    drawLine(PoseLandmarkType.leftAnkle, PoseLandmarkType.leftFootIndex);
    drawLine(PoseLandmarkType.leftHeel, PoseLandmarkType.leftFootIndex);

    drawLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
    drawLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
    drawLine(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel);
    drawLine(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightFootIndex);
    drawLine(PoseLandmarkType.rightHeel, PoseLandmarkType.rightFootIndex);
  }

  @override
  bool shouldRepaint(PosePainter oldDelegate) => oldDelegate.imageSize != imageSize || oldDelegate.pose != pose;
}
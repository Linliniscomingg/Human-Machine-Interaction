import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'constraint.dart';


class Action {
  final List<Constraint> constraints;
  final Duration holdTime;

  const Action({
    required this.constraints,
    this.holdTime = const Duration(seconds: 1),
  });

  String? check(Pose pose) {
    for (final constraint in constraints) {
      if (!constraint.check(pose)) return constraint.message;
    }

    return null;
  }
}
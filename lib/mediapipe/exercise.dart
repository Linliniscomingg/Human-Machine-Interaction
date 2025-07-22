import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'action.dart';


class Exercise {
  final String name;
  final int requiredReps;
  final List<Action> actions;

  int _completedReps = 0;
  int _currentActionIndex = 0;
  DateTime? _holdStartTime;

  Exercise({
    required this.name,
    required this.requiredReps,
    required this.actions
  });

  String? checkProgress(Pose pose) {
    if (_completedReps >= requiredReps) return null;

    final currentAction = actions[_currentActionIndex];
    final message = currentAction.check(pose);

    if (message == null) {
      _holdStartTime ??= DateTime.now();

      if (DateTime.now().difference(_holdStartTime!) >= currentAction.holdTime) {
        _holdStartTime = null;
        _currentActionIndex = (_currentActionIndex + 1) % actions.length;

        if (_currentActionIndex == 0) _completedReps++;
      }
    } else {
      _holdStartTime = null;
    }

    return message;
  }

  bool get isCompleted => _completedReps >= requiredReps;
  int get currentReps => _completedReps;

  void reset() {
    _completedReps = 0;
    _currentActionIndex = 0;
    _holdStartTime = null;
  }
}
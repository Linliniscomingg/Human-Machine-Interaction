import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:workout_fitness/mediapipe/painter.dart';
import 'package:workout_fitness/mediapipe/exercise.dart';


class DoExerciseView extends StatefulWidget {
  final Exercise exercise;
  const DoExerciseView({super.key, required this.exercise});

  @override
  State createState() => _DoExerciseViewState();
}

class _DoExerciseViewState extends State<DoExerciseView> {
  CameraController? controller;
  final poseDetector = PoseDetector(options: PoseDetectorOptions(
    mode: PoseDetectionMode.stream,
    model: PoseDetectionModel.accurate
  ));
  bool _isProcessing = false;
  Pose? _pose;
  String _feedback = 'No pose detected!';
  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    poseDetector.close();
    controller?.stopImageStream();
    controller?.dispose();
    widget.exercise.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.exercise.name} - ${widget.exercise.currentReps}/${widget.exercise.requiredReps} Reps'),
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
      body: Stack(
        children: [
          Transform.scale(
            scale: 2 / controller!.value.aspectRatio,
            child: Center(child: CameraPreview(controller!)),
          ),
          if (_pose != null) CustomPaint(
              painter: PosePainter(
                pose: _pose!,
                imageSize: _getImageSize(),
                screenSize: MediaQuery.of(context).size,
                color: _feedback == 'Hold still...' || widget.exercise.isCompleted ? Colors.green : Colors.red
              )
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _feedback,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]
      ),
    );
  }

  Future _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('No cameras found');

      controller = CameraController(
        cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21
      );

      await controller!.initialize();
      await controller!.startImageStream(_processImage);

      if (mounted) setState(() {});

    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isProcessing) return;

    _isProcessing = true;
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }

      final inputImage = InputImage.fromBytes(
        bytes: allBytes.done().buffer.asUint8List(),
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: _getImageRotation(),
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final poses = await poseDetector.processImage(inputImage);
      if (poses.isNotEmpty) {
        final feedback = widget.exercise.isCompleted
          ? 'Exercise Completed!'
          : widget.exercise.checkProgress(poses.first);
        if (mounted) {
          setState(() {
            _pose = poses.first;
            _feedback = feedback ?? 'Hold still...';
          });
        }
      } else if (mounted) {
        setState(() {
          _pose = null;
          _feedback = 'No pose detected!';
        });
      }
    } catch (e) {
      _showError(e);
    } finally {
      _isProcessing = false;
    }
  }

  Size _getImageSize() {
    final Size(:width, :height) = controller!.value.previewSize!;
    final isLandscape =
        controller!.value.deviceOrientation == DeviceOrientation.landscapeLeft
        || controller!.value.deviceOrientation == DeviceOrientation.landscapeRight;

    return isLandscape ? Size(width, height) : Size(height, width);
  }

  InputImageRotation _getImageRotation() {
    final sensorOrientation = controller!.description.sensorOrientation;
    final rotationCompensation = _orientations[controller!.value.deviceOrientation]!;
    return InputImageRotationValue.fromRawValue((sensorOrientation + rotationCompensation) % 360)!;
  }

  void _showError(dynamic e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
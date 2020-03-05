import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


List<CameraDescription> cameras;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<CameraDescription> cameras;
  CameraController controller;
  bool isReady= false;
  bool showCamera = true;
  String imagePath;


  @override
  void initState() {
    super.initState();
    setupCamera();
  }

  Future<void> setupCamera() async{
    try{
      cameras = await availableCameras();
      controller = new CameraController(cameras.first, ResolutionPreset.medium);
      await controller.initialize();
    }on CameraException catch(_){
      setState(() {
        isReady = false;
      });
    }

    setState(() {
      isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        elevation: 0,
        title: Text("Sign up"),
      ),
      body:  Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: showCamera
                      ? Container(
                    height: 290,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Center(child:  cameraPreviewWidget()),
                    ),
                  )
                      : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        imagePreviewWidget(),
                        editCaptureControlRowWidget(),
                      ]),
                ),
                showCamera ? captureControlRowWidget() : Container(),
               cameraOptionsWidget(),
                //beerInfoInputsWidget()
              ],
            ),
          ),
        ),

    );
  }

  Widget cameraPreviewWidget() {

    if (!isReady || !controller.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );

  }

  Widget imagePreviewWidget() {
    return Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: imagePath == null
                ? null
                : SizedBox(
              child: Image.file(File(imagePath) ),
              height: 290.0,
            ),
          ),
        ));
  }

  Widget editCaptureControlRowWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Align(
        alignment: Alignment.topCenter,
        child: IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.black12,
          onPressed: () => setState(() {
            showCamera = true;
          }),
        ),
      ),
    );
  }

  Widget captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null && controller.value.isInitialized
              ? onTakePictureButtonPressed
              : null,
        ),
      ],
    );
  }

  Widget cameraOptionsWidget() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showCamera ? cameraTogglesRowWidget() : Container(),
        ],
      ),
    );
  }


  Widget cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    if (cameras != null) {
      if (cameras.isEmpty) {
        return const Text('No camera found');
      } else {
        for (CameraDescription cameraDescription in cameras) {
          toggles.add(
            SizedBox(
              width: 90.0,
              child: RadioListTile<CameraDescription>(
                title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
                groupValue: controller?.description,
                value: cameraDescription,
                onChanged: controller != null ? onNewCameraSelected : null,
              ),
            ),
          );
        }
      }
    }

    return Row(children: toggles);
  }



  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          showCamera = false;
          imagePath = filePath;
        });
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/test_app_android';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      return null;
    }
    return filePath;
  }

  String timestamp() {
    return new DateTime.now().millisecondsSinceEpoch.toString();
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
       // showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      //showInSnackBar('Camera error ${e}');
    }

    if (mounted) {
      setState(() {});
    }
  }

  IconData getCameraLensIcon(CameraLensDirection lensDirection) {
    switch(lensDirection){

      case CameraLensDirection.front:
        return Icons.camera_front;
        break;
      case CameraLensDirection.back:
        return Icons.camera_rear;
        break;
      case CameraLensDirection.external:
        return Icons.camera_alt;
        break;
    }
  }

}



import 'dart:io';
import 'dart:typed_data';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/message_model.dart';
import 'package:sports_project/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

class ChatDetailsScreen extends StatefulWidget {
  ChatDetailsScreen({this.userModel});

  static String id = 'ChatDetailsScreen';
  UserModel? userModel;

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        ProjectCubit.get(context).getMassage(receiverId: widget.userModel!.uid);

        return BlocConsumer<ProjectCubit, ProjectStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var massageController = TextEditingController();
            var now = DateTime.now();

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                titleSpacing: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                      NetworkImage('${widget.userModel!.image}'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('${widget.userModel!.name}')
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (BuildContext context) => Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            var massage =
                            ProjectCubit.get(context).massages[index];
                            if (ProjectCubit.get(context).userModel!.uid ==
                                massage.senderId) {
                              return buildMyMassage(massage);
                            } else {
                              return buildMassage(massage);
                            }
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                          itemCount: ProjectCubit.get(context).massages.length,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Color(0xFFE0E0E0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: TextFormField(
                                    controller: massageController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Type your message...',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.image, color: kPrimaryColor),
                              onPressed: () => _pickImage(context),
                            ),
                            IconButton(
                              icon: Icon(Icons.video_library,
                                  color: kPrimaryColor),
                              onPressed: () => _pickVideo(context),
                            ),
                            IconButton(
                              onPressed: () {
                                ProjectCubit.get(context).sendMassage(
                                  text: massageController.text,
                                  receiverId: widget.userModel!.uid.toString(),
                                  dateTime: now.toString(),
                                  imageBytes: null,
                                  videoBytes: null,
                                );
                                massageController.clear();
                              },
                              icon: Icon(
                                Icons.send,
                                size: 30,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (BuildContext context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      ProjectCubit.get(context).sendMassage(
        text: '',
        receiverId: widget.userModel!.uid,
        dateTime: DateTime.now().toString(),
        imageBytes: bytes,
        videoBytes: null,
      );
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final bytes = await video.readAsBytes();
      ProjectCubit.get(context).sendMassage(
        text: '',
        receiverId: widget.userModel!.uid,
        dateTime: DateTime.now().toString(),
        imageBytes: null,
        videoBytes: bytes,
      );
    }
  }

  Widget buildMassage(MassageModel model) {
    if (model.imageBytes != null && model.imageBytes!.isNotEmpty) {
      return buildImageMessage(model);
    } else if (model.videoBytes != null && model.videoBytes!.isNotEmpty) {
      return buildVideoMessage(model);
    } else {
      return buildTextMessage(model);
    }
  }

  Widget buildTextMessage(MassageModel model) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
        color: Colors.grey[300],
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text('${model.text}'),
    ),
  );

  Widget buildImageMessage(MassageModel model) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
        color: Colors.grey[300],
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Image.memory(model.imageBytes!),
    ),
  );

  Widget buildVideoMessage(MassageModel model) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
        color: Colors.grey[300],
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: VideoPlayerWidget(videoBytes: model.videoBytes!),
    ),
  );

  Widget buildMyMassage(MassageModel model) {
    if (model.imageBytes != null && model.imageBytes!.isNotEmpty) {
      return buildMyImageMessage(model);
    } else if (model.videoBytes != null && model.videoBytes!.isNotEmpty) {
      return buildMyVideoMessage(model);
    } else {
      return buildMyTextMessage(model);
    }
  }

  Widget buildMyTextMessage(MassageModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          bottomStart: Radius.circular(10),
        ),
        color: kPrimaryColor.withOpacity(.3),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text('${model.text}'),
    ),
  );

  Widget buildMyImageMessage(MassageModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          bottomStart: Radius.circular(10),
        ),
        color: kPrimaryColor.withOpacity(.3),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Image.memory(model.imageBytes!),
    ),
  );

  Widget buildMyVideoMessage(MassageModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          bottomStart: Radius.circular(10),
        ),
        color: kPrimaryColor.withOpacity(.3),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: VideoPlayerWidget(videoBytes: model.videoBytes!),
    ),
  );
}


class VideoPlayerWidget extends StatefulWidget {
  final Uint8List? videoBytes;
  final String? videoUrl;

  VideoPlayerWidget({this.videoBytes, this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoBytes != null) {
      _initializeVideoFromMemory(widget.videoBytes!);
    } else if (widget.videoUrl != null) {
      _initializeVideoFromNetwork(widget.videoUrl!);
    } else {
      throw ArgumentError('Either videoBytes or videoUrl must be provided.');
    }
  }

  void _initializeVideoFromMemory(Uint8List videoBytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_video.mp4');
    await tempFile.writeAsBytes(videoBytes);

    _controller = VideoPlayerController.file(tempFile)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
      });
  }

  void _initializeVideoFromNetwork(String videoUrl) {
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(_controller),
          ControlsOverlay(controller: _controller),
          VideoProgressIndicator(_controller, allowScrubbing: true),
        ],
      ),
    )
        : Center(child: CircularProgressIndicator());
  }
}

class ControlsOverlay extends StatelessWidget {
  const ControlsOverlay({Key? key, required this.controller}) : super(key: key);

  static const _iconSize = 30.0;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? Container(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.pause,
                color: Colors.white,
                size: _iconSize,
              ),
            ),
          )
              : Container(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: _iconSize,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}



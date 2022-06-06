import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../model/exerciseModel.dart';

class ThardPage extends StatefulWidget {
  ThardPage({Key? key, this.exerciseModel, this.second}) : super(key: key);
  ExerciseModel? exerciseModel;
  int? second;

  @override
  State<ThardPage> createState() => _ThardPageState();
}

class _ThardPageState extends State<ThardPage> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  bool isPlyaing = false;
  bool isComplite = false;
  int startSound = 0;
  String audioPath = 'audio.mp3';
  late Timer timer;
  void playAudio() async {
    await audioCache.play(audioPath);
    print('playing');
  }

  @override
  void initState() {
    // TODO: implement initState
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick == widget.second) {
        timer.cancel();
        setState(() {
          isComplite == true;
          playAudio();
          Navigator.of(context).pop();
        });
      }
      setState(() {
        startSound = timer.tick;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.exerciseModel!.title}',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 450,
            width: double.infinity,
            child: CachedNetworkImage(
              height: double.infinity,
              width: double.infinity,
              imageUrl: '${widget.exerciseModel!.gif}',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              color: Colors.pink,
              height: 70,
              child: Text(
                '${startSound} / ${widget.second!.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

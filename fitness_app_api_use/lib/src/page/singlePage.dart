import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app_api_use/src/page/thardPage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../model/exerciseModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widget/spinkitWidget.dart';

class SinglePage extends StatefulWidget {
  SinglePage({Key? key, this.exerciseModel}) : super(key: key);

  ExerciseModel? exerciseModel;
  @override
  State<SinglePage> createState() => _SinglePageState();
}

class _SinglePageState extends State<SinglePage> {
  final link =
      'https://raw.githubusercontent.com/codeifitech/fitness-app/master/exercises.json?fbclid=IwAR1pqgjE9CRWnVidv9qVcKSqhu6p131013uHlLzJCroOqvqLC0X-rgnG4m0';
  List<ExerciseModel> allData = [];
  late ExerciseModel exerciseModel;
  bool isLoding = false;

  faceData() async {
    try {
      setState(() {
        isLoding = true;
      });
      var responce = await http.get(Uri.parse(link));
      print('status code is ${responce.statusCode}');

      print('..........................');
      print('all data is ${responce.body}');

      if (responce.statusCode == 200) {
        final item = jsonDecode(responce.body);
        for (var data in item['exercises']) {
          exerciseModel = ExerciseModel(
            id: data['id'],
            title: data['title'],
            thumbnail: data['thumbnail'],
            seconds: data['seconds'],
            gif: data['gif'],
          );
          setState(() {
            allData.add(exerciseModel);
          });
        }
        setState(() {
          isLoding = false;
        });
      }
    } catch (e) {
      print('something wrong $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    faceData();
    super.initState();
  }

  double second = 3;
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
            height: 380,
            child: Stack(children: [
              CachedNetworkImage(
                width: double.infinity,
                height: double.infinity,
                imageUrl: '${widget.exerciseModel!.thumbnail}',
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: SleekCircularSlider(
                  innerWidget: (value) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${second.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                  appearance: CircularSliderAppearance(
                      customColors: CustomSliderColors(
                          dotColor: Colors.black,
                          progressBarColor: Colors.pink),
                      customWidths: CustomSliderWidths(progressBarWidth: 10)),
                  min: 3,
                  max: 30,
                  initialValue: second,
                  onChange: (v) {
                    setState(() {
                      second = v;
                    });
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                left: 100,
                right: 100,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ThardPage(
                          exerciseModel: widget.exerciseModel,
                          second: second.toInt(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  color: Colors.pinkAccent,
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              height: 250,
              width: double.infinity,
              child: ModalProgressHUD(
                inAsyncCall: isLoding == true,
                progressIndicator: spinkit,
                child: Container(
                  width: 300,
                  height: 130,
                  child: ListView.builder(
                      itemCount: allData.length,
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SinglePage(
                                      exerciseModel: allData[index],
                                    )));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            height: 200,
                            width: 220,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(children: [
                                CachedNetworkImage(
                                  width: double.infinity,
                                  imageUrl: '${allData[index].thumbnail}',
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    height: 70,
                                    width: double.infinity,
                                    child: Text(
                                      '${allData[index].title}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    alignment: Alignment.bottomLeft,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromRGBO(195, 176, 185, 0.071),
                                          Color.fromARGB(96, 104, 142, 180),
                                          Color.fromARGB(137, 75, 129, 155),
                                          Color.fromARGB(221, 38, 105, 134),
                                          Color.fromARGB(255, 24, 109, 109),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

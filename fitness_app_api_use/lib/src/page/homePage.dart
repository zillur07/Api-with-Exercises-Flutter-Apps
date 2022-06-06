import 'dart:convert';

import 'package:fitness_app_api_use/src/page/singlePage.dart';
import 'package:fitness_app_api_use/src/widget/spinkitWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../model/exerciseModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      //print('all data is ${responce.body}');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UZZAL GYM',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoding == true,
        progressIndicator: spinkit,
        child: Container(
          width: double.infinity,
          child: ListView.builder(
              itemCount: allData.length,
              shrinkWrap: true,
              primary: false,
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
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    height: 180,
                    width: double.infinity,
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
                                fontSize: 20,
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
                                  Colors.black12,
                                  Colors.black38,
                                  Colors.black54,
                                  Colors.black87,
                                  Colors.black,
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
    );
  }
}

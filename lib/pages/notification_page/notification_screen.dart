import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  static const id = ' ';
  const NotificationScreen({super.key, required this.payload});

  final String payload;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Get.back,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          _payload.toString().split('|')[0],
          style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Column(
              children: [
                Text(
                  'Hello, Boda',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 26.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'You have a new reminder',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      margin: const EdgeInsets.all(12.0),
                      height: 600,
                      width: double.infinity,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.title,
                                size: 28.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                'Title',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Title',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.description,
                                size: 28.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                'description',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'description',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 28.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                'Date',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            '10 : 20',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
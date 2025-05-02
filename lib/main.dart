import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter_markdown/flutter_markdown.dart';

void main() => runApp(HacoPrivacyTermsApp());

/// {@template main}
/// HacoPrivacyTermsApp widget.
/// {@endtemplate}
class HacoPrivacyTermsApp extends StatelessWidget {
  /// {@macro main}
  const HacoPrivacyTermsApp({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PrivacyTermsScreen(),
    );
  }
}

/// {@template main}
/// PrivacyTermsScreen widget.
/// {@endtemplate}
class PrivacyTermsScreen extends StatefulWidget {
  /// {@macro main}
  const PrivacyTermsScreen({
    super.key, // ignore: unused_element
  });

  @override
  State<PrivacyTermsScreen> createState() => PrivacyTermsScreenState();
}

/// State for widget PrivacyTermsScreen.
class PrivacyTermsScreenState extends State<PrivacyTermsScreen> {
  final _srollController = ScrollController();

  late Future<PrivacyTerms> futurePrivacyTerms;

  @override
  void initState() {
    futurePrivacyTerms = getPrivacyTerms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futurePrivacyTerms,
        builder: (context, snapshot) {
          final privacyTerms = snapshot.data;
          if (snapshot.hasData) {
            final data = privacyTerms!.result.map((e) => e.content).toString();
            return Scrollbar(
              controller: _srollController,
              child: Markdown(controller: _srollController, data: data),
            );
          }

          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<PrivacyTerms> getPrivacyTerms() async {
    final response = await Dio().get(
      'http://157.90.227.125:8000/api/v1/privacy-terms',
    );

    return PrivacyTerms.fromJson(response.data);
  }
}

PrivacyTerms privacyTermsFromJson(String str) =>
    PrivacyTerms.fromJson(json.decode(str));

String privacyTermsToJson(PrivacyTerms data) => json.encode(data.toJson());

class PrivacyTerms {
  bool status;
  String message;
  List<Result> result;

  PrivacyTerms({
    required this.status,
    required this.message,
    required this.result,
  });

  factory PrivacyTerms.fromJson(Map<String, dynamic> json) => PrivacyTerms(
    status: json["status"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  int privacyTermsId;
  String type;
  String content;
  String status;

  Result({
    required this.privacyTermsId,
    required this.type,
    required this.content,
    required this.status,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    privacyTermsId: json["privacy_terms_id"],
    type: json["type"],
    content: json["content"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "privacy_terms_id": privacyTermsId,
    "type": type,
    "content": content,
    "status": status,
  };
}

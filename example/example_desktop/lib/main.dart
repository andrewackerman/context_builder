// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:context_builder/context_builder.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';

void main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MySubPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MySubPage extends StatelessWidget {
  MySubPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ContextProvider(
        scaleBehavior: ScaleBehavior.horizontal,
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final ctx = ContextProvider.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'OS: ${ctx.os}',
          ),
          Text(
            'isMobile: ${ctx.isMobile}',
          ),
          Text(
            'isDesktop: ${ctx.isDesktop}',
          ),
          Text(
            'isFuschia: ${ctx.isFuschia}',
          ),
          Text(
            'isWeb: ${ctx.isWeb}',
          ),
          SizedBox(height: 16),
          Text(
            'Screen Size: ${ctx.screenSize}',
          ),
          Text(
            'Raw Screen Size: ${ctx.rawScreenSize}',
          ),
          Text(
            'Orientation: ${ctx.orientation}',
          ),
          SizedBox(height: 16),
          Text(
            'Unscaled Text - 16pt',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            'Normalized Scaled Text - 16pt',
            style: TextStyle(
              fontSize: ctx.scaleFont(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

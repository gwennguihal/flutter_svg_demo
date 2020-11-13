import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SVG Lag Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GoScreen(),
    );
  }
}

class GoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: RaisedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SplashScreen(),
              ),
            ),
            child: Text('GO'),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _preloadThenLaunch();
    });
  }

  Future<void> _preloadThenLaunch() async {
    final svgs = ['assets/onboarding_1.svg', 'assets/onboarding_2.svg'];
    await Future.wait(svgs.map(_preloadSVG));
    print('preloaded');
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OnBoarding1Screen(),
      ),
    );
  }

  Future<void> _preloadSVG(String path) {
    print(path);
    return precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoder,
        path,
      ),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PreLoading'),
      ),
      body: Center(
        child: Text('preload...'),
      ),
    );
  }
}

class OnBoarding1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: Column(children: [
            SvgPicture.asset('assets/onboarding_1.svg'),
            RaisedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OnBoarding2Screen(),
                ),
              ),
              child: Text('Next'),
            )
          ]),
        ),
      ),
    );
  }
}

class OnBoarding2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: Column(children: [
            SvgPicture.asset('assets/onboarding_2.svg'),
          ]),
        ),
      ),
    );
  }
}

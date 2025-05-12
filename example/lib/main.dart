// This is a simple single-file example for quick startup. You can find an interactive version in the repository

import 'package:flutter/material.dart';
import 'package:universal_back_gesture/universal_back_gesture.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universal Back Gesture Demo',
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            for (final platform in TargetPlatform.values)
              platform: BackGesturePageTransitionsBuilder(
                parentTransitionBuilder:
                    const FadeForwardsPageTransitionsBuilder(),
                config: BackGestureConfig(),
              ),
          },
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universal Back Gesture Demo')),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => const DemoPage(
                          title: 'Global PageTransition',
                          text:
                              'Simple MaterialPageRoute (with fullscreen back gesture)',
                        ),
                  ),
                );
              },
              child: const Text('Global PageTransition'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  CustomBackGesturePageRoute(
                    parentTransitionBuilder:
                        const CupertinoPageTransitionsBuilder(),
                    builder:
                        (context) => const DemoPage(
                          title: 'Cupertino fullscreen back gesture',
                          text:
                              'Cupertino page transition with fullscreen back gesture',
                        ),
                    config: BackGestureConfig(
                      swipeTransitionRange: GestureMeasurement.percentage(1),
                      //_kDroppedSwipePageAnimationDuration from CupertinoPageRoute
                      commitAnimationDuration: Duration(milliseconds: 350),
                    ),
                  ),
                );
              },
              child: const Text('Cupertino fullscreen back gesture'),
            ),
          ],
        ),
      ),
    );
  }
}

class DemoPage extends StatefulWidget {
  final String title;
  final String text;

  const DemoPage({super.key, required this.title, required this.text});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  bool canPop = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        extendBodyBehindAppBar: true,
        body: Center(
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder:
                      (_, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Chip(label: Text('Chip N${index + 1}')),
                      ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  canPop = !canPop;
                  setState(() {});
                },
                child: Text('canPop: $canPop'),
              ),
              Text(widget.text),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBackGesturePageRoute<T> extends MaterialPageRoute<T> {
  final BackGestureConfig config;

  final PageTransitionsBuilder parentTransitionBuilder;

  CustomBackGesturePageRoute({
    required super.builder,
    required this.config,
    required this.parentTransitionBuilder,
    super.settings,
  });

  @override
  DelegatedTransitionBuilder? get delegatedTransition =>
      parentTransitionBuilder.delegatedTransition;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return BackGesturePageTransitionsBuilder(
      parentTransitionBuilder: parentTransitionBuilder,
      config: config,
    ).buildTransitions<T>(this, context, animation, secondaryAnimation, child);
  }
}

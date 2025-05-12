import 'package:flutter/material.dart';

enum TransitionType {
  fadeForwards('Fade Forwards', FadeForwardsPageTransitionsBuilder()),
  cupertino('Cupertino', CupertinoPageTransitionsBuilder()),
  zoom('Zoom', ZoomPageTransitionsBuilder()),
  fade('Fade Upwards', FadeUpwardsPageTransitionsBuilder()),
  slideUp('Slide Up', OpenUpwardsPageTransitionsBuilder());

  final String name;
  final PageTransitionsBuilder builder;

  const TransitionType(this.name, this.builder);
}


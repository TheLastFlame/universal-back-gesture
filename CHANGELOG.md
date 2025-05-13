## 2.1.0

* Added ability to override reverseTransitionDuration
* commitAnimationDuration now uses reverseTransitionDuration as default value
* Changed default value for swipeTransitionRange from 40% of screen width to 150dp (for most transition builders, binding to screen width for gesture is wrong)

## 2.0.1

* Update README

## 2.0.0

* Breaking Change: swipeVelocityThreshold is now double instead of GestureMeasurement (since setting swipe speed as a percentage of screen width doesn't make sense)
* Updated Web Demo, now it provides an interactive site with instant customization of transition parameters

## 1.1.0

* Fix compatibility with older versions of flutter

## 1.0.0

* Initial Release
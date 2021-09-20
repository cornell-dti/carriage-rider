import 'dart:math';

// from https://stackoverflow.com/a/50992575
String ordinal(int num) {
  List<String> suffixes = ['th', 'st', 'nd', 'rd', 'th'];
  String suffix = suffixes[min(num % 10, 4)];
  int mod = num % 100;
  if (11 <= mod && mod <= 13) {
    suffix = 'th';
  }
  return num.toString() + suffix;
}
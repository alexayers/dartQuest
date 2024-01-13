import '../application/globalState.dart';

var keyboardInput = (
  escape: 27,
  space: 32,
  up: 38,
  down: 40,
  left: 37,
  right: 39,
  enter: 13,
  delete: 8,
  shift: 16,
  one: 49,
  two: 50,
  three: 51,
  four: 52,
  five: 53,
  six: 54,
  seven: 55,
  eight: 56,
  nine: 57,
  zero: 48,
  a: 65,
  b: 66,
  c: 67,
  d: 68,
  e: 69,
  f: 70,
  g: 71,
  h: 72,
  i: 73,
  j: 74,
  k: 75,
  l: 76,
  m: 77,
  n: 78,
  o: 79,
  p: 80,
  q: 81,
  r: 82,
  s: 83,
  t: 84,
  u: 85,
  v: 86,
  w: 87,
  x: 88,
  y: 89,
  z: 90,
);

bool isKeyDown(int keyCode) {
  if (GlobalState.hasState("KEY_$keyCode")) {
    return GlobalState.getState('KEY_$keyCode');
  } else {
    return false;
  }
}

void flushKeys() {
  GlobalState.removeWhere("KEY");
}

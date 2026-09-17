import 'dart:async';

void main() {
  print('1: start (synchronous)');

  // Future() schedules a callback on the EVENT queue
  Future(() => print('4: future callback (event queue)'));

  // scheduleMicrotask() schedules a callback on the MICROTASK queue,
  // which always runs before the event queue
  scheduleMicrotask(() => print('2: microtask'));

  print('3: end of synchronous code');

}
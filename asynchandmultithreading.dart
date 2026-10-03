/// ============================================================================
/// ASYNCHRONOUS PROGRAMMING & MULTITHREADING IN DART: MASTERCLASS
/// ============================================================================
/// This file covers:
///  1. Dart Event Loop Architecture (Microtask Queue vs Event Queue)
///  2. Future API (`Future.delayed`, `Future.wait`, `Future.any`)
///  3. `async` and `await` (Sequential vs Concurrent execution)
///  4. Stream API (Single-Subscription vs Broadcast Streams, `async*` generators, `await for`)
///  5. StreamControllers & Sinks
///  6. Isolates: Real Multithreading & CPU Parallelism (`Isolate.run`, `ReceivePort`, `SendPort`)
///
/// For each topic:
///  - Working runnable examples
///  - Architectural mental models & execution flow
///  - Cross-language comparisons (JavaScript, Java, C++, Python asyncio, Go Goroutines, Rust)
/// ============================================================================

import 'dart:async';
import 'dart:isolate';

void main() async {
  print('===============================================================');
  print('     ASYNC & MULTITHREADING IN DART: MASTERCLASS REFERENCE     ');
  print('===============================================================\n');

  demonstrateEventLoopQueues();
  await demonstrateFutureApi();
  await demonstrateAsyncAwait();
  await demonstrateStreamsAndGenerators();
  await demonstrateStreamController();
  await demonstrateIsolatesAndParallelism();

  print('\n===============================================================');
  print('     ASYNC & MULTITHREADING DEMONSTRATIONS COMPLETED           ');
  print('===============================================================');
}

// ============================================================================
// 1. Dart Event Loop Architecture (Microtask vs Event Queue)
// ============================================================================
/// EXPLANATION:
/// Dart runs in a single thread with an Event Loop managing two priority queues:
///
/// 1. Microtask Queue (High Priority):
///    - Handled BEFORE the event queue.
///    - Internal framework tasks, `scheduleMicrotask(() => ...)`, `Future.microtask()`.
///    - If microtasks keep queueing, they can starve the event queue.
///
/// 2. Event Queue (Normal Priority):
///    - I/O events (network, file reads, timers, UI touch events).
///    - Futures created via `Future(...)` or `Future.delayed(...)`.
///
/// EXECUTION ORDER:
/// Synchronous Code -> Microtask Queue (all) -> Event Queue (one item) -> Microtask Queue (all) -> ...
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript: Identical architecture to JS Event Loop (Microtasks: `Promise.then`, `queueMicrotask` vs Macrotasks: `setTimeout`, I/O).
/// - vs Java/C++: Traditional Java/C++ code relies on preemptive multi-threading where OS switches threads.
///   Dart's event loop uses cooperative event-driven multitasking.
void demonstrateEventLoopQueues() {
  print('--- 1. Event Loop Queues (Microtask vs Event Queue) ---');

  print('  [Sync 1] Main synchronous execution starts');

  // Event Queue item
  Future(() {
    print('  [Event Queue] Future callback executed');
  });

  // Microtask Queue item (Higher priority than standard Future!)
  scheduleMicrotask(() {
    print('  [Microtask Queue] Microtask callback executed (runs before Event Queue!)');
  });

  print('  [Sync 2] Main synchronous execution ends');
  print('');
}

// ============================================================================
// 2. Future API (Future.delayed, Future.wait, Future.any)
// ============================================================================
/// EXPLANATION:
/// `Future<T>` represents a computation that will produce a value of type `T` (or an error)
/// at some point in the future.
///
/// KEY & IMPORTANT POINTS:
/// 1. States of a Future:
///    - Uncompleted (pending)
///    - Completed with a value
///    - Completed with an error
/// 2. Combinators:
///    - `Future.wait([f1, f2, f3])`: Runs multiple futures concurrently in parallel; resolves when ALL complete.
///    - `Future.any([f1, f2])`: Resolves as soon as the FIRST future completes (race).
///    - `Future.delayed(duration, callback)`: Executes after a time delay.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript: Equivalent to `Promise`, `Promise.all()`, `Promise.race()`.
/// - vs Java: Equivalent to `CompletableFuture<T>`.
/// - vs C#: Equivalent to `Task<T>`, `Task.WhenAll()`, `Task.WhenAny()`.
/// - vs Rust: Equivalent to `Future` in Tokio / `futures::future::join_all`.
Future<void> demonstrateFutureApi() async {
  print('--- 2. Future API Combinators ---');

  Future<String> fetchUser() async {
    await Future.delayed(Duration(milliseconds: 30));
    return 'User: Alice';
  }

  Future<int> fetchNotificationCount() async {
    await Future.delayed(Duration(milliseconds: 20));
    return 5;
  }

  // Future.wait: Concurrent parallel fetching
  print('  Starting concurrent Future.wait...');
  var results = await Future.wait([fetchUser(), fetchNotificationCount()]);
  print('  Future.wait resolved both: ${results[0]} (String), ${results[1]} (int)');

  // Future.any: First to finish wins
  Future<String> fastServer = Future.delayed(Duration(milliseconds: 10), () => 'Response from US-East');
  Future<String> slowServer = Future.delayed(Duration(milliseconds: 50), () => 'Response from EU-Central');

  String fastestResponse = await Future.any([fastServer, slowServer]);
  print('  Future.any winner: $fastestResponse');
  print('');
}

// ============================================================================
// 3. async and await
// ============================================================================
/// EXPLANATION:
/// `async` and `await` provide declarative, sequential syntax for asynchronous code,
/// avoiding callback hell (`.then().then().then()`).
///
/// KEY & IMPORTANT POINTS:
/// 1. An `async` function always returns a `Future<T>`.
/// 2. `await` pauses the execution of the surrounding `async` function until the Future completes.
/// 3. While paused at `await`, the underlying thread is NOT blocked; it processes other events on the event loop!
/// 4. Error handling uses standard `try-catch-finally`.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript / TypeScript: Exactly identical syntax and behavior.
/// - vs Python: Python `async def` and `await` (in `asyncio`).
/// - vs C#: C# `async Task` and `await`.
Future<String> queryDatabase(String query) async {
  await Future.delayed(Duration(milliseconds: 25));
  return 'Result for "$query"';
}

Future<void> demonstrateAsyncAwait() async {
  print('--- 3. async and await ---');

  try {
    print('  Starting async database query...');
    String rowData = await queryDatabase('SELECT * FROM orders WHERE id = 42');
    print('  Query finished: $rowData');
  } catch (e) {
    print('  Query failed: $e');
  } finally {
    print('  Database query lifecycle finished.');
  }
  print('');
}

// ============================================================================
// 4. Stream API (Streams, async* Generators, await for)
// ============================================================================
/// EXPLANATION:
/// `Stream<T>` is a sequence of asynchronous events (data items or errors) over time.
/// Think of a `Future` as returning a single value asynchronously, and a `Stream`
/// as returning MULTIPLE values asynchronously.
///
/// TWO TYPES OF STREAMS:
/// 1. Single-Subscription Stream: Can be listened to only ONCE (e.g. reading a file or HTTP response).
/// 2. Broadcast Stream: Can have MULTIPLE listeners simultaneously (e.g. mouse clicks, WebSocket feed).
///
/// KEY & IMPORTANT POINTS:
/// 1. `async*` functions use `yield` to emit items over time (Asynchronous Generator).
/// 2. `await for (var item in stream)` loop processes stream items sequentially as they arrive.
/// 3. Stream methods: `.map()`, `.where()`, `.take()`, `.distinct()`, `.listen()`.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Rx / ReactiveX: Streams are built directly into Dart's standard library (equivalent to `Observable<T>`).
/// - vs JavaScript: JS Async Iterators `for await (const x of iterable)` and Async Generators `async function*`.
/// - vs Kotlin: Kotlin `Flow<T>`.
/// - vs Java: Java 9 `Flow.Publisher<T>` / Project Reactor.
Stream<int> periodicSensorReadings(int maxReadings) async* {
  for (int i = 1; i <= maxReadings; i++) {
    await Future.delayed(Duration(milliseconds: 15));
    yield i * 10; // Emit temperature reading
  }
}

Future<void> demonstrateStreamsAndGenerators() async {
  print('--- 4. Streams & async* Generators ---');

  print('  Consuming stream via "await for":');
  await for (var reading in periodicSensorReadings(3)) {
    print('    Sensor reading: ${reading}°C');
  }

  // Stream transformations
  print('  Transforming stream with .where and .map:');
  var stream = periodicSensorReadings(4)
      .where((temp) => temp >= 20)
      .map((temp) => 'ALERT: High Temp $temp°C');

  await for (var alert in stream) {
    print('    $alert');
  }
  print('');
}

// ============================================================================
// 5. StreamControllers & Sinks
// ============================================================================
/// EXPLANATION:
/// A `StreamController<T>` is an object that allows you to manually produce and manage a Stream.
///
/// KEY & IMPORTANT POINTS:
/// 1. `controller.sink.add(data)`: Pushes a new data event into the stream.
/// 2. `controller.sink.addError(err)`: Pushes an error into the stream.
/// 3. `controller.stream`: The stream that listeners can subscribe to.
/// 4. `controller.close()`: Closes the stream when no further data will be emitted.
/// 5. Always remember to close StreamControllers to prevent memory leaks!
Future<void> demonstrateStreamController() async {
  print('--- 5. StreamController & Sinks ---');

  // Broadcast StreamController allowing multiple listeners
  StreamController<String> chatController = StreamController<String>.broadcast();

  // Listener 1 (UI Display)
  var sub1 = chatController.stream.listen((message) {
    print('    [UI Listener] Displaying message: "$message"');
  });

  // Listener 2 (Analytics Logger)
  var sub2 = chatController.stream.listen((message) {
    print('    [Analytics Listener] Logged chat message length: ${message.length}');
  });

  // Sending messages via Sink
  chatController.sink.add('Hello Flutter team!');
  chatController.sink.add('Dart 3.x is super fast.');

  // Yield to allow stream events to be delivered
  await Future.delayed(Duration(milliseconds: 20));

  await sub1.cancel();
  await sub2.cancel();
  await chatController.close();
  print('  ChatController closed safely.');
  print('');
}

// ============================================================================
// 6. Isolates: Real Multithreading & CPU Parallelism
// ============================================================================
/// EXPLANATION:
/// All Dart code runs inside ISOLATES.
/// An Isolate is an independent worker with its OWN PRIVATE MEMORY HEAP and its own Event Loop.
///
/// WHY ISOLATES INSTEAD OF THREADS?
/// 1. Zero Shared State: Because memory is not shared between Isolates, there are NO race conditions,
///    NO memory corruption bugs, and NO need for mutex locks or `synchronized` blocks!
/// 2. Communication: Isolates communicate strictly by passing messages (via `SendPort` and `ReceivePort`).
/// 3. True Multi-Core CPU Parallelism: Background Isolates run concurrently on separate CPU cores.
///
/// MODERN DART HELPER: `Isolate.run()` (Dart 2.19+)
/// Spawns a background isolate, runs a heavy computation function, sends back the result,
/// and tears down the isolate automatically with zero boilerplate!
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java/C++: Traditional threads share memory (`synchronized`, `std::mutex`). Race conditions are frequent.
///   Dart isolates follow the Actor Model (like Erlang and Akka).
/// - vs Go: Go Goroutines share memory with channels/mutexes. Dart Isolates have completely segregated memory heaps.
/// - vs JavaScript: Web Workers / Worker Threads. `Isolate.run()` is vastly simpler than Web Worker message passing.
int _heavyFibonacci(int n) {
  if (n <= 1) return n;
  return _heavyFibonacci(n - 1) + _heavyFibonacci(n - 2);
}

Future<void> demonstrateIsolatesAndParallelism() async {
  print('--- 6. Isolates (Multi-core Parallelism) ---');

  int fibTarget = 35;
  print('  Offloading heavy CPU computation (Fibonacci $fibTarget) to background Isolate...');

  // Running CPU-heavy task on a separate CPU core without freezing the main thread:
  int result = await Isolate.run(() => _heavyFibonacci(fibTarget));

  print('  Background Isolate finished: Fibonacci($fibTarget) = $result');
  print('');
}

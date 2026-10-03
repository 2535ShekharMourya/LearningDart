/// ============================================================================
/// EXCEPTION HANDLING IN DART: COMPREHENSIVE GUIDE & REFERENCE
/// ============================================================================
/// This file covers:
///  1. Exceptions vs Errors (Recoverable vs Programmatic Bugs)
///  2. Throwing (throw & rethrow)
///  3. Try, On, Catch, and Finally Blocks
///  4. StackTrace Capturing & Preserving
///  5. Custom Exceptions & Errors
///  6. Asynchronous Exception Handling (Futures & Streams)
///  7. Best Practices & Anti-Patterns
///
/// For each topic:
///  - Working runnable examples
///  - In-depth explanations
///  - Cross-language comparisons (Java, Python, JavaScript, Go, Rust, C++)
/// ============================================================================

import 'dart:async';

void main() async {
  print('===============================================================');
  print('       EXCEPTION HANDLING IN DART: MASTERCLASS REFERENCE       ');
  print('===============================================================\n');

  demonstrateExceptionsVsErrors();
  demonstrateTryOnCatchFinally();
  demonstrateRethrowAndStackTrace();
  demonstrateCustomExceptions();
  await demonstrateAsyncExceptionHandling();

  print('\n===============================================================');
  print('       EXCEPTION HANDLING COMPLETED SUCCESSFULLY               ');
  print('===============================================================');
}

// ============================================================================
// 1. Exceptions vs Errors
// ============================================================================
/// EXPLANATION:
/// Dart strictly distinguishes between `Exception` and `Error`:
///
/// 1. `Exception`:
///    - Represents conditions that a reasonable application should plan for and catch.
///    - Examples: `FormatException` (invalid user input), `HttpException` (network failure),
///      `TimeoutException` (operation timed out), `FileSystemException`.
///
/// 2. `Error`:
///    - Represents programmatic failures, developer mistakes, and system-level bugs.
///    - Code should be FIXED rather than caught.
///    - Examples: `ArgumentError` (invalid argument), `RangeError` (index out of bounds),
///      `TypeError` (type mismatch), `StateError` (calling method on invalid object state),
///      `NoSuchMethodError`, `OutOfMemoryError`.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java: Java has Checked Exceptions (e.g. `IOException` must be declared in `throws` signature)
///   and Unchecked Exceptions (`RuntimeException`). Dart has NO checked exceptions! All Dart exceptions
///   are unchecked.
/// - vs JavaScript: JS uses `Error` for everything (`TypeError`, `RangeError`, custom errors).
/// - vs Python: Python uses `Exception` hierarchy (`ValueError`, `KeyError`, `TypeError`).
/// - vs Rust/Go: Rust uses `Result<T, E>` and `panic!`. Go uses explicit error returns `(res, err)`.
void demonstrateExceptionsVsErrors() {
  print('--- 1. Exceptions vs Errors ---');

  // Example of an Exception (Recoverable user input issue)
  try {
    int parsed = int.parse('not_a_number');
    print('Parsed: $parsed');
  } on FormatException catch (e) {
    print('  [Exception Caught] FormatException (recoverable): ${e.message}');
  }

  // Example of an Error (Programmatic index mistake)
  try {
    List<int> items = [1, 2, 3];
    int invalidItem = items[10]; // Out of bounds!
    print('Item: $invalidItem');
  } on RangeError catch (e) {
    print('  [Error Caught] RangeError (developer bug): ${e.message}');
  }
  print('');
}

// ============================================================================
// 2. Try, On, Catch, and Finally Blocks
// ============================================================================
/// EXPLANATION:
/// 1. `try`: Encloses code that might throw an exception.
/// 2. `on ExceptionType`: Filters and catches ONLY exceptions of that specific type (or subtype).
/// 3. `catch (e, stackTrace)`: Captures the exception object (`e`) and stack trace (`stackTrace`).
/// 4. `finally`: ALWAYS runs after `try` and `catch`, regardless of whether an exception occurred
///    or a `return` statement was executed. Used for closing files, network connections, and freeing resources.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript: In JS, `try { ... } catch (e) { ... }` catches everything indiscriminately;
///   JS does not support `on SpecificType` syntax.
/// - vs Python: Python uses `except SpecificType as e:`. Dart's `on Type catch (e)` is identical.
/// - vs Java: Java uses `catch (SpecificType e)`.
void demonstrateTryOnCatchFinally() {
  print('--- 2. Try, On, Catch, and Finally Blocks ---');

  void processInput(String input) {
    print('  Processing input: "$input"');
    try {
      if (input.isEmpty) {
        throw ArgumentError('Input string cannot be empty');
      }
      int value = int.parse(input);
      if (value < 0) {
        throw FormatException('Negative numbers not supported');
      }
      print('    Success! Valid value: $value');
    } on FormatException catch (e) {
      print('    Caught FormatException: ${e.message}');
    } on ArgumentError catch (e) {
      print('    Caught ArgumentError: ${e.message}');
    } catch (e) {
      print('    Caught Unknown fallback exception: $e');
    } finally {
      print('    [Finally Block] Cleanup executed for "$input"');
    }
  }

  processInput('42');
  processInput('-10');
  processInput('');
  print('');
}

// ============================================================================
// 3. Rethrow & Preserving StackTrace
// ============================================================================
/// EXPLANATION:
/// When an exception is caught, logged or partially handled, you may want to propagate
/// it up the call stack to outer handlers.
///
/// CRITICAL BEST PRACTICE:
/// - ALWAYS use `rethrow;`
/// - NEVER use `throw e;` when propagating!
///   `throw e;` resets the stack trace to the catch block location, erasing the original origin line!
///   `rethrow;` preserves the pristine original stack trace.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java/C#: In C#, writing `throw;` preserves stack trace while `throw ex;` resets it.
///   In Dart, `rethrow;` is used.
/// - vs Python: Python `raise` with no arguments re-raises preserving stack.
void demonstrateRethrowAndStackTrace() {
  print('--- 3. Rethrow & Preserving StackTrace ---');

  void lowLevelDatabaseQuery() {
    throw TimeoutException('Database query timed out after 5000ms');
  }

  void serviceLayerCall() {
    try {
      lowLevelDatabaseQuery();
    } on TimeoutException catch (e) {
      print('  [Service Layer] Logged error: $e. Propagating via rethrow...');
      rethrow; // Preserves original origin stack trace!
    }
  }

  try {
    serviceLayerCall();
  } catch (e, stackTrace) {
    print('  [UI Controller Layer] Final catch: $e');
    // First line of stack trace shows the original throw site:
    String firstTraceLine = stackTrace.toString().split('\n').first;
    print('  [StackTrace Origin] $firstTraceLine');
  }
  print('');
}

// ============================================================================
// 4. Custom Exceptions & Errors
// ============================================================================
/// EXPLANATION:
/// To create domain-specific exceptions, implement the `Exception` or `Error` interface.
///
/// KEY & IMPORTANT POINTS:
/// 1. Custom Exceptions should implement `Exception`.
/// 2. Always override `toString()` to provide human-readable diagnostic messages.
/// 3. Include relevant fields (e.g. HTTP status code, field name, timestamps).
class PaymentDeclinedException implements Exception {
  final String cardLastFour;
  final double amount;
  final String reason;

  PaymentDeclinedException({
    required this.cardLastFour,
    required this.amount,
    required this.reason,
  });

  @override
  String toString() =>
      'PaymentDeclinedException: Card ending in $cardLastFour for \$$amount was declined. Reason: $reason';
}

void demonstrateCustomExceptions() {
  print('--- 4. Custom Exceptions ---');

  void chargeCard(String last4, double amount) {
    if (amount > 500) {
      throw PaymentDeclinedException(
        cardLastFour: last4,
        amount: amount,
        reason: 'Daily credit limit exceeded',
      );
    }
    print('  Card ending in $last4 charged successfully: \$$amount');
  }

  try {
    chargeCard('4321', 1200.0);
  } on PaymentDeclinedException catch (e) {
    print('  Caught custom exception: $e');
    print('  Card: ${e.cardLastFour}, Amount: \$${e.amount}, Reason: ${e.reason}');
  }
  print('');
}

// ============================================================================
// 5. Asynchronous Exception Handling (Futures & Streams)
// ============================================================================
/// EXPLANATION:
/// In Dart, asynchronous code can fail inside a `Future` or `Stream`.
///
/// HANDLING ASYNC ERRORS:
/// 1. `async / await` with standard `try / catch`:
///    - The cleanest, recommended idiomatic approach.
/// 2. `Future.catchError()` callback:
///    - Functional style future error chaining.
/// 3. Stream error handling:
///    - `stream.handleError((error) { ... })`
///    - `stream.listen(onData, onError: (err) { ... })`
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript: JS Promises `.catch()` and `async/await try/catch`.
/// - vs Java: Java `CompletableFuture.exceptionally()`.
/// - vs C#: C# `async/await` with `try/catch`.
Future<String> fetchRemoteData(bool shouldFail) async {
  await Future.delayed(Duration(milliseconds: 50));
  if (shouldFail) {
    throw const HttpException('503 Service Unavailable: Remote API down');
  }
  return '{"data": "Fresh Server Payload"}';
}

class HttpException implements Exception {
  final String message;
  const HttpException(this.message);

  @override
  String toString() => message;
}

Future<void> demonstrateAsyncExceptionHandling() async {
  print('--- 5. Asynchronous Exception Handling ---');

  // 1. Using try-catch with await (Recommended)
  try {
    print('  Attempting async fetch with failure...');
    String data = await fetchRemoteData(true);
    print('  Fetched data: $data');
  } on HttpException catch (e) {
    print('  Caught async exception in try-catch: $e');
  }

  // 2. Using .catchError on Future
  await fetchRemoteData(true).catchError((err) {
    print('  Caught via Future.catchError(): $err');
    return 'Fallback default payload';
  });

  // 3. Stream error handling
  Stream<int> errorGeneratingStream() async* {
    yield 1;
    yield 2;
    throw StateError('Stream encountered a corruption error!');
  }

  print('  Listening to Stream with error handler:');
  await for (var item in errorGeneratingStream().handleError((err) {
    print('    [Stream handleError] Intercepted stream error: $err');
  })) {
    print('    Stream item received: $item');
  }
  print('');
}

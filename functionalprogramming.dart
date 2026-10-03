/// ============================================================================
/// FUNCTIONAL PROGRAMMING (FP) IN DART: MASTERCLASS REFERENCE
/// ============================================================================
/// This file covers:
///  1. Pure Functions & Immutability
///  2. Essential Higher-Order Collection Methods (`map`, `where`, `fold`, `reduce`, `expand`)
///  3. Predicates & Slicing (`any`, `every`, `takeWhile`, `skipWhile`)
///  4. Lazy Functional Pipelines
///  5. Currying & Partial Application
///  6. Function Composition (Pipelining)
///  7. Functional Data Structures with Records & Sealed Result Types
///
/// For each topic:
///  - Working runnable examples
///  - Deep conceptual explanations
///  - Cross-language comparisons (JavaScript, Python, Java 8 Streams, Kotlin, Haskell, Rust)
/// ============================================================================

void main() {
  print('===============================================================');
  print('       FUNCTIONAL PROGRAMMING IN DART: MASTERCLASS             ');
  print('===============================================================\n');

  demonstratePureFunctionsAndImmutability();
  demonstrateCollectionFPMethods();
  demonstrateFoldAndReduce();
  demonstrateExpandFlatMap();
  demonstrateCurryingAndPartialApplication();
  demonstrateFunctionComposition();
  demonstrateFunctionalDataModeling();

  print('\n===============================================================');
  print('       FP DEMONSTRATIONS COMPLETED SUCCESSFULLY                ');
  print('===============================================================');
}

// ============================================================================
// 1. Pure Functions & Immutability
// ============================================================================
/// EXPLANATION:
/// 1. Pure Function: A function that:
///    - Produces the exact same output for the same inputs (Deterministic).
///    - Causes NO side effects (does not mutate global state, modify arguments, or write to external I/O).
/// 2. Immutability: Data is never modified in-place; transformations return new instances.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - In pure functional languages like Haskell, functions are pure by default.
/// - In Dart (multi-paradigm), you intentionally design pure functions for testability, concurrency, and predictability.
int pureAdd(int a, int b) => a + b;

// Pure transformation returning a new list
List<int> pureInsertSorted(List<int> sortedList, int newItem) {
  return [...sortedList, newItem]..sort();
}

void demonstratePureFunctionsAndImmutability() {
  print('--- 1. Pure Functions & Immutability ---');

  List<int> original = const [10, 20, 30];
  List<int> updated = pureInsertSorted(original, 25);

  print('Original (unmutated): $original');
  print('Updated (new instance): $updated');
  print('pureAdd(4, 6): ${pureAdd(4, 6)}');
  print('');
}

// ============================================================================
// 2. Essential Higher-Order Collection Methods (map, where, takeWhile)
// ============================================================================
/// EXPLANATION:
/// Higher-order methods on `Iterable` are lazy by default:
/// - `where((item) => bool)`: Filters elements (equivalent to `filter` in JS/Python).
/// - `map((item) => transformed)`: Maps each element to a new value.
/// - `takeWhile((item) => bool)`: Emits elements until the condition becomes false.
/// - `skipWhile((item) => bool)`: Skips elements until the condition becomes false.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript: JS uses `filter()` and `map()`. In JS they eagerly create arrays at each step.
///   In Dart, `where()` and `map()` are lazy Iterables (zero intermediate list allocations until `.toList()`).
/// - vs Java: Java requires `.stream().filter().map().collect(Collectors.toList())`.
///   Dart calls `.where().map().toList()` directly on the collection!
void demonstrateCollectionFPMethods() {
  print('--- 2. Higher-Order Collection Methods ---');

  List<int> scores = [45, 82, 91, 58, 77, 95, 30, 88];

  // Declarative pipeline
  List<String> honorRoll = scores
      .where((s) => s >= 80) // Filter scores >= 80
      .map((s) => 'Grade: $s (Honors)') // Transform to string
      .toList();

  print('Original scores: $scores');
  print('Honor roll students: $honorRoll');

  // takeWhile & skipWhile
  List<int> sortedNumbers = [2, 4, 6, 7, 8, 10];
  var evenPrefix = sortedNumbers.takeWhile((n) => n.isEven).toList();
  var afterFirstOdd = sortedNumbers.skipWhile((n) => n.isEven).toList();

  print('takeWhile even: $evenPrefix');
  print('skipWhile even: $afterFirstOdd');
  print('');
}

// ============================================================================
// 3. Fold and Reduce (Aggregation & Accumulation)
// ============================================================================
/// EXPLANATION:
/// `reduce` and `fold` combine all elements of a collection into a single value.
///
/// DIFFERENCE BETWEEN FOLD AND REDUCE:
/// 1. `reduce((acc, element) => combined)`:
///    - Uses the FIRST element of the list as the initial accumulator.
///    - Accumulator and elements MUST be of the SAME type `T`.
///    - Throws `StateError` if the collection is empty!
/// 2. `fold<R>(initialValue, (acc, element) => combined)`:
///    - Takes an explicit `initialValue` of type `R`.
///    - Can produce a result type `R` DIFFERENT from collection element type `T`!
///    - Safely handles empty collections without throwing.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript: JS `reduce(callback, initialValue)` combines both Dart's reduce and fold.
/// - vs Python: Python `functools.reduce(func, seq, initial)`.
/// - vs Kotlin / Scala: Kotlin separates `reduce()` and `fold(initial, ...)`.
void demonstrateFoldAndReduce() {
  print('--- 3. Fold and Reduce ---');

  List<int> prices = [10, 25, 40, 5];

  // 1. reduce: Compute sum
  int totalSum = prices.reduce((acc, curr) => acc + curr);
  int maxPrice = prices.reduce((a, b) => a > b ? a : b);

  print('Prices: $prices');
  print('Total Sum (via reduce): \$$totalSum');
  print('Max Price (via reduce): \$$maxPrice');

  // 2. fold: Compute total characters in a list of Strings (different return type int from element String)
  List<String> words = ['Functional', 'Dart', 'Programming'];
  int totalCharacters = words.fold<int>(0, (total, word) => total + word.length);

  print('Words: $words');
  print('Total characters across all words (via fold<int>): $totalCharacters');
  print('');
}

// ============================================================================
// 4. Expand (FlatMap / 1-to-Many Transformations)
// ============================================================================
/// EXPLANATION:
/// `expand((item) => Iterable)` transforms each element into an `Iterable` and flattens
/// the resulting iterables into a single sequence (known as `flatMap` in other languages).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript: JS `flatMap((item) => ...)`.
/// - vs Java: Java `Stream.flatMap()`.
/// - vs Rust: Rust `Iterator::flat_map()`.
void demonstrateExpandFlatMap() {
  print('--- 4. Expand (flatMap) ---');

  Map<String, List<String>> userHobbies = {
    'Alice': ['Reading', 'Hiking'],
    'Bob': ['Gaming', 'Hiking'],
    'Charlie': ['Cooking', 'Chess'],
  };

  // Extract and flatten all hobbies into a unique set
  Set<String> allUniqueHobbies = userHobbies.values
      .expand((hobbiesList) => hobbiesList) // Flatten List<List<String>> -> Iterable<String>
      .toSet();

  print('All unique hobbies across users: $allUniqueHobbies');

  // Expanding numbers into duplicates
  List<int> duplicated = [1, 2, 3].expand((n) => [n, n * 10]).toList();
  print('Expanded [n, n * 10]: $duplicated');
  print('');
}

// ============================================================================
// 5. Currying & Partial Application
// ============================================================================
/// EXPLANATION:
/// - Currying: Translating a function with multiple arguments `f(a, b, c)` into a sequence
///   of single-argument functions `f(a)(b)(c)`.
/// - Partial Application: Fixing a few arguments of a function to produce a more specialized function.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - Native in Haskell/F# (all functions are curried by default).
/// - In Dart, implemented easily by returning closures.
void demonstrateCurryingAndPartialApplication() {
  print('--- 5. Currying & Partial Application ---');

  // Curried multiplication function: int -> (int -> int)
  int Function(int) multiplyBy(int factor) {
    return (int value) => value * factor;
  }

  var doubleValue = multiplyBy(2);
  var tripleValue = multiplyBy(3);

  print('doubleValue(15): ${doubleValue(15)}');
  print('tripleValue(15): ${tripleValue(15)}');

  // Applying curried function over a list
  List<int> numbers = [1, 2, 3, 4, 5];
  List<int> doubledList = numbers.map(doubleValue).toList();
  print('List mapped with curried doubleValue: $doubledList');
  print('');
}

// ============================================================================
// 6. Function Composition (Pipelines)
// ============================================================================
/// EXPLANATION:
/// Function composition is the act of combining two pure functions `f` and `g`
/// to produce a new function `h(x) = f(g(x))`.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Unix: Piping output `cat file | grep "error" | wc -l`.
/// - vs JS/Ramda: `R.compose()` or `R.pipe()`.
/// - vs Haskell: Function composition operator `.`.
typedef UnaryOp<T> = T Function(T input);

UnaryOp<T> compose<T>(UnaryOp<T> f, UnaryOp<T> g) {
  return (T x) => f(g(x));
}

void demonstrateFunctionComposition() {
  print('--- 6. Function Composition ---');

  int addTen(int x) => x + 10;
  int multiplyByTwo(int x) => x * 2;

  // Composed: (x * 2) + 10
  var compute = compose<int>(addTen, multiplyByTwo);

  print('compute(5) -> ((5 * 2) + 10): ${compute(5)}');
  print('compute(20) -> ((20 * 2) + 10): ${compute(20)}');
  print('');
}

// ============================================================================
// 7. Functional Data Modeling with Records & Sealed Results
// ============================================================================
/// EXPLANATION:
/// Modern FP in Dart combines:
/// 1. Immutable Records (tuples) for returning lightweight multiple values without boilerplate.
/// 2. Sealed Result Types (`Success` vs `Failure`) for explicit error handling instead of throwing exceptions.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Rust: `Result<T, E>` and `match result { Ok(v) => ..., Err(e) => ... }`.
/// - vs Swift: `Result<Success, Failure>`.
/// - vs Kotlin: `Result<T>`.
sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class Failure<T> extends Result<T> {
  final String error;
  Failure(this.error);
}

// Pure function returning Result instead of throwing
Result<double> safeDivide(double numerator, double denominator) {
  if (denominator == 0) {
    return Failure('Cannot divide by zero');
  }
  return Success(numerator / denominator);
}

void demonstrateFunctionalDataModeling() {
  print('--- 7. Functional Data Modeling (Result Types & Records) ---');

  // Using Dart 3 Records as lightweight pairs: (int, String)
  (int, String) getUserInfo() => (101, 'Ada Lovelace');
  var (userId, userName) = getUserInfo();
  print('Destructured Record: ID=$userId, Name=$userName');

  // Handling Result Type with Exhaustive Pattern Matching
  void handleDivision(double a, double b) {
    Result<double> result = safeDivide(a, b);

    String message = switch (result) {
      Success(:final data) => '  Division Success: $a / $b = ${data.toStringAsFixed(2)}',
      Failure(:final error) => '  Division Failed: $a / $b -> Error: $error',
    };
    print(message);
  }

  handleDivision(10, 2);
  handleDivision(10, 0);
  print('');
}

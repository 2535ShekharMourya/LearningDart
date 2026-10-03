/// ============================================================================
/// DART FUNCTIONS: COMPREHENSIVE GUIDE & REFERENCE
/// ============================================================================
/// This file covers:
///  1. Function Declaration & Return Types
///  2. Positional Parameters (Required & Optional `[]`)
///  3. Named Parameters (Required & Optional `{}` with default values)
///  4. Arrow Syntax (`=>`)
///  5. First-Class Functions & Typedefs
///  6. Anonymous Functions & Lambdas
///  7. Closures & Lexical Scoping
///  8. Tear-offs (Function & Constructor Tear-offs)
///  9. Synchronous Generators (`sync*`, `yield`, `yield*`)
///
/// For each topic:
///  - Working runnable examples
///  - Explanations & key rules
///  - Cross-language comparisons (Java, JavaScript/TypeScript, Python, Kotlin, Swift, C++)
/// ============================================================================

// Typedef: Defines a function signature type alias
typedef MathOperation = int Function(int a, int b);
typedef StringTransformer = String Function(String input);

void main() {
  print('===============================================================');
  print('             DART FUNCTIONS: MASTERCLASS REFERENCE             ');
  print('===============================================================\n');

  demonstrateFunctionBasics();
  demonstrateParameters();
  demonstrateArrowSyntax();
  demonstrateFirstClassFunctions();
  demonstrateAnonymousFunctionsAndLambdas();
  demonstrateClosuresAndLexicalScope();
  demonstrateTearOffs();
  demonstrateGenerators();

  print('\n===============================================================');
  print('             DART FUNCTIONS COMPLETED SUCCESSFULLY             ');
  print('===============================================================');
}

// ============================================================================
// 1. Function Declaration & Return Types
// ============================================================================
/// EXPLANATION:
/// In Dart, functions are true first-class objects (instances of `Function` class).
/// Every function returns a value; if no return value is specified, `return null;`
/// is implicitly returned (for non-`void` nullable return types) or returns `void`.
///
/// KEY & IMPORTANT POINTS:
/// 1. Type annotations on return types and parameters are strongly recommended for clarity and static analysis.
/// 2. `void` indicates a function that does not produce a useful value.
/// 3. `Never` return type indicates a function that never completes normally (throws or loops infinitely).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java/C++: In Java/C++, functions cannot exist outside of a class (except in modern C++).
///   In Dart, top-level functions, local functions, static methods, and instance methods are all first-class.
/// - vs JavaScript: JS functions don't enforce return types. Dart is statically typed.
/// - vs Python: Python uses `def func():`. Dart uses C-style `ReturnType funcName(Params)`.
void demonstrateFunctionBasics() {
  print('--- 1. Function Declaration & Return Types ---');

  // Top-level / Local function
  int calculateSum(int a, int b) {
    return a + b;
  }

  // Nested / Local helper function
  bool isPositive(int number) {
    return number > 0;
  }

  print('calculateSum(15, 25): ${calculateSum(15, 25)}');
  print('isPositive(-5): ${isPositive(-5)}');
  print('isPositive(10): ${isPositive(10)}');
  print('');
}

// ============================================================================
// 2. Positional Parameters & 3. Named Parameters
// ============================================================================
/// EXPLANATION:
/// Dart supports two parameter formats:
/// 1. Positional Parameters:
///    - Required positional: `void fn(int a, String b)`
///    - Optional positional: `void fn(int a, [int? b, String c = 'default'])`
///      (Enclosed in square brackets `[]` at the end of parameter list).
/// 2. Named Parameters:
///    - Enclosed in curly braces `{}`: `void fn({required String name, int age = 18})`
///    - When calling, arguments are labelled: `fn(name: 'Alice', age: 25)`.
///    - Can be provided in ANY order at call site.
///    - Marked `required` if mandatory; otherwise provide a default value or nullable type.
///
/// KEY & IMPORTANT POINTS:
/// 1. A function can have positional parameters OR named parameters, but NOT both optional positional and named!
/// 2. Named parameters make API calls self-documenting (extensively used across Flutter widgets).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript/TypeScript: JS simulates named parameters via object destructuring `function fn({ name, age = 18 })`.
///   Dart has native language support with zero object allocation overhead.
/// - vs Python: Python supports `*args` and `**kwargs`, and keyword arguments `fn(name="Alice")`.
///   Dart's named parameters are statically type-checked at compile-time.
/// - vs Kotlin/Swift: Kotlin supports named arguments `fn(name = "Alice")` on standard positional parameters.
///   Swift uses argument labels `func fn(for name: String)`. Dart distinguishes positional vs named at definition.
/// - vs Java: Java lacks named parameters entirely (requires Builder Pattern). Dart named parameters replace the Builder Pattern!
void demonstrateParameters() {
  print('--- 2 & 3. Positional and Named Parameters ---');

  // 1. Optional Positional Parameters ([])
  String formatAddress(String street, String city, [String country = 'USA', String? zipCode]) {
    String result = '$street, $city, $country';
    if (zipCode != null) {
      result += ' ($zipCode)';
    }
    return result;
  }

  print('Positional default: ${formatAddress("123 Main St", "Springfield")}');
  print('Positional overridden: ${formatAddress("456 High St", "London", "UK", "NW1 6XE")}');

  // 2. Named Parameters ({})
  void createUserProfile({
    required String username,
    required String email,
    int age = 18,
    bool isSubscribed = false,
  }) {
    print('  Created Profile: username=$username, email=$email, age=$age, subscribed=$isSubscribed');
  }

  // Call with named parameters (order doesn't matter!)
  print('Named parameters call:');
  createUserProfile(
    email: 'alice@example.com',
    username: 'alice99',
    isSubscribed: true,
  );
  createUserProfile(
    username: 'bob_builder',
    email: 'bob@example.com',
    age: 32,
  );
  print('');
}

// ============================================================================
// 4. Arrow Syntax (=>)
// ============================================================================
/// EXPLANATION:
/// `=> expr` (fat arrow) is a shorthand syntax for functions that contain exactly ONE expression.
/// `int add(int a, int b) => a + b;` is identical to `{ return a + b; }`.
///
/// KEY & IMPORTANT POINTS:
/// 1. Only an EXPRESSION can follow `=>` (statements like `if`, `for`, `while` cannot follow `=>`).
/// 2. Can be used for top-level functions, local functions, methods, getters, and lambdas.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript: JS arrow functions `(a, b) => a + b` behave identically for expressions,
///   but JS arrows also alter `this` binding. Dart `=>` is purely syntactic sugar for return.
/// - vs Java: Java lambda expressions use `(a, b) -> a + b`.
/// - vs C#: C# expression-bodied members use `=>` identically.
void demonstrateArrowSyntax() {
  print('--- 4. Arrow Syntax (=>) ---');

  int square(int n) => n * n;
  String greet(String name) => 'Welcome, $name!';
  bool isEvenNumber(int n) => n % 2 == 0;

  print('square(7): ${square(7)}');
  print('greet("Charlie"): ${greet("Charlie")}');
  print('isEvenNumber(14): ${isEvenNumber(14)}');
  print('');
}

// ============================================================================
// 5. First-Class Functions & Typedefs
// ============================================================================
/// EXPLANATION:
/// In Dart, functions are first-class citizens:
/// 1. Can be assigned to variables.
/// 2. Can be passed as arguments to other functions (Higher-Order Functions).
/// 3. Can be returned as values from other functions.
/// 4. `typedef` gives a meaningful alias to a function signature.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs C/C++: C uses function pointers (`int (*op)(int, int)`). C++ uses `std::function`.
///   Dart functions are high-level safe objects.
/// - vs Java: Java 8 uses functional interfaces (`Function<T, R>`, `BiFunction<T, U, R>`).
///   Dart has direct function types `R Function(T arg)` and `typedef`.
/// - vs Python/JS: Both treat functions as first-class objects dynamically.
void demonstrateFirstClassFunctions() {
  print('--- 5. First-Class Functions & Typedefs ---');

  // Assigning functions to variables using Typedef
  MathOperation add = (a, b) => a + b;
  MathOperation multiply = (a, b) => a * b;

  // Higher-Order Function: accepts function as parameter
  int executeOperation(int x, int y, MathOperation operation) {
    return operation(x, y);
  }

  print('Executing add: ${executeOperation(10, 5, add)}');
  print('Executing multiply: ${executeOperation(10, 5, multiply)}');

  // Higher-Order Function: returns a function
  StringTransformer createPrefixer(String prefix) {
    return (String input) => '$prefix: $input';
  }

  var errorLogger = createPrefixer('[ERROR]');
  var infoLogger = createPrefixer('[INFO]');

  print(errorLogger('Database connection failed!'));
  print(infoLogger('Server started on port 8080.'));
  print('');
}

// ============================================================================
// 6. Anonymous Functions & Lambdas
// ============================================================================
/// EXPLANATION:
/// An anonymous function (lambda / function literal) is a function without a name.
/// Syntax: `(params) { body }` or `(params) => expr`.
///
/// KEY & IMPORTANT POINTS:
/// 1. Widely used in collection transformations (`map`, `where`, `forEach`) and UI callbacks.
/// 2. Can capture enclosing scope variables (acting as closures).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Python: Python `lambda` is restricted to single expressions and cannot contain multiple statements.
///   Dart anonymous functions can have full multi-line block bodies `{ ... }`.
/// - vs JavaScript: Identical to JS anonymous functions and arrow functions.
void demonstrateAnonymousFunctionsAndLambdas() {
  print('--- 6. Anonymous Functions & Lambdas ---');

  List<String> names = ['david', 'emily', 'frank'];

  // Passing multi-line anonymous function
  var formattedNames = names.map((name) {
    String capitalized = name[0].toUpperCase() + name.substring(1);
    return 'User: $capitalized';
  }).toList();

  print('Formatted names: $formattedNames');

  // Single-expression anonymous function
  List<int> numbers = [1, 2, 3, 4, 5];
  var doubled = numbers.map((n) => n * 2).toList();
  print('Doubled numbers: $doubled');
  print('');
}

// ============================================================================
// 7. Closures & Lexical Scoping
// ============================================================================
/// EXPLANATION:
/// A closure is a function object that has access to variables in its lexical scope,
/// even when the function is invoked outside of its original scope.
///
/// KEY & IMPORTANT POINTS:
/// 1. Dart uses lexical scoping: variable resolution proceeds outward through nested curly braces `{}`.
/// 2. Closures capture variables by REFERENCE, not by value snapshot!
/// 3. In loops, Dart creates a separate binding for each iteration variable (no closure loop bugs).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Old JavaScript (`var`): Old JS shared loop variable across all iterations inside closures.
///   Dart (like modern JS `let`) allocates a fresh binding per iteration.
/// - vs C++: C++ requires explicit lambda capture lists (`[&]`, `[=]`, `[x]`).
///   Dart captures lexically referenced variables automatically.
void demonstrateClosuresAndLexicalScope() {
  print('--- 7. Closures & Lexical Scoping ---');

  // Counter factory returning a closure
  int Function() makeCounter([int initial = 0]) {
    int count = initial; // Captured variable
    return () {
      count++;
      return count;
    };
  }

  var counterA = makeCounter(0);
  var counterB = makeCounter(100);

  print('Counter A: ${counterA()}'); // 1
  print('Counter A: ${counterA()}'); // 2
  print('Counter B: ${counterB()}'); // 101
  print('Counter A: ${counterA()}'); // 3 (Independent state!)

  // Loop closure binding demonstration:
  List<Function> callbacks = [];
  for (int i = 0; i < 3; i++) {
    callbacks.add(() => 'Callback captured index: $i');
  }
  for (var cb in callbacks) {
    print('  ${cb()}');
  }
  print('');
}

// ============================================================================
// 8. Tear-offs (Method & Constructor Tear-offs)
// ============================================================================
/// EXPLANATION:
/// A tear-off is a way to create a function object directly from a named method
/// or constructor WITHOUT writing a wrapping lambda `(x) => method(x)`.
///
/// KEY & IMPORTANT POINTS:
/// 1. Function Tear-off: Instead of `list.forEach((x) => print(x));`, write `list.forEach(print);`.
/// 2. Constructor Tear-off (Dart 2.15+): Instead of `list.map((name) => User(name));`, write `list.map(User.new);`.
/// 3. Tear-offs are cleaner, faster, and avoid allocating unnecessary intermediate closure wrappers.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java: Java Method References `System.out::println` and `User::new`.
///   Dart simply writes `print` and `User.new` directly without `::`.
/// - vs C++: C++ pointer-to-member functions.
/// - vs Python: Python supports passing methods/constructors directly by name `list(map(str.upper, names))`.
class UserAccount {
  final String name;
  UserAccount(this.name);

  void display() => print('  UserAccount: $name');
}

void demonstrateTearOffs() {
  print('--- 8. Tear-offs (Method & Constructor Tear-offs) ---');

  List<String> rawNames = ['Grace', 'Heidi', 'Ivan'];

  // Constructor Tear-off: UserAccount.new
  List<UserAccount> users = rawNames.map(UserAccount.new).toList();
  print('Constructed users via constructor tear-off (UserAccount.new):');

  // Method Tear-off: calling display on each user
  for (var user in users) {
    var displayFn = user.display; // Method tear-off
    displayFn();
  }

  // Top-level function tear-off
  print('Using print as function tear-off:');
  rawNames.forEach(print);
  print('');
}

// ============================================================================
// 9. Synchronous Generators (sync* and yield)
// ============================================================================
/// EXPLANATION:
/// When you need to lazily produce a sequence of values on demand, use `sync*`
/// (synchronous generator) with `yield` and `yield*`.
///
/// KEY & IMPORTANT POINTS:
/// 1. Returns an `Iterable<T>`.
/// 2. `yield value`: Emits the value and pauses execution until the consumer asks for the next item.
/// 3. `yield* iterable`: Delegates and emits all values from another iterable or sub-generator.
/// 4. Enables working with massive or infinite sequences with minimal memory footprint.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Python: Python generator functions (`def gen(): yield x`).
/// - vs JavaScript: JS generator functions (`function* gen() { yield x; yield* other; }`).
/// - vs C#: C# `IEnumerable<T>` with `yield return` and `yield break`.
void demonstrateGenerators() {
  print('--- 9. Synchronous Generators (sync* and yield) ---');

  // Generator with yield
  Iterable<int> countdown(int from) sync* {
    int current = from;
    while (current > 0) {
      yield current;
      current--;
    }
  }

  print('Countdown generator:');
  for (var count in countdown(3)) {
    print('  $count...');
  }

  // Recursive generator with yield* (delegation)
  Iterable<int> rangeWithSubRange() sync* {
    yield 100;
    yield* countdown(3); // Delegates to countdown generator
    yield 200;
  }

  print('Generator with yield* delegation: ${rangeWithSubRange().toList()}');
  print('');
}

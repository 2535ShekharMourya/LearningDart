/// ============================================================================
/// MODERN DART PROGRAMMING (DART 3+): COMPREHENSIVE GUIDE & REFERENCE
/// ============================================================================
/// This file covers:
///  1. Records (Tuples with positional & named fields, structural equality)
///  2. Pattern Matching & Destructuring (Declaration, Assignment, List/Map/Object Patterns)
///  3. Switch Expressions & Guard Clauses (`when`)
///  4. If-Case Pattern Statements
///  5. Sealed Classes & Exhaustiveness Checking (Algebraic Data Types)
///  6. Class Modifiers (`sealed`, `base`, `interface`, `final`, `mixin class`)
///  7. Extension Types (Zero-Cost Inline Types / Abstractions)
///
/// For each topic:
///  - Working runnable examples
///  - Architectural explanations & mental models
///  - Cross-language comparisons (Rust, Kotlin, Swift, Python, TypeScript, C#)
/// ============================================================================

void main() {
  print('===============================================================');
  print('       MODERN DART PROGRAMMING (DART 3+): MASTERCLASS          ');
  print('===============================================================\n');

  demonstrateRecords();
  demonstratePatternsAndDestructuring();
  demonstrateSwitchExpressionsAndGuards();
  demonstrateIfCaseStatements();
  demonstrateSealedClassesAndExhaustiveness();
  demonstrateClassModifiers();
  demonstrateExtensionTypes();

  print('\n===============================================================');
  print('       MODERN DART DEMONSTRATIONS COMPLETED SUCCESSFULLY       ');
  print('===============================================================');
}

// ============================================================================
// 1. Records (Tuples with Positional & Named Fields)
// ============================================================================
/// EXPLANATION:
/// Records are an anonymous, immutable, aggregate type introduced in Dart 3.
/// They allow bundling multiple values together without declaring a dedicated class.
///
/// KEY & IMPORTANT POINTS:
/// 1. Positional Fields: Accessed via `$1`, `$2`, `$3`, etc.
///    `(int, String) pair = (1, 'one');` -> `pair.$1 == 1`, `pair.$2 == 'one'`.
/// 2. Named Fields: Enclosed in `{}` inside the record type and accessed by name.
///    `({int id, String name}) user = (id: 42, name: 'Alice');` -> `user.id == 42`.
/// 3. Mixed Fields: A record can contain both positional and named fields!
/// 4. Value Equality: Records have automatic structural value equality (`==`) and `hashCode`!
///    `('a', 1) == ('a', 1)` evaluates to `true`.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Python: Python tuples `(1, "one")` and namedtuples. Dart records are statically typed at compile-time.
/// - vs TypeScript: TS tuples `[number, string]`. TS tuples are just JS arrays at runtime; Dart records are distinct value types.
/// - vs C#: C# ValueTuples `(int, string)` and Records.
/// - vs Rust: Rust tuples `(i32, String)`.
(double latitude, double longitude) getGPSCoordinates() {
  return (37.7749, -122.4194); // Returning multiple values effortlessly!
}

({int statusCode, String body, bool isSuccess}) fetchMockResponse() {
  return (statusCode: 200, body: '{"user": "Alice"}', isSuccess: true);
}

void demonstrateRecords() {
  print('--- 1. Records (Anonymous Value Tuples) ---');

  // Positional Record
  var gps = getGPSCoordinates();
  print('GPS Coordinates: Lat=${gps.$1}, Long=${gps.$2}');

  // Named Record
  var response = fetchMockResponse();
  print('HTTP Response: Status=${response.statusCode}, Body=${response.body}, Success=${response.isSuccess}');

  // Structural Value Equality Check:
  var record1 = (id: 1, label: 'Button');
  var record2 = (id: 1, label: 'Button');
  print('Structural Equality (record1 == record2): ${record1 == record2}');
  print('Record runtime type: ${record1.runtimeType}');
  print('');
}

// ============================================================================
// 2. Pattern Matching & Destructuring
// ============================================================================
/// EXPLANATION:
/// Patterns in Dart 3 represent the shape of a value that can be matched against incoming data
/// to simultaneously validate the structure AND destructure (unpack) internal values.
///
/// PATTERN TYPES:
/// 1. Variable Declaration Pattern: `var (lat, lng) = getGPSCoordinates();`
/// 2. Variable Assignment Pattern: `(a, b) = (b, a);` (swapping values with zero temp variables!)
/// 3. List Pattern & Rest Operator: `var [first, second, ...rest] = [1, 2, 3, 4, 5];`
/// 4. Map Pattern: `var {'name': userName, 'age': userAge} = jsonMap;`
/// 5. Object Pattern: `var Person(:name, :age) = personObj;`
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript: JS destructuring `const [a, b, ...rest] = arr;` and `const { name } = obj;`.
/// - vs Python: Python extended unpacking `a, b, *rest = [1, 2, 3, 4]`.
/// - vs Rust: Rust pattern matching and destructuring `let (a, b) = tuple;`.
class Customer {
  final String fullName;
  final int loyaltyPoints;
  Customer(this.fullName, this.loyaltyPoints);
}

void demonstratePatternsAndDestructuring() {
  print('--- 2. Patterns & Destructuring ---');

  // 1. Record Destructuring
  var (lat, long) = getGPSCoordinates();
  print('Destructured Coordinates: lat=$lat, long=$long');

  // 2. Swapping variables without temporary variable
  int x = 100;
  int y = 200;
  print('Before swap: x=$x, y=$y');
  (x, y) = (y, x); // Destructuring assignment swap
  print('After swap: x=$x, y=$y');

  // 3. List Pattern with Rest operator
  List<int> numbers = [10, 20, 30, 40, 50];
  var [first, second, ...rest] = numbers;
  print('List destructuring: first=$first, second=$second, rest=$rest');

  // 4. Map Pattern
  Map<String, dynamic> json = {'title': 'Dart 3 Masterclass', 'rating': 5};
  if (json case {'title': String title, 'rating': int rating}) {
    print('Map Pattern matched: Title="$title", Rating=$rating stars');
  }

  // 5. Object Pattern (Property extraction)
  Customer customer = Customer('Bob Johnson', 450);
  var Customer(:fullName, :loyaltyPoints) = customer;
  print('Object Pattern matched Customer: name=$fullName, points=$loyaltyPoints');
  print('');
}

// ============================================================================
// 3. Switch Expressions & Guard Clauses (when)
// ============================================================================
/// EXPLANATION:
/// Dart 3 introduced Switch Expressions:
/// - Produces a value directly (like an expression, not just statements).
/// - Enforces exhaustiveness (compiler error if any possible case is omitted).
/// - Supports logical operators (`||`, `&&`), relational checks (`<`, `>=`), and guards (`when`).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Rust: Rust `match expr { ... }`.
/// - vs Kotlin: Kotlin `when (expr) { ... }`.
/// - vs Swift: Swift `switch expr { ... }`.
void demonstrateSwitchExpressionsAndGuards() {
  print('--- 3. Switch Expressions & Guard Clauses (when) ---');

  // Switch expression with relational patterns and logical OR
  String categorizeScore(int score) => switch (score) {
        >= 90 => 'Grade A (Outstanding)',
        >= 80 => 'Grade B (Great)',
        >= 70 => 'Grade C (Good)',
        >= 60 => 'Grade D (Pass)',
        _ => 'Grade F (Fail)',
      };

  print('Score 95 -> ${categorizeScore(95)}');
  print('Score 72 -> ${categorizeScore(72)}');
  print('Score 45 -> ${categorizeScore(45)}');

  // Switch pattern with Guard Clause ('when')
  String describeNumber(int n) => switch (n) {
        0 => 'Zero',
        int x when x < 0 => 'Negative number: $x',
        int x when x.isEven => 'Positive even number: $x',
        int x => 'Positive odd number: $x',
      };

  print('describeNumber(0): ${describeNumber(0)}');
  print('describeNumber(-15): ${describeNumber(-15)}');
  print('describeNumber(42): ${describeNumber(42)}');
  print('describeNumber(19): ${describeNumber(19)}');
  print('');
}

// ============================================================================
// 4. If-Case Pattern Statements
// ============================================================================
/// EXPLANATION:
/// `if (expr case pattern)` matches a single pattern against a target and binds
/// destructured variables into the if-body scope if the match succeeds.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Swift: Swift `if case pattern = value { ... }`.
/// - vs Rust: Rust `if let pattern = value { ... }`.
void demonstrateIfCaseStatements() {
  print('--- 4. If-Case Pattern Statements ---');

  Object unknownPayload = [10, 20];

  // If-case list pattern
  if (unknownPayload case [int a, int b]) {
    print('  Matched pair list: a=$a, b=$b, sum=${a + b}');
  }

  // If-case with guard clause
  Object temperatureReading = 38.5;
  if (temperatureReading case double temp when temp > 37.5) {
    print('  High fever alert: ${temp}°C');
  }
  print('');
}

// ============================================================================
// 5. Sealed Classes & Exhaustiveness Checking
// ============================================================================
/// EXPLANATION:
/// A `sealed class` defines a closed set of known subtypes within the same file.
///
/// WHY SEALED CLASSES ARE POWERFUL:
/// 1. The compiler knows EVERY possible subtype at compile-time.
/// 2. When switching on a sealed class instance, the compiler enforces EXHAUSTIVENESS.
///    You do NOT need a wildcard `_ =>` fallback case!
/// 3. If you add a new subtype tomorrow, every switch expression in your codebase
///    will immediately show a compile-time error reminding you to handle the new case!
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Kotlin: Kotlin `sealed class` / `sealed interface`.
/// - vs Java: Java 17+ `sealed class ... permits SubA, SubB`.
/// - vs Rust: Rust `enum Message { Move { x: i32, y: i32 }, Write(String) }`.
sealed class NetworkResponse<T> {}

class NetworkSuccess<T> extends NetworkResponse<T> {
  final T payload;
  NetworkSuccess(this.payload);
}

class NetworkError<T> extends NetworkResponse<T> {
  final int errorCode;
  final String message;
  NetworkError(this.errorCode, this.message);
}

class NetworkLoading<T> extends NetworkResponse<T> {}

void demonstrateSealedClassesAndExhaustiveness() {
  print('--- 5. Sealed Classes & Exhaustiveness ---');

  NetworkResponse<String> response = NetworkSuccess('UserData_Loaded');

  // Exhaustive switch expression: Handling 100% of subtypes without wildcard `_`!
  String uiMessage = switch (response) {
    NetworkSuccess(:final payload) => 'Data loaded: $payload',
    NetworkError(:final errorCode, :final message) => 'Error $errorCode: $message',
    NetworkLoading() => 'Loading in progress...',
  };

  print('UI Message from Sealed Class: $uiMessage');
  print('');
}

// ============================================================================
// 6. Class Modifiers (sealed, base, interface, final, mixin class)
// ============================================================================
/// EXPLANATION:
/// Dart 3 introduces fine-grained class modifiers to enforce API contracts:
///
/// 1. `sealed`: Cannot be extended/implemented outside library. Enables exhaustive pattern matching.
/// 2. `base`: Requires consumers to use `extends` (subclassing); prevents `implements` from other libraries.
/// 3. `interface`: Requires consumers to use `implements` (interface contract); prevents `extends` from other libraries.
/// 4. `final`: Forbids BOTH `extends` and `implements` outside this library (cannot be subclassed anywhere outside).
/// 5. `mixin class`: Can be used BOTH as a normal class (for instantiation/inheritance) and as a mixin (`with`).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java: Java `final class` (cannot extend), `interface` (contract).
/// - vs Kotlin: Kotlin `open`, `final`, `sealed`, `interface`.
/// - vs C#: C# `sealed class` (cannot inherit), `interface`.
base class BaseService {
  void initialize() => print('  BaseService initialized');
}

final class StrictConfig {
  final String secretKey = 'XYZ_SECRET_99';
}

mixin class LoggerUtility {
  void log(String msg) => print('  [Log] $msg');
}

void demonstrateClassModifiers() {
  print('--- 6. Class Modifiers ---');

  BaseService service = BaseService();
  service.initialize();

  StrictConfig config = StrictConfig();
  print('StrictConfig secret length: ${config.secretKey.length}');

  LoggerUtility logger = LoggerUtility();
  logger.log('LoggerUtility used directly as an instantiated class!');
  print('');
}

// ============================================================================
// 7. Extension Types (Zero-Cost Inline Types / Abstractions)
// ============================================================================
/// EXPLANATION:
/// Extension Types (introduced in Dart 3.3) provide compile-time type wrappers
/// around existing types with ZERO runtime overhead (Zero Allocation Cost).
///
/// KEY & IMPORTANT POINTS:
/// 1. In Dart 3.3+, `extension type UserId(int id) { ... }` creates a zero-cost wrapper erased at compile time.
/// 2. Prevents domain bugs (e.g. passing a `UserId` where an `OrderId` is expected, even though both are `int` under the hood).
/// 3. Provides clean domain-specific APIs without runtime overhead.
///
/// SYNTAX (Dart 3.3+):
/// ```dart
/// extension type UserId(int id) {
///   bool get isValid => id > 0;
///   String get formatted => 'USER_#${id.toString().padLeft(4, '0')}';
/// }
/// ```
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Rust: Rust `newtype` pattern (`struct UserId(i32);`).
/// - vs Haskell: Haskell `newtype`.
/// - vs Kotlin: Kotlin `value class` / `inline class` (`@JvmInline value class UserId(val id: Int)`).
class UserId {
  final int id;
  const UserId(this.id);

  bool get isValid => id > 0;
  String get formatted => 'USER_#${id.toString().padLeft(4, '0')}';

  @override
  String toString() => formatted;
}

class Dollars {
  final double amount;
  const Dollars(this.amount);

  Dollars operator +(Dollars other) => Dollars(amount + other.amount);
  String get display => '\$${amount.toStringAsFixed(2)}';

  @override
  String toString() => display;
}

void demonstrateExtensionTypes() {
  print('--- 7. Extension Types & Strongly-Typed Domain Wrappers ---');

  UserId userA = const UserId(42);
  print('UserId formatted: ${userA.formatted} (isValid: ${userA.isValid})');

  Dollars price1 = const Dollars(19.99);
  Dollars price2 = const Dollars(5.50);
  Dollars totalPrice = price1 + price2;

  print('Price 1: ${price1.display}');
  print('Price 2: ${price2.display}');
  print('Total Price (via operator +): ${totalPrice.display}');
  print('');
}

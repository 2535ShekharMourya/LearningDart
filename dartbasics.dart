/// ============================================================================
/// DART BASICS: DATA TYPES, VARIABLES, NULL SAFETY & CONTROL FLOW
/// ============================================================================
/// This file provides a complete, exhaustive guide and reference for core Dart
/// language fundamentals.
///
/// TOPICS COVERED:
///  1. Numeric Types: int, double, and num
///  2. Text & Boolean Types: String and bool
///  3. Variable Declarations & Mutability: var, final, and const
///  4. Dynamic & Universal Types: dynamic and Object / Object?
///  5. Type Inference & Smart Casting (Type Promotion)
///  6. Sound Null Safety: Nullable (?) vs Non-Nullable Types & Null Operators
///  7. Conditional Branching: if / else if / else & Ternary Operator
///  8. Switch Statements & Modern Dart 3 Switch Expressions
///  9. For Loops: Standard for, for-in, forEach & Collection for
/// 10. While & Do-While Loops: with break, continue & Labeled Loops
///
/// For each topic:
///  - Detailed explanations and core rules
///  - Key takeaways, common pitfalls & best practices
///  - Cross-language comparisons (Java, Kotlin, Swift, TypeScript/JS, Python, C++)
///  - Working, runnable Dart examples with clear outputs
/// ============================================================================

void main() {
  print('===============================================================');
  print('              DART BASICS: MASTERCLASS REFERENCE               ');
  print('===============================================================\n');

  demonstrateNumericTypes();
  demonstrateStringAndBool();
  demonstrateVarFinalConst();
  demonstrateDynamicAndObject();
  demonstrateTypeInferenceAndCasting();
  demonstrateNullSafety();
  demonstrateIfElseBranching();
  demonstrateSwitchAndPatterns();
  demonstrateForLoops();
  demonstrateWhileLoops();

  print('\n===============================================================');
  print('           DART BASICS GUIDE COMPLETED SUCCESSFULLY            ');
  print('===============================================================');
}

// ============================================================================
// 1. Numeric Types: int, double, and num
// ============================================================================
/// EXPLANATION:
/// Dart provides two concrete numeric types: `int` and `double`.
/// Both inherit from the abstract class `num`.
///
/// - `int`: 64-bit signed integers on 64-bit platforms (ranging from -2^63 to 2^63 - 1).
///   When compiled to JavaScript (Dart Web), integers are represented as IEEE 754
///   floating-point numbers without fractional parts (-2^53 to 2^53 - 1).
/// - `double`: 64-bit IEEE 754 double-precision floating-point numbers.
/// - `num`: An abstract superclass representing any number (`int` or `double`).
///   Useful when a variable or function parameter needs to accept both integers
///   and floating-point numbers polymorphically.
///
/// KEY & IMPORTANT POINTS:
/// 1. In Dart, numbers are objects (instances of classes), not primitive types.
///    They have methods like `.abs()`, `.round()`, `.toDouble()`, etc.
/// 2. Integer division uses the `~/` operator (e.g., `7 ~/ 2 == 3`). Regular `/`
///    always produces a `double` (e.g., `7 / 2 == 3.5`), even when dividing two `int`s!
/// 3. Dart supports hexadecimal literals (e.g., `0xFF`), scientific notation (e.g., `1.42e5`),
///    and bitwise operations on `int` (`&`, `|`, `^`, `~`, `<<`, `>>`, `>>>`).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java/C++: In Java/C++, `int` and `double` are primitive types with separate wrapper
///   classes (`Integer`, `Double`). In Dart, everything is an object.
/// - vs JavaScript: JS previously had only one `number` type (double). Dart separates `int` and `double`.
/// - vs Python: Python integers have arbitrary precision (unlimited length). Dart `int` is 64-bit native.
void demonstrateNumericTypes() {
  print('--- 1. NUMERIC DATA TYPES (int, double, num) ---');

  // 1.1 `int` examples
  int age = 28;
  int hexValue = 0xDEADBEEF;
  int bitwiseShift = 1 << 4; // 16
  int bitwiseAnd = 0xF0 & 0x0F; // 0

  print('Integer age: $age');
  print('Hex value: 0xDEADBEEF = $hexValue');
  print('Bitwise shift (1 << 4): $bitwiseShift | Bitwise AND (0xF0 & 0x0F): $bitwiseAnd');
  print('isEven / isOdd: ${age.isEven} / ${age.isOdd}');
  print('Parsed int: ${int.parse('42')} | tryParse invalid: ${int.tryParse('abc')}');

  // 1.2 `double` examples
  double price = 19.99;
  double exponent = 1.42e5; // 142000.0
  double piApprox = 3.1415926535;

  print('Double price: \$$price');
  print('Scientific notation: $exponent');
  print('Formatted to 2 decimal places: ${piApprox.toStringAsFixed(2)}');
  print('Ceil: ${piApprox.ceil()} | Floor: ${piApprox.floor()} | Round: ${piApprox.round()}');

  // Special double values
  double inf = double.infinity;
  double notANum = double.nan;
  print('Special doubles: infinity=${inf.isInfinite}, nan=${notANum.isNaN}');

  // 1.3 Division operators (/ vs ~/)
  int dividend = 10;
  int divisor = 3;
  double regularDiv = dividend / divisor; // Always returns double: 3.3333333333333335
  int integerDiv = dividend ~/ divisor;  // Truncating integer division: 3
  int remainder = dividend % divisor;    // Modulo: 1

  print('10 / 3 = $regularDiv (double)');
  print('10 ~/ 3 = $integerDiv (int truncating division)');
  print('10 % 3 = $remainder (modulo)');

  // 1.4 `num` (Supertype of int and double)
  num flexibleNumber = 100; // Currently holding an int
  print('num holding int: $flexibleNumber (runtimeType: ${flexibleNumber.runtimeType})');
  flexibleNumber = 99.95;   // Reassigned to a double
  print('num holding double: $flexibleNumber (runtimeType: ${flexibleNumber.runtimeType})');
  print('num clamped between (0, 50): ${flexibleNumber.clamp(0, 50)}');
  print('');
}

// ============================================================================
// 2. Text & Boolean Types: String and bool
// ============================================================================
/// EXPLANATION:
/// - `String`: Represents a sequence of UTF-16 code units. Strings in Dart are
///   immutable objects. Once created, a string's content cannot be modified.
/// - `bool`: Represents boolean values with exactly two compile-time constants:
///   `true` and `false`.
///
/// KEY & IMPORTANT POINTS:
/// 1. String Interpolation: Use `$variableName` or `${expression}` inside strings.
///    Avoid string concatenation (`+`) when interpolation is cleaner and faster.
/// 2. Multi-line Strings: Created using triple quotes (`'''` or `"""`). Preserves line breaks.
/// 3. Raw Strings: Prefix with `r` (e.g., `r'C:\workspace\new_folder'`) to treat backslashes
///    as literal characters rather than escape sequences.
/// 4. STRICT BOOLEAN EVALUATION: Dart requires explicit boolean expressions in `if`,
///    `while`, `assert`, and ternary conditions. There is NO "truthy" or "falsy" coercion
///    (e.g., `if (1)`, `if ("hello")`, or `if (null)` will NOT compile!).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript: In JS, `0`, `""`, `null`, `undefined`, and `NaN` are falsy.
///   In Dart, ONLY `true` is boolean true. `if (count)` is a compile-time error.
/// - vs Python: Python supports truthy/falsy evaluation on lists, dicts, numbers. Dart does not.
/// - vs Swift/Kotlin: Swift and Kotlin also enforce strict boolean types, matching Dart's philosophy.
void demonstrateStringAndBool() {
  print('--- 2. STRING & BOOLEAN TYPES (String, bool) ---');

  // 2.1 String creation and features
  String singleQuote = 'Single quoted string';
  String doubleQuote = "Double quoted string";
  String interpolated = 'Interpolation: 10 + 20 = ${10 + 20}';
  String multiline = '''
  Line 1
  Line 2
  Line 3
  ''';
  String rawString = r'Raw string: \n is not a newline, and \t is not a tab';

  print('Single quote: $singleQuote');
  print('Double quote: $doubleQuote');
  print('Interpolated: $interpolated');
  print('Multi-line:\n$multiline');
  print('Raw string: $rawString');

  // 2.2 Common String methods
  String message = '   Welcome to Dart Programming!   ';
  print('Original length: ${message.length}');
  print('Trimmed: "${message.trim()}"');
  print('Uppercase: "${message.trim().toUpperCase()}"');
  print('Contains "Dart": ${message.contains('Dart')}');
  print('Replaced: "${message.replaceAll('Dart', 'Flutter').trim()}"');
  print('Split by space: ${message.trim().split(' ')}');
  print('Substring (0, 7): "${message.trim().substring(0, 7)}"');

  // 2.3 Runes and UTF-16 Code Points (Emojis and Unicode)
  String emojiText = 'Dart is awesome 🎯 🚀';
  print('Emoji String: $emojiText');
  print('Unicode Runes length: ${emojiText.runes.length} vs CodeUnits: ${emojiText.codeUnits.length}');

  // 2.4 Strict `bool` evaluation
  bool isActive = true;
  bool isCompleted = false;
  bool logicalResult = (isActive && !isCompleted);

  print('isActive: $isActive, isCompleted: $isCompleted');
  print('Logical expression result: $logicalResult');

  // Note: Non-boolean types cannot be used in conditions directly
  List<int> items = [];
  // if (items.length) { } // ERROR: The argument type 'int' can't be assigned to 'bool'.
  if (items.isEmpty) {
    print('Strict boolean check: items.isEmpty is true');
  }
  print('');
}

// ============================================================================
// 3. Variable Declarations & Mutability: var, final, and const
// ============================================================================
/// EXPLANATION:
/// Dart offers several keywords to declare variables with different levels of
/// mutability and compile-time guarantees:
///
/// 1. `var`: Type-inferred variable declaration. Dart infers the static type from
///    the initial value. Once inferred, the type CANNOT change, but the value CAN.
/// 2. `final`: Single-assignment runtime constant. A `final` variable can only be
///    assigned once, and its value is determined when evaluated at runtime.
///    The reference is immutable, but the object itself may be mutable unless frozen.
/// 3. `const`: Compile-time constant. The value must be fully known and computed at
///    compile-time. All `const` variables are implicitly `final` and deeply immutable.
///    Identical `const` instances are canonicalized (share the exact same memory address).
///
/// KEY & IMPORTANT POINTS:
/// - Use `var` for local variables whose values will change over time.
/// - Use `final` for variables that should not change after runtime initialization (default choice for Flutter fields).
/// - Use `const` for compile-time constants (values known before compilation, e.g., configuration, fixed layouts).
/// - Const lists/maps/sets are completely immutable at runtime; attempting to mutate them throws `UnsupportedError`.
///
/// COMPARISON TABLE:
/// ----------------------------------------------------------------------------------
/// Keyword | Can Reassign? | Evaluated When? | Object Deeply Immutable?
/// ----------------------------------------------------------------------------------
/// var     | YES           | Runtime         | NO
/// final   | NO            | Runtime         | NO (unless object itself is const)
/// const   | NO            | Compile-time    | YES (deeply immutable & canonicalized)
/// ----------------------------------------------------------------------------------
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs JavaScript: `var` in Dart is block-scoped and statically typed (like TS `let`), unlike JS function-scoped `var`.
///   Dart `final` is like JS `const`. Dart `const` is compile-time `const` (has no direct JS equivalent).
/// - vs Kotlin: `var` in Dart == `var` in Kotlin. `final` in Dart == `val` in Kotlin.
/// - vs C++: `final` is like `const` reference; `const` in Dart is like `constexpr` in C++.
void demonstrateVarFinalConst() {
  print('--- 3. VARIABLE DECLARATIONS & MUTABILITY (var, final, const) ---');

  // 3.1 `var` - Statically inferred, reassignable value
  var inferredString = 'Hello Dart'; // Inferred as String
  // inferredString = 42; // COMPILE ERROR: A value of type 'int' can't be assigned to 'String'.
  inferredString = 'Hello Flutter'; // Allowed: same type reassignment
  print('var inferred variable: $inferredString (Type: ${inferredString.runtimeType})');

  // 3.2 `final` - Runtime constant (Single assignment)
  final DateTime appStartTime = DateTime.now(); // Value determined at runtime
  // appStartTime = DateTime.now(); // COMPILE ERROR: 'appStartTime' can only be set once.
  print('final appStartTime: $appStartTime');

  // Final reference vs object mutation
  final List<String> finalColors = ['Red', 'Green'];
  finalColors.add('Blue'); // Allowed: mutating the object, not the variable reference
  // finalColors = ['Cyan', 'Magenta']; // COMPILE ERROR: Cannot reassign final variable
  print('final list after internal mutation: $finalColors');

  // 3.3 `const` - Compile-time constant (Deeply immutable)
  const double gravity = 9.80665;
  const int maxRetries = 3;
  const List<String> constColors = ['Red', 'Green', 'Blue'];
  // constColors.add('Yellow'); // RUNTIME ERROR: Unsupported operation: Cannot add to an unmodifiable list

  print('const gravity: $gravity, maxRetries: $maxRetries');
  print('const list: $constColors');

  // 3.4 Canonicalization of `const` instances (Memory Sharing)
  const listA = [1, 2, 3];
  const listB = [1, 2, 3];
  final listC = [1, 2, 3];
  final listD = [1, 2, 3];

  print('const listA == const listB: ${identical(listA, listB)} (Identical in memory: TRUE)');
  print('final listC == final listD: ${identical(listC, listD)} (Identical in memory: FALSE)');
  print('');
}

// ============================================================================
// 4. Dynamic & Universal Types: dynamic and Object / Object?
// ============================================================================
/// EXPLANATION:
/// Dart is statically typed, but provides universal types and dynamic typing when needed:
///
/// 1. `dynamic`: An escape hatch from static type checking. When a variable is `dynamic`,
///    the compiler turns off all static checks. Any method or property can be called on it;
///    resolution occurs at runtime. If the method does not exist, it throws `NoSuchMethodError`.
/// 2. `Object`: The root of the non-nullable Dart type hierarchy. Every non-null type is
///    a subtype of `Object`. The compiler only allows methods declared on `Object`
///    (`.toString()`, `.hashCode`, `==`, `.runtimeType`, `.noSuchMethod()`) unless type-checked.
/// 3. `Object?`: The ultimate top type in Dart (supertype of everything, including `null`).
///
/// KEY DIFFERENCE: `dynamic` vs `Object`:
/// - `dynamic x`: "I don't know the type, disable static checks and let me call anything at runtime."
/// - `Object x`: "I know this is a non-null object, but I don't know the specific type. Enforce type safety!"
/// - `Object? x`: "This can be literally anything, including null."
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs TypeScript: `dynamic` in Dart is like `any` in TS. `Object?` in Dart is like `unknown` in TS.
/// - vs C#: Dart `dynamic` == C# `dynamic`. Dart `Object` == C# `object`.
/// - vs Java: Dart `Object?` is similar to Java's `Object` reference which can hold null.
void demonstrateDynamicAndObject() {
  print('--- 4. DYNAMIC & UNIVERSAL TYPES (dynamic, Object, Object?) ---');

  // 4.1 `dynamic` - No compile-time checks
  dynamic dynamicVariable = 'Initial string';
  print('dynamic as String: $dynamicVariable (Type: ${dynamicVariable.runtimeType})');
  
  dynamicVariable = 12345; // Can change types at runtime
  print('dynamic reassigned to int: $dynamicVariable (Type: ${dynamicVariable.runtimeType})');
  
  dynamicVariable = [1, 2, 3];
  print('dynamic reassigned to List: $dynamicVariable (length: ${dynamicVariable.length})');

  // Calling dynamic methods safely vs handling NoSuchMethodError
  try {
    dynamic unknownObject = 'Dart String';
    print('Dynamic length property: ${unknownObject.length}');
    // Calling a nonexistent method on dynamic will fail only at runtime:
    // unknownObject.nonExistentMethod();
  } catch (e) {
    print('Caught runtime error on dynamic: $e');
  }

  // 4.2 `Object` (Type-safe non-null root)
  Object safeObject = 'Hello from Object';
  // print(safeObject.length); // COMPILE ERROR: The getter 'length' isn't defined for the class 'Object'.
  print('Object.toString(): ${safeObject.toString()}');
  print('Object.runtimeType: ${safeObject.runtimeType}');
  print('Object.hashCode: ${safeObject.hashCode}');

  // To access specific members, use type checking (Smart Casting):
  if (safeObject is String) {
    print('Safely accessed String.length via type check: ${safeObject.length}');
  }

  // 4.3 `Object?` (Top type including null)
  Object? nullableUniversal = null;
  print('Object? holding null: $nullableUniversal');
  nullableUniversal = 42;
  print('Object? holding int: $nullableUniversal');
  print('');
}

// ============================================================================
// 5. Type Inference & Smart Casting (Type Promotion)
// ============================================================================
/// EXPLANATION:
/// Dart features sophisticated static type inference and control-flow based
/// smart casting (called Type Promotion).
///
/// - Type Inference: Dart automatically deduces types from initializers, return
///   types of expressions, and generic constructor invocations.
/// - Type Promotion: When the compiler analyzes control flow (like `is` checks,
///   `is!` checks, or null checks), it automatically promotes the variable to
///   the narrower type inside the guarded scope.
///
/// TYPE TESTING OPERATORS:
/// - `is`: Returns `true` if the object is of the specified type (e.g., `x is int`).
/// - `is!`: Returns `true` if the object is NOT of the specified type (e.g., `x is! String`).
/// - `as`: Explicit type cast operator. Throws `TypeError` at runtime if the cast fails.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java: Java requires explicit casting `((String) obj).length()`, whereas Dart smart-casts automatically.
/// - vs Kotlin / TypeScript: Dart's type promotion mirrors Kotlin's smart cast and TypeScript's type narrowing.
void demonstrateTypeInferenceAndCasting() {
  print('--- 5. TYPE INFERENCE & SMART CASTING ---');

  // 5.1 Local variable & Generic type inference
  var city = 'Tokyo';                  // Inferred as String
  var score = 98.5;                   // Inferred as double
  var numberList = [1, 2, 3, 4];      // Inferred as List<int>
  var userMap = {'id': 101, 'age': 25}; // Inferred as Map<String, int>

  print('Inferred city: $city (${city.runtimeType})');
  print('Inferred score: $score (${score.runtimeType})');
  print('Inferred numberList: $numberList (${numberList.runtimeType})');
  print('Inferred userMap: $userMap (${userMap.runtimeType})');

  // 5.2 Smart Casting with `is` operator
  Object unknownData = 'Smart cast demonstration';

  if (unknownData is String) {
    // Inside this block, `unknownData` is automatically promoted from `Object` to `String`
    print('Promoted to String! Length = ${unknownData.length}, Uppercase = ${unknownData.toUpperCase()}');
  }

  // 5.3 `is!` (is not) check with early return pattern
  void processInput(Object input) {
    if (input is! num) {
      print('Input is not a number: $input');
      return;
    }
    // Promoted to `num` after the guard clause
    print('Promoted to num! Squared = ${input * input}');
  }

  processInput('Hello');
  processInput(7);

  // 5.4 Explicit Type Casting with `as`
  num baseNumber = 100;
  int explicitInt = baseNumber as int; // Explicit cast
  print('Explicit cast via `as`: $explicitInt');

  try {
    Object textObj = 'Not an integer';
    int failedCast = textObj as int; // Throws TypeError at runtime
    print('Failed cast: $failedCast');
  } catch (e) {
    print('Caught cast exception: $e');
  }
  print('');
}

// ============================================================================
// 6. Sound Null Safety: Nullable (?) vs Non-Nullable Types & Operators
// ============================================================================
/// EXPLANATION:
/// Dart uses SOUND NULL SAFETY (introduced in Dart 2.12, strict default in Dart 3+).
/// In sound null safety, types are non-nullable by default. A variable cannot contain
/// `null` unless explicitly marked as nullable with a question mark (`?`).
///
/// WHY SOUND NULL SAFETY MATTERS:
/// 1. Prevents `NullPointerException` / `NoSuchMethodError` crashes at runtime.
/// 2. Enables the compiler to optimize machine code because it guarantees a non-null
///    variable will NEVER be null.
///
/// NULL-AWARE OPERATORS:
/// - `T?`: Nullable type annotation (e.g., `String?`).
/// - `?.`: Null-aware method/property access. Returns `null` if target is `null`.
/// - `??`: If-null operator (default fallback value). `expr1 ?? expr2`.
/// - `??=`: Null-aware assignment. Assigns value ONLY if variable is currently `null`.
/// - `!`: Null assertion operator (Bang operator). Tells compiler "trust me, this is not null".
///   Throws runtime exception if value is actually null!
/// - `late`: Delays initialization of a non-nullable variable to runtime.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Kotlin: Identical concept (`?`, `?.`, `?:` is `??` in Dart, `!!` is `!` in Dart).
/// - vs TypeScript: TypeScript null safety is not 100% sound at runtime (erased at runtime).
///   Dart null safety is 100% sound (enforced both at compile-time and runtime).
/// - vs Swift: Dart nullable types correspond to Swift Optionals (`Optional<T>`).
void demonstrateNullSafety() {
  print('--- 6. SOUND NULL SAFETY (Nullable vs Non-Nullable) ---');

  // 6.1 Non-nullable vs Nullable types
  String nonNullableName = 'Alice';
  // nonNullableName = null; // COMPILE ERROR: The value 'null' can't be assigned to a variable of type 'String'.

  String? nullableName = null; // Valid: explicitly nullable
  print('Non-nullable: $nonNullableName | Nullable: $nullableName');

  // Helper function to showcase null safety across boundaries
  int? getLength(String? input) {
    // 6.2 Null-aware member access (`?.`)
    return input?.length;
  }

  print('getLength(null) via `?.`: ${getLength(null)}');
  print('getLength("San Francisco") via `?.`: ${getLength("San Francisco")}');

  // 6.3 If-null default value operator (`??`)
  String? fetchUsername(bool returnNull) => returnNull ? null : 'DartDeveloper';

  String guestUser = fetchUsername(true) ?? 'Guest User';
  String authenticatedUser = fetchUsername(false) ?? 'Guest User';
  print('Display name with default fallback: $guestUser');
  print('Display name when value present: $authenticatedUser');

  // 6.4 Null-aware assignment (`??=`)
  int? targetCounter;
  targetCounter ??= 10; // Assigned 10 because targetCounter was null
  print('targetCounter after ??= 10 : $targetCounter');

  // 6.5 Null assertion operator (`!`)
  String? fetchApiEndpoint() => 'https://api.dart.dev/v1';
  String guaranteedUrl = fetchApiEndpoint()!; // Asserting non-null from nullable return
  print('Guaranteed URL via ! operator: $guaranteedUrl');

  // 6.6 Flow Analysis & Null Promotion
  String? getGreeting([bool provideValue = true]) =>
      provideValue ? 'Hello World' : null;

  String? nullableGreeting = getGreeting(true);
  if (nullableGreeting != null) {
    // Flow analysis automatically promotes `nullableGreeting` to non-nullable `String`
    print('Promoted non-null greeting length: ${nullableGreeting.length}');
  }

  // 6.7 `late` keyword (Delayed / Lazy Initialization)
  late String deferredConfig;
  // Initialize later before first read
  deferredConfig = 'CONFIG_KEY_XYZ_999';
  print('Late initialized variable: $deferredConfig');
  print('');
}

// ============================================================================
// 7. Conditional Branching: if / else if / else & Ternary Operator
// ============================================================================
/// EXPLANATION:
/// Dart supports standard structured conditional statements:
/// - `if (condition) { ... }`
/// - `else if (condition) { ... }`
/// - `else { ... }`
/// - Ternary conditional expression: `condition ? exprIfTrue : exprIfFalse`
/// - Dart 3 `if-case` pattern matching with optional guard (`when`).
///
/// KEY & IMPORTANT POINTS:
/// 1. Conditions inside `if` MUST evaluate to a boolean (`bool`).
/// 2. Ternary expressions return a value and are ideal for concise inline decisions.
/// 3. Dart 3 introduced `if (value case pattern)` for expressive pattern matching
///    and destructuring directly within `if` statements.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Python: Python uses `if / elif / else` and `val = a if cond else b`. Dart uses C-style syntax.
/// - vs Java/C++: Direct match with C/Java syntax, but Dart adds modern pattern matching in `if-case`.
void demonstrateIfElseBranching() {
  print('--- 7. CONDITIONAL BRANCHING (if / else & Ternary) ---');

  int score = 85;

  // 7.1 Traditional if / else if / else
  String grade;
  if (score >= 90) {
    grade = 'A';
  } else if (score >= 80) {
    grade = 'B';
  } else if (score >= 70) {
    grade = 'C';
  } else if (score >= 60) {
    grade = 'D';
  } else {
    grade = 'F';
  }
  print('Score: $score => Grade: $grade');

  // 7.2 Ternary conditional operator (`condition ? trueVal : falseVal`)
  String getGreeting(bool loggedIn) =>
      loggedIn ? 'Welcome back, User!' : 'Please sign in.';

  print('Ternary status (logged in): ${getGreeting(true)}');
  print('Ternary status (logged out): ${getGreeting(false)}');

  // Nested ternary (clean function representation)
  String evaluateWeather(int temp) => temp > 30
      ? 'Hot'
      : temp >= 18
          ? 'Pleasant'
          : 'Cold';

  print('Temperature 22°C is ${evaluateWeather(22)}');
  print('Temperature 10°C is ${evaluateWeather(10)}');

  // 7.3 Dart 3 Pattern Matching in `if-case`
  dynamic response = {'status': 200, 'body': 'Success payload'};

  if (response case {'status': 200, 'body': String body}) {
    print('Dart 3 if-case matched: Status 200 with body: "$body"');
  }

  // If-case with guard clause (`when`)
  int number = 42;
  if (number case int n when n > 40 && n.isEven) {
    print('Dart 3 if-case with guard: $n is an even number greater than 40');
  }
  print('');
}

// ============================================================================
// 8. Switch Statements & Modern Dart 3 Switch Expressions
// ============================================================================
/// EXPLANATION:
/// Dart supports two flavors of switch:
/// 1. Traditional `switch` statement: Executes blocks of code with `case`, `break`,
///    `continue label:`, and `default:`.
/// 2. Modern Dart 3 `switch` expression: Evaluates an expression, matches patterns,
///    and directly returns a value using `=>` fat-arrow syntax. It enforces
///    EXHAUSTIVENESS (all possible cases must be handled).
///
/// PATTERNS SUPPORTED IN DART 3 SWITCH:
/// - Relational patterns: `< 0`, `>= 100`
/// - Logical patterns: `> 0 && < 10`, `1 || 2 || 3`
/// - Wildcard: `_` (matches anything / default fallback)
/// - Type patterns: `int x`, `String s`
/// - Record / Tuple destructuring: `(int x, int y)`
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Rust: Dart 3 switch expressions are heavily inspired by Rust's `match`.
/// - vs Kotlin: Equivalent to Kotlin's `when` expression.
/// - vs Java: Modern Java 17+ switch expressions (`case X -> ...`) operate similarly.
void demonstrateSwitchAndPatterns() {
  print('--- 8. SWITCH STATEMENTS & DART 3 SWITCH EXPRESSIONS ---');

  // 8.1 Traditional switch statement
  String command = 'PAUSE';

  switch (command) {
    case 'START':
      print('Traditional switch: Starting engine...');
      break;
    case 'PAUSE':
      print('Traditional switch: Engine paused.');
      break;
    case 'STOP':
      print('Traditional switch: Engine stopped.');
      break;
    default:
      print('Traditional switch: Unknown command.');
  }

  // 8.2 Fall-through with labeled jump (`continue label:`)
  String step = 'STAGE_1';
  switch (step) {
    case 'STAGE_1':
      print('Executing Stage 1...');
      continue stage2Label; // Explicit jump to another case

    stage2Label:
    case 'STAGE_2':
      print('Executing Stage 2 (chained from Stage 1)...');
      break;
  }

  // 8.3 Modern Dart 3 Switch Expression (Returns a value directly)
  String httpStatusMessage(int statusCode) {
    return switch (statusCode) {
      200 => '200 OK - Request Succeeded',
      201 => '201 Created - Resource Created',
      400 => '400 Bad Request - Invalid Payload',
      401 || 403 => '401/403 - Authentication / Authorization Failed',
      404 => '404 Not Found - Resource Missing',
      >= 500 && < 600 => '5xx Server Error',
      _ => 'Unknown Status Code ($statusCode)', // Wildcard default
    };
  }

  print('Switch expression (200): ${httpStatusMessage(200)}');
  print('Switch expression (403): ${httpStatusMessage(403)}');
  print('Switch expression (503): ${httpStatusMessage(503)}');

  // 8.4 Pattern Matching on Object Types in Switch Expression
  String describeType(Object value) {
    return switch (value) {
      int i => 'Integer: $i (even: ${i.isEven})',
      double d => 'Double: $d (fixed: ${d.toStringAsFixed(1)})',
      String s when s.isEmpty => 'Empty String',
      String s => 'String: "$s" (length: ${s.length})',
      bool b => 'Boolean: $b',
      _ => 'Other Object: $value',
    };
  }

  print(describeType(42));
  print(describeType(3.1415));
  print(describeType(''));
  print(describeType('Dart 3'));
  print(describeType(true));
  print('');
}

// ============================================================================
// 9. For Loops: Standard for, for-in, forEach & Collection for
// ============================================================================
/// EXPLANATION:
/// Dart offers several ways to loop and iterate over collections:
///
/// 1. Standard C-Style for loop: `for (int i = 0; i < n; i++)`
///    Best when index position or step size manipulation is needed.
/// 2. `for-in` loop: `for (final item in collection)`
///    Iterates over any object implementing `Iterable<T>` (Lists, Sets, Maps keys/values).
/// 3. `forEach()` method: Higher-order method on `Iterable` taking a callback function.
/// 4. Collection `for`: Built-in Dart feature inside List/Set/Map literals to dynamically
///    construct elements (extensively used in Flutter widget trees).
///
/// KEY & IMPORTANT POINTS:
/// - Prefer `for-in` loops for readable, clean iterations over collections.
/// - Avoid `forEach` with asynchronous callbacks (it doesn't wait for Futures).
/// - Use Collection `for` to build declarative collections without boilerplate `add()` calls.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Python: `for-in` in Dart is equivalent to `for item in iterable:` in Python.
/// - vs JavaScript: Dart `for-in` behaves like JS `for-of` (iterates values, not keys).
/// - vs Java: Dart `for-in` is equivalent to Java enhanced `for (Type item : list)`.
void demonstrateForLoops() {
  print('--- 9. FOR LOOPS (Standard for, for-in, forEach, Collection for) ---');

  // 9.1 Traditional index-based for loop
  print('Standard index-based for loop:');
  List<String> frameworks = ['Flutter', 'AngularDart', 'Shelf'];
  for (int i = 0; i < frameworks.length; i++) {
    print('  Index $i: ${frameworks[i]}');
  }

  // 9.2 for-in loop over List and Set
  print('for-in loop over List:');
  final numbers = [10, 20, 30, 40];
  int sum = 0;
  for (final num in numbers) {
    sum += num;
  }
  print('  Sum calculated via for-in: $sum');

  // 9.3 for-in loop over Map entries
  print('for-in loop over Map entries:');
  Map<String, int> stock = {'Apples': 50, 'Bananas': 30, 'Oranges': 25};
  for (final entry in stock.entries) {
    print('  Product: ${entry.key}, Quantity: ${entry.value}');
  }

  // 9.4 forEach method (with Lambda / Tear-off)
  print('forEach with lambda:');
  frameworks.forEach((fw) => print('  Framework: $fw'));

  // 9.5 Collection `for` (Inside List literals)
  List<int> rawNumbers = [1, 2, 3, 4, 5];
  List<String> formattedLabels = [
    'Header',
    for (var n in rawNumbers) 'Item #$n (${n * 10} pts)',
    'Footer'
  ];
  print('Collection for result:');
  formattedLabels.forEach((label) => print('  $label'));
  print('');
}

// ============================================================================
// 10. While & Do-While Loops (with break, continue & Labeled Loops)
// ============================================================================
/// EXPLANATION:
/// - `while` loop: Entry-controlled loop. The condition is evaluated BEFORE the loop
///   body executes. If the condition is initially `false`, the loop never runs.
/// - `do-while` loop: Exit-controlled loop. The loop body executes FIRST, and then
///   the condition is evaluated. Guarantees the body executes AT LEAST ONCE.
/// - `break`: Immediately exits the nearest enclosing loop.
/// - `continue`: Skips the remainder of the current iteration and jumps to the next iteration.
/// - Labeled Loops: Allows `break` or `continue` to target an outer nested loop.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - Identical behavior across Java, C++, C#, JavaScript, and Kotlin.
void demonstrateWhileLoops() {
  print('--- 10. WHILE & DO-WHILE LOOPS (with break, continue, labels) ---');

  // 10.1 Entry-controlled `while` loop
  int countdown = 3;
  print('While loop countdown:');
  while (countdown > 0) {
    print('  T-minus $countdown...');
    countdown--;
  }
  print('  Blast off! 🚀');

  // 10.2 Exit-controlled `do-while` loop (Guaranteed at least 1 execution)
  int attempts = 0;
  print('Do-while loop execution:');
  do {
    attempts++;
    print('  Attempt #$attempts executed.');
  } while (attempts < 3);

  // 10.3 Using `break` and `continue`
  print('Loop with break and continue:');
  int counter = 0;
  while (counter < 10) {
    counter++;

    if (counter == 3) {
      print('  Skipping 3 (continue)');
      continue; // Skip the rest of this iteration
    }

    if (counter == 6) {
      print('  Stopping at 6 (break)');
      break; // Terminate loop early
    }

    print('  Counter value: $counter');
  }

  // 10.4 Labeled break in nested loops
  print('Nested loops with labeled break:');
  outerLoop:
  for (int row = 1; row <= 3; row++) {
    for (int col = 1; col <= 3; col++) {
      if (row == 2 && col == 2) {
        print('  Breaking out of outerLoop at row=$row, col=$col');
        break outerLoop; // Breaks out of the outer loop entirely
      }
      print('  Matrix cell: [$row, $col]');
    }
  }
  print('');
}

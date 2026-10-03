/// ============================================================================
/// SOUND NULL SAFETY IN DART: COMPREHENSIVE DEEP DIVE & REFERENCE
/// ============================================================================
/// This file covers:
///  1. Sound Null Safety Architecture & Type System
///  2. Nullable (`Type?`) vs Non-Nullable (`Type`)
///  3. Null-Aware Operators (`?.`, `??`, `??=`, `!`, `?..`, `?[]`)
///  4. The `late` Keyword (Lazy initialization & Late Final)
///  5. Flow Analysis, Smart Casting & Type Promotion
///  6. Property Promotion Gotchas & Local Variable Shadowing Pattern
///  7. Generics & Null Safety (`T`, `T?`, `T extends Object`)
///  8. The `Never` Type (Bottom Type for Unreachable Flow)
///
/// For each topic:
///  - Working runnable examples
///  - In-depth architectural explanations
///  - Important Points & Best Practices
///  - Cross-language comparisons (Kotlin, Swift, TypeScript, Java, C#)
/// ============================================================================

void main() {
  print('===============================================================');
  print('          DART SOUND NULL SAFETY: MASTERCLASS REFERENCE        ');
  print('===============================================================\n');

  demonstrateSoundNullSafetyArchitecture();
  demonstrateNullAwareOperators();
  demonstrateLateKeyword();
  demonstrateFlowAnalysisAndTypePromotion();
  demonstratePropertyPromotionPattern();
  demonstrateGenericsAndNullSafety();
  demonstrateNeverType();

  print('\n===============================================================');
  print('          NULL SAFETY DEMONSTRATIONS COMPLETED SUCCESSFULLY     ');
  print('===============================================================');
}

// ============================================================================
// 1. Sound Null Safety Architecture & Type System
// ============================================================================
/// EXPLANATION:
/// Dart's null safety is SOUND.
/// Soundness means the type system is guaranteed at compile-time AND runtime.
/// If a variable has type `String`, the Dart VM and compiler guarantee it can NEVER
/// contain `null` under any circumstances.
///
/// TYPE HIERARCHY / LATTICE:
/// - Top Type: `Object?` (can hold any object or `null`).
/// - Middle: Two parallel hierarchies:
///     * Non-nullable types: `Object`, `String`, `int`, `List<int>`, etc.
///     * Nullable types: `String?`, `int?`, `List<int>?`, `Null`.
/// - Bottom Type: `Never` (a subtype of every type, represents unreachable code).
///
/// WHY SOUNDNESS MATTERS (Benefits):
/// 1. Zero NullPointerExceptions on non-nullable variables.
/// 2. Compiler Optimization: AOT compilers omit redundant runtime null checks,
///    reducing binary size and boosting CPU execution speed.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs TypeScript: TypeScript has `string | null` in strict mode, but TS types are completely
///   erased at runtime. If an API returns `null`, TS runtime will still crash. Dart is 100% sound at runtime!
/// - vs Kotlin: Kotlin is also null-safe (`String?` vs `String`), but platform types from Java can bypass it.
/// - vs Swift: Swift uses `Optional<Wrapped>` enum with syntactic sugar `?` and `!`.
/// - vs Java: Java references are nullable by default, leading to the "Billion Dollar Mistake".
void demonstrateSoundNullSafetyArchitecture() {
  print('--- 1. Sound Null Safety Architecture ---');

  // Non-nullable variable (guaranteed non-null)
  String mandatoryTitle = 'Sound Null Safety in Dart';
  print('Non-nullable title: $mandatoryTitle');

  // Nullable variable
  String? optionalSubtitle = null;
  print('Nullable subtitle (holding null): $optionalSubtitle');
  optionalSubtitle = 'Safe by Design';
  print('Nullable subtitle (holding string): $optionalSubtitle');
  print('');
}

// ============================================================================
// 2. Null-Aware Operators (?. , ?? , ??= , ! , ?.. , ?[])
// ============================================================================
/// EXPLANATION:
/// Dart provides a comprehensive suite of null-aware operators to handle nullable values concisely.
///
/// OPERATORS SUMMARY:
/// 1. Null-aware property/method access: `obj?.property` or `obj?.method()`
///    - If `obj` is null, returns `null` immediately without throwing.
/// 2. Null-coalescing / Default operator: `expr1 ?? expr2`
///    - Returns `expr1` if non-null; otherwise evaluates and returns `expr2`.
/// 3. Null-coalescing assignment: `target ??= value`
///    - Assigns `value` to `target` ONLY if `target` is currently null.
/// 4. Null assertion / Bang operator: `expr!`
///    - Casts a nullable `T?` to non-nullable `T`. Throws `TypeError` if `expr` is null.
/// 5. Null-aware cascade: `obj?..method1()..method2()`
///    - Executes cascade chain only if `obj` is not null.
/// 6. Null-aware index operator: `list?[0]` or `map?[key]`
///    - Reads index or key safely if collection is not null.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Kotlin: Kotlin has `?.`, `?:` (Elvis operator, equivalent to Dart's `??`), `!!` (bang operator, equivalent to Dart's `!`).
/// - vs JavaScript/TypeScript: JS has `?.` (optional chaining), `??` (nullish coalescing), `??=` (assignment), `!` (TS non-null assertion).
/// - vs Swift: Swift has `?.`, `??`, `!`.
class ProfileConfig {
  String theme = 'light';
  void enableNotifications() => print('    Notifications enabled on profile');
}

void demonstrateNullAwareOperators() {
  print('--- 2. Null-Aware Operators ---');

  // Helper with nullable input to show operators dynamically
  void analyzeUser(String? name, Map<String, String>? metadata, ProfileConfig? config) {
    // 1. Null-aware access (?.)
    int? length = name?.length;
    print('  name?.length: $length');

    // 2. Null-coalescing (??)
    String safeName = name ?? 'Default Guest';
    print('  safeName (??): $safeName');

    // 3. Null-coalescing assignment (??=)
    String? localAlias = name;
    localAlias ??= 'Anonymous_Alias';
    print('  localAlias (??=): $localAlias');

    // 4. Null-aware indexing (?[])
    String? role = metadata?['role'];
    print('  metadata?["role"]: $role');

    // 5. Null-aware cascade (?..)
    print('  Invoking cascade on config:');
    config?..theme = 'dark'..enableNotifications();

    // 6. Null assertion (!)
    if (name != null) {
      String upper = name.toUpperCase(); // Promoted automatically, but `name!` is also valid
      print('  Upper: $upper');
    }
  }

  print('Calling with null values:');
  analyzeUser(null, null, null);

  print('\nCalling with populated values:');
  ProfileConfig myConfig = ProfileConfig();
  analyzeUser('Alice', {'role': 'Administrator'}, myConfig);
  print('');
}

// ============================================================================
// 3. The `late` Keyword (Lazy Initialization & Late Final)
// ============================================================================
/// EXPLANATION:
/// The `late` modifier is used for non-nullable variables that are initialized AFTER
/// their declaration, or for LAZY initialization.
///
/// TWO PRIMARY USE CASES:
/// 1. Deferred Initialization: When a non-nullable variable cannot be assigned immediately
///    at declaration (e.g. initialized in `initState()`, `setup()`, or constructor body).
/// 2. Lazy Computation: A top-level or instance variable marked `late` will NOT be computed
///    until it is accessed for the very first time.
///
/// IMPORTANT WARNING:
/// If you read a `late` variable before it is initialized, Dart throws a `LateInitializationError`
/// at runtime!
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Kotlin: Kotlin `lateinit var` (only works on mutable non-primitive types) and `by lazy { ... }`.
///   Dart `late` works uniformly on any type, including primitives, final variables, and top-level variables.
/// - vs Swift: Swift `lazy var`.
/// - vs C#: C# `Lazy<T>`.
class DatabaseService {
  // Lazy evaluation: this expensive computation only runs when `connectionString` is read!
  late final String connectionString = _computeExpensiveConnection();

  // Deferred initialization
  late String activeSessionId;

  String _computeExpensiveConnection() {
    print('    [Lazy Evaluator] Computing database connection string...');
    return 'postgres://admin:secret@localhost:5432/production_db';
  }
}

void demonstrateLateKeyword() {
  print('--- 3. The late Keyword (Lazy Initialization) ---');

  DatabaseService db = DatabaseService();
  print('DatabaseService instance created (connectionString NOT computed yet).');

  // Reading connectionString triggers lazy initialization:
  print('First access to connectionString: ${db.connectionString}');
  print('Second access to connectionString (cached): ${db.connectionString}');

  // Initializing deferred late variable
  db.activeSessionId = 'SESSION_XYZ_987';
  print('Active session ID: ${db.activeSessionId}');
  print('');
}

// ============================================================================
// 4. Flow Analysis, Smart Casting & Type Promotion
// ============================================================================
/// EXPLANATION:
/// Dart's analyzer uses static flow analysis to understand code execution paths.
/// When the compiler detects a check that guarantees a variable is not null or is of a specific type,
/// it PROMOTES the variable to the more specific non-nullable type for the rest of that scope.
///
/// KEY RULES OF TYPE PROMOTION:
/// 1. `if (x != null)` promotes `x` from `T?` to `T`.
/// 2. `if (x == null) return;` promotes `x` to `T` in code following the `if`.
/// 3. `if (x is String)` promotes `x` to `String`.
/// 4. Reassignment with an untyped or nullable value will demote the variable back.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Kotlin: Kotlin Smart Casts (`if (x != null) x.length`).
/// - vs TypeScript: TS Control Flow Analysis type narrowing.
/// - vs Java: Java 16+ Pattern Matching for `instanceof` (`if (obj instanceof String s)`).
void demonstrateFlowAnalysisAndTypePromotion() {
  print('--- 4. Flow Analysis & Type Promotion ---');

  void processNullableString(String? input) {
    // Before check: `input` is String?
    // input.length; // COMPILE ERROR!

    if (input == null) {
      print('  Input is null, aborting.');
      return;
    }

    // Flow analysis knows execution only reaches here if input is NOT null!
    // `input` is automatically promoted to `String` (non-nullable):
    print('  Promoted non-null string length: ${input.length}, upper: ${input.toUpperCase()}');
  }

  processNullableString(null);
  processNullableString('Dart Flow Analysis is awesome');
  print('');
}

// ============================================================================
// 5. Property Promotion Gotchas & Local Variable Shadowing Pattern
// ============================================================================
/// EXPLANATION:
/// A common confusion in Dart: Why does `if (this.field != null)` sometimes NOT promote
/// `field` to non-nullable?
///
/// THE REASON:
/// In Dart, class fields can be overridden by subclasses with custom getters!
/// A custom getter could return `null` on one invocation and a `String` on the next invocation.
/// Therefore, the compiler cannot soundly guarantee that `this.field` remains non-null
/// across multiple reads.
///
/// THE SOLUTION (Best Practice):
/// Shadow the property into a local variable:
/// `final val = this.field; if (val != null) { ... }`
class Product {
  final String? description;
  Product(this.description);

  void display() {
    // Local variable shadowing pattern:
    final desc = description;
    if (desc != null) {
      // `desc` is a local variable, so flow analysis CAN safely promote it!
      print('  Product Description: ${desc.toUpperCase()} (length: ${desc.length})');
    } else {
      print('  Product has no description.');
    }
  }
}

void demonstratePropertyPromotionPattern() {
  print('--- 5. Property Promotion & Local Variable Shadowing ---');

  Product itemWithDesc = Product('Premium Wireless Headphones');
  Product itemWithoutDesc = Product(null);

  itemWithDesc.display();
  itemWithoutDesc.display();
  print('');
}

// ============================================================================
// 6. Generics & Null Safety
// ============================================================================
/// EXPLANATION:
/// How null safety interacts with Generic Type Parameters:
/// 1. Unbounded Generic: `class Box<T>` -> `T` can be nullable OR non-nullable (`T` extends `Object?`).
/// 2. Explicitly Non-Nullable Generic: `class NonNullBox<T extends Object>` -> `T` MUST be non-nullable!
///    `NonNullBox<int>` is valid, but `NonNullBox<int?>` produces a COMPILE ERROR.
/// 3. Generic with nullable field: `T? value;` (can hold null regardless of what `T` is).
class NonNullContainer<T extends Object> {
  final T value;
  NonNullContainer(this.value);

  void printValue() => print('  NonNullContainer holding: $value');
}

class OptionalContainer<T> {
  final T? value;
  OptionalContainer([this.value]);

  bool get hasValue => value != null;
}

void demonstrateGenericsAndNullSafety() {
  print('--- 6. Generics & Null Safety ---');

  NonNullContainer<String> safeStringContainer = NonNullContainer('Guaranteed non-null');
  safeStringContainer.printValue();

  // NonNullContainer<String?> invalid = NonNullContainer(null); // COMPILE ERROR!

  OptionalContainer<int> maybeInt = OptionalContainer(null);
  OptionalContainer<int> hasInt = OptionalContainer(42);

  print('maybeInt.hasValue: ${maybeInt.hasValue}');
  print('hasInt.hasValue: ${hasInt.hasValue}, value: ${hasInt.value}');
  print('');
}

// ============================================================================
// 7. The `Never` Type (Bottom Type)
// ============================================================================
/// EXPLANATION:
/// `Never` is the bottom type of the Dart type system (it has NO values).
/// A function with return type `Never` is guaranteed to NEVER return normally
/// (it always throws an exception or enters an infinite loop).
///
/// KEY & IMPORTANT POINTS:
/// 1. Helps the flow analyzer prune dead code branches.
/// 2. Code after a call to a `Never` function is recognized as unreachable.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs TypeScript: TypeScript `never`.
/// - vs Kotlin: Kotlin `Nothing`.
/// - vs Rust: Rust `!` (never type / diverging function).
/// - vs Swift: Swift `Never`.
Never fail(String message) {
  throw StateError('Fatal Exception: $message');
}

void demonstrateNeverType() {
  print('--- 7. The Never Type (Bottom Type) ---');

  String validateToken(String? inputToken) {
    // If inputToken is null, fail() will throw and never return.
    // Therefore, inputToken is soundly promoted to non-nullable String!
    return inputToken ?? fail('Missing security token');
  }

  String verifiedToken = validateToken('valid_token_abc');
  print('Verified token: $verifiedToken');
  print('');
}

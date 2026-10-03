/// ============================================================================
/// OBJECT-ORIENTED PROGRAMMING (OOP) IN DART: MASTERCLASS REFERENCE
/// ============================================================================
/// This file covers:
///  1. Classes, Objects & Library-Level Privacy (`_`)
///  2. All Constructor Types (Generative, Named, Initializer Lists, Redirecting, Const, Factory)
///  3. Getters and Setters
///  4. Inheritance & Polymorphism (`extends`, `super`, `@override`)
///  5. Abstract Classes & Dart's Implicit Interface System (`implements`)
///  6. Mixins (`mixin`, `with`, `on`)
///  7. Extension Methods (`extension on Type`)
///  8. Modern Dart 3 Class Modifiers (`sealed`, `base`, `interface`, `final`, `mixin class`)
///
/// For each topic:
///  - Working runnable examples
///  - Architectural explanations & mental models
///  - Cross-language comparisons (Java, C++, Python, Kotlin, Swift, C#, TypeScript)
/// ============================================================================

void main() {
  print('===============================================================');
  print('               OOP IN DART: MASTERCLASS REFERENCE              ');
  print('===============================================================\n');

  demonstrateClassesAndPrivacy();
  demonstrateAllConstructors();
  demonstrateGettersAndSetters();
  demonstrateInheritanceAndPolymorphism();
  demonstrateAbstractAndImplicitInterfaces();
  demonstrateMixins();
  demonstrateExtensionMethods();
  demonstrateDart3ClassModifiers();

  print('\n===============================================================');
  print('               OOP DEMONSTRATIONS COMPLETED SUCCESSFULLY       ');
  print('===============================================================');
}

// ============================================================================
// 1. Classes, Objects & Library-Level Privacy (_)
// ============================================================================
/// EXPLANATION:
/// Dart is a pure object-oriented language where everything is an object (an instance of a class).
///
/// KEY & IMPORTANT POINTS:
/// 1. Privacy is LIBRARY-LEVEL, not class-level:
///    - Prefixing an identifier with an underscore `_name` makes it PRIVATE to its library (file).
///    - Dart does NOT have `public`, `private`, or `protected` keywords!
///    - Any code inside the same file can access `_privateField`; code outside this file CANNOT.
/// 2. All methods are virtual by default (can be overridden unless the class or method is final).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java/C++/C#: Java has `public`, `protected`, `private`, package-private.
///   Dart simplifies this completely: identifiers without `_` are public; identifiers with `_` are library-private.
/// - vs Python: Python uses `_` or `__` as naming conventions (name mangling). Dart enforces `_` privacy at compile-time.
class BankAccount {
  final String accountHolder;
  double _balance; // Library-private field

  BankAccount(this.accountHolder, double initialBalance) : _balance = initialBalance;

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print('  Deposited \$${amount.toStringAsFixed(2)}. New balance: \$$_balance');
    }
  }

  double get balance => _balance;
}

void demonstrateClassesAndPrivacy() {
  print('--- 1. Classes & Library-Level Privacy (_) ---');

  BankAccount account = BankAccount('Alice Smith', 1000.0);
  print('Account Holder: ${account.accountHolder}');
  print('Initial Balance: \$${account.balance}');
  account.deposit(250.0);
  print('');
}

// ============================================================================
// 2. All Constructor Types
// ============================================================================
/// EXPLANATION:
/// Dart provides a rich variety of constructor types:
/// 1. Generative Constructor: `Point(this.x, this.y);` (syntactic sugar assigning parameters directly to fields).
/// 2. Named Constructor: `Point.origin()` or `Point.fromJson(json)` (clarifies different construction paths).
/// 3. Initializer List: `: field = expr, assert(...)` (runs BEFORE the constructor body executes).
/// 4. Redirecting Constructor: `Point.alongX(double x) : this(x, 0);` (delegates to another constructor).
/// 5. Constant Constructor: `const Point(this.x, this.y);` (creates compile-time immutable canonical instances).
/// 6. Factory Constructor: `factory ClassName()` (can return cached instances, subtypes, or singletons; does not always create a new instance).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java/C++: Java only has constructor overloading by signature.
///   Dart named constructors (`Class.named()`) eliminate ambiguous constructor overloads and make APIs clear.
/// - vs Python: Python uses `__init__` and class methods `@classmethod def from_json(cls):`.
/// - vs Kotlin/Swift: Kotlin has primary and secondary constructors. Dart's named and factory constructors are cleaner.
class Point {
  final double x;
  final double y;

  // 1. Generative Constructor
  const Point(this.x, this.y);

  // 2. Named Constructor
  Point.origin()
      : x = 0.0,
        y = 0.0;

  // 3. Initializer List with validation assert
  Point.fromCoordinates({required double xCoord, required double yCoord})
      : x = xCoord,
        y = yCoord {
    // Body runs AFTER initializer list
  }

  // 4. Redirecting Constructor
  Point.alongXAxis(double xCoord) : this(xCoord, 0.0);

  @override
  String toString() => 'Point($x, $y)';
}

// 6. Factory Constructor (Singleton Pattern)
class ApiClient {
  final String baseUrl;
  static final Map<String, ApiClient> _cache = {};

  // Private generative constructor
  ApiClient._internal(this.baseUrl);

  // Factory constructor returning cached singleton per baseUrl
  factory ApiClient(String baseUrl) {
    return _cache.putIfAbsent(baseUrl, () => ApiClient._internal(baseUrl));
  }
}

void demonstrateAllConstructors() {
  print('--- 2. All Constructor Types ---');

  // Const constructor instances (identical in memory)
  const p1 = Point(10, 20);
  const p2 = Point(10, 20);
  print('p1: $p1, p2: $p2');
  print('identical(p1, p2): ${identical(p1, p2)} (Canonicalized in memory)');

  // Named constructors
  Point origin = Point.origin();
  Point xOnly = Point.alongXAxis(45.0);
  print('origin: $origin');
  print('xOnly (redirected): $xOnly');

  // Factory Singleton Cache check
  ApiClient client1 = ApiClient('https://api.myapp.com');
  ApiClient client2 = ApiClient('https://api.myapp.com');
  print('identical(client1, client2): ${identical(client1, client2)} (Factory cached same instance!)');
  print('');
}

// ============================================================================
// 3. Getters and Setters
// ============================================================================
/// EXPLANATION:
/// Getters and Setters provide custom read and write access to object properties.
///
/// KEY & IMPORTANT POINTS:
/// 1. In Dart, fields and getters/setters have IDENTICAL call syntax: `obj.property`.
/// 2. Uniform Access Principle: You can start with a public field `double radius;` and later
///    refactor it into a getter/setter WITHOUT breaking any calling code!
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java: Java requires explicit `getRadius()` and `setRadius(r)` method boilerplate.
/// - vs TypeScript/C#: TypeScript uses `get name()` / `set name()`; C# uses property syntax `{ get; set; }`.
class Rectangle {
  double width;
  double height;

  Rectangle(this.width, this.height);

  // Computed Getter (Area)
  double get area => width * height;

  // Computed Getter & Setter (Perimeter)
  double get perimeter => 2 * (width + height);

  set perimeter(double newPerimeter) {
    if (newPerimeter <= 0) {
      throw ArgumentError('Perimeter must be positive');
    }
    // Scale dimensions proportionally
    double scale = newPerimeter / perimeter;
    width *= scale;
    height *= scale;
  }
}

void demonstrateGettersAndSetters() {
  print('--- 3. Getters and Setters ---');

  Rectangle rect = Rectangle(10, 5);
  print('Width: ${rect.width}, Height: ${rect.height}');
  print('Computed Area: ${rect.area}');
  print('Computed Perimeter: ${rect.perimeter}');

  rect.perimeter = 60; // Triggers custom setter
  print('After setter perimeter = 60: Width=${rect.width.toStringAsFixed(1)}, Height=${rect.height.toStringAsFixed(1)}');
  print('');
}

// ============================================================================
// 4. Inheritance & Polymorphism (extends, super, @override)
// ============================================================================
/// EXPLANATION:
/// Dart supports single-class inheritance using `extends`.
/// A subclass inherits all non-private instance variables and methods from its superclass.
///
/// KEY & IMPORTANT POINTS:
/// 1. `@override`: Annotation indicating a method overrides a superclass method.
/// 2. `super`: Calls the superclass constructor or superclass methods (`super.makeSound()`).
/// 3. Polymorphism: A superclass reference can point to any subclass instance at runtime.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs C++: C++ allows multiple inheritance. Dart only allows single class inheritance (use Mixins for multi-class behavior).
/// - vs Java: Identical inheritance mechanics (`extends`, `super`, `@Override`).
class Animal {
  final String name;
  Animal(this.name);

  void makeSound() => print('  $name makes a generic animal sound.');
}

class Dog extends Animal {
  final String breed;

  // Passing parameter up to super constructor
  Dog(String name, this.breed) : super(name);

  @override
  void makeSound() {
    super.makeSound(); // Calling parent method
    print('  $name (a $breed) barks: Woof! Woof!');
  }
}

void demonstrateInheritanceAndPolymorphism() {
  print('--- 4. Inheritance & Polymorphism ---');

  Animal genericAnimal = Animal('Creature');
  Dog buddy = Dog('Buddy', 'Golden Retriever');

  // Polymorphic list
  List<Animal> animals = [genericAnimal, buddy];
  for (var a in animals) {
    a.makeSound();
  }
  print('');
}

// ============================================================================
// 5. Abstract Classes & Dart's Implicit Interface System (implements)
// ============================================================================
/// EXPLANATION:
/// 1. `abstract class`: Cannot be instantiated directly; defines method signatures for subclasses.
/// 2. DART'S IMPLICIT INTERFACE SYSTEM:
///    - In Dart, EVERY CLASS implicitly defines an interface containing all its instance members!
///    - Dart does NOT have an `interface` keyword for declarations (Dart 3 has `interface class` modifier).
///    - You can `implements` ANY class! When implementing, you must provide your own implementation
///      for ALL fields, getters, and methods of the interface.
///
/// `extends` vs `implements`:
/// - `extends`: Inherits code/implementation from exactly ONE superclass.
/// - `implements`: Inherits only the API contract from ONE or MORE classes (must implement everything).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java/C#: In Java/C#, you must explicitly write `interface Vehicle { ... }`.
///   In Dart, any class can serve as an interface automatically!
abstract class PaymentProcessor {
  void processPayment(double amount);
  String get processorName;
}

class StripeService {
  void logTransaction(String id) => print('  [Stripe Log] Transaction: $id');
}

// Implements abstract class + implements regular class (Implicit Interface)
class CustomPaymentGateway implements PaymentProcessor, StripeService {
  @override
  String get processorName => 'Custom Gateway v2';

  @override
  void processPayment(double amount) {
    print('  Processing \$$amount via $processorName');
    logTransaction('TXN_998877');
  }

  @override
  void logTransaction(String id) {
    print('  Custom implementation of logTransaction: $id');
  }
}

void demonstrateAbstractAndImplicitInterfaces() {
  print('--- 5. Abstract Classes & Implicit Interfaces ---');

  PaymentProcessor gateway = CustomPaymentGateway();
  print('Gateway: ${gateway.processorName}');
  gateway.processPayment(75.50);
  print('');
}

// ============================================================================
// 6. Mixins (mixin, with, on)
// ============================================================================
/// EXPLANATION:
/// Mixins are a way of reusing a class's code in multiple class hierarchies.
/// They solve the "Diamond Problem" of multiple inheritance through linear composition.
///
/// KEY & IMPORTANT POINTS:
/// 1. Defined using `mixin Name { ... }`.
/// 2. Applied using `with Name1, Name2`.
/// 3. Constraint `on SuperClass`: Specifies that this mixin can ONLY be applied to subclasses of `SuperClass`.
/// 4. Mixins cannot declare generative constructors (they do not manage independent instantiation).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs C++: C++ uses multiple inheritance (complex virtual tables and diamond problem).
///   Dart mixins are strictly linear and safe.
/// - vs Rust: Rust `traits` with default method implementations.
/// - vs Kotlin/Java: Java 8+ interfaces with `default` methods.
/// - vs Python: Python uses multiple inheritance with Method Resolution Order (MRO).
mixin Flyable {
  void fly() => print('  Flying high into the sky!');
}

mixin Swimmable {
  void swim() => print('  Swimming smoothly underwater!');
}

class Duck extends Animal with Flyable, Swimmable {
  Duck(String name) : super(name);
}

void demonstrateMixins() {
  print('--- 6. Mixins (mixin, with) ---');

  Duck donald = Duck('Donald');
  donald.makeSound();
  donald.fly();
  donald.swim();
  print('');
}

// ============================================================================
// 7. Extension Methods (extension on Type)
// ============================================================================
/// EXPLANATION:
/// Extension methods allow you to add new methods, getters, and operators to EXISTING classes
/// (including SDK classes like `String`, `int`, `List`) WITHOUT modifying the source code or subclassing.
///
/// KEY & IMPORTANT POINTS:
/// 1. Syntax: `extension Name on TargetType { ... }`.
/// 2. Static Resolution: Extension methods are resolved statically at compile-time (zero runtime overhead).
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Kotlin: Kotlin Extension Functions (`fun String.capitalizeWords(): String`).
/// - vs C#: C# Extension Methods (`public static string CapitalizeWords(this string str)`).
/// - vs Swift: Swift Extensions (`extension String { ... }`).
/// - vs JavaScript: JS monkey-patching `String.prototype.custom = ...` (dangerous runtime mutation).
///   Dart extensions are statically type-safe and do not pollute global prototypes.
extension StringFormatting on String {
  String get capitalizeFirst {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool get isValidEmail => contains('@') && contains('.');
}

void demonstrateExtensionMethods() {
  print('--- 7. Extension Methods ---');

  String word = 'flutter';
  String email = 'user@example.com';
  String badEmail = 'invalid_email';

  print('word.capitalizeFirst: ${word.capitalizeFirst}');
  print('email.isValidEmail: ${email.isValidEmail}');
  print('badEmail.isValidEmail: ${badEmail.isValidEmail}');
  print('');
}

// ============================================================================
// 8. Modern Dart 3 Class Modifiers (sealed, base, interface, final)
// ============================================================================
/// EXPLANATION:
/// Dart 3 introduced powerful class modifiers to control how classes can be inherited or implemented:
/// 1. `sealed`: Cannot be extended or implemented outside this library. Enables 100% EXHAUSTIVE pattern matching in switch!
/// 2. `base`: Enforces inheritance (`extends`); forbids `implements` from other libraries to preserve base class contracts.
/// 3. `interface`: Enforces contract (`implements`); forbids `extends` from other libraries.
/// 4. `final`: Forbids BOTH `extends` and `implements` outside this library (closed hierarchy).
/// 5. `mixin class`: Can be used as BOTH a regular class and a mixin.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Kotlin: Kotlin `sealed class`, `final class`.
/// - vs Java: Java 17+ `sealed class ... permits SubA, SubB`.
/// - vs Rust: Rust `enum` with algebraic data types.
sealed class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String userId;
  AuthSuccess(this.userId);
}
class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}

void demonstrateDart3ClassModifiers() {
  print('--- 8. Modern Dart 3 Class Modifiers & Sealed Classes ---');

  AuthState state = AuthSuccess('USER_12345');

  // Exhaustive switch expression on sealed class (compiler guarantees all subtypes are handled!)
  String statusMessage = switch (state) {
    AuthInitial() => 'Initial State: Awaiting action',
    AuthLoading() => 'Loading: Authenticating...',
    AuthSuccess(:final userId) => 'Success! Logged in as User ID: $userId',
    AuthFailure(:final errorMessage) => 'Failed: $errorMessage',
  };

  print('Auth Status (via Sealed Class Exhaustive Switch): $statusMessage');
  print('');
}

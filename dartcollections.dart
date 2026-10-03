/// ============================================================================
/// DART COLLECTIONS: COMPREHENSIVE GUIDE & REFERENCE
/// ============================================================================
/// This file covers:
///  1. List (Growable, Fixed-length, List.generate, List.filled, List.unmodifiable)
///  2. Set (Uniqueness, Set operations: union, intersection, difference, HashSet)
///  3. Map (Key-value pairs, HashMap, SplayTreeMap, entries, putIfAbsent, update)
///  4. Queue & Iterables (dart:collection, lazy evaluation, sync* generators)
///  5. Collection Operators (Spread `...`, Null-aware spread `...?`, Collection `if`, Collection `for`)
///  6. Unmodifiable / Immutable Collections
///  7. Generics & Type Safety in Collections
///
/// For each topic:
///  - Working runnable examples
///  - In-depth explanations
///  - Important Points & Under-the-hood details
///  - Cross-language comparisons (Java, JavaScript/TypeScript, Python, C++, Kotlin, Swift)
/// ============================================================================

import 'dart:collection';

void main() {
  print('===============================================================');
  print('             DART COLLECTIONS: MASTERCLASS REFERENCE           ');
  print('===============================================================\n');

  demonstrateList();
  demonstrateSet();
  demonstrateMap();
  demonstrateQueueAndIterable();
  demonstrateCollectionOperators();
  demonstrateUnmodifiableCollections();
  demonstrateGenericsInCollections();

  print('\n===============================================================');
  print('             DART COLLECTIONS COMPLETED SUCCESSFULLY           ');
  print('===============================================================');
}

// ============================================================================
// 1. List
// ============================================================================
/// EXPLANATION:
/// `List<E>` is an ordered collection of elements with zero-based indexing.
/// In Dart, arrays are simply `List` objects.
///
/// KEY & IMPORTANT POINTS:
/// 1. Growable vs Fixed-Length:
///    - `[1, 2, 3]` is growable by default (`growable: true`).
///    - `List.filled(5, 0, growable: false)` has fixed length; calling `.add()` throws `UnsupportedError`.
/// 2. Constructors:
///    - `List.generate(5, (i) => i * 2)`: Generates elements with a computation function.
///    - `List.filled(length, fillValue)`: Creates list of given length with identical fill value.
///    - `List.from(elements)` / `List.of(elements)`: Creates new list from existing iterable.
/// 3. Essential Methods:
///    - Mutation: `.add()`, `.addAll()`, `.insert()`, `.remove()`, `.removeAt()`, `.removeWhere()`, `.clear()`.
///    - Querying: `.contains()`, `.indexOf()`, `.any()`, `.every()`, `.first`, `.last`, `.isEmpty`.
///    - Slicing & Sorting: `.sublist(start, end)`, `.sort((a, b) => a.compareTo(b))`, `.reversed`.
/// 4. Performance:
///    - Random access `list[i]` is O(1).
///    - Adding to the end `.add()` is amortized O(1).
///    - Inserting at arbitrary index `.insert(0, item)` is O(n).
void demonstrateList() {
  print('--- 1. List (Ordered, Indexed Collection) ---');

  // Growable List literal
  List<String> fruits = ['Apple', 'Banana', 'Cherry'];
  fruits.add('Date');
  fruits.addAll(['Elderberry', 'Fig']);
  fruits.insert(1, 'Blueberry'); // Insert at index 1

  print('Fruits list: $fruits');
  print('First: ${fruits.first}, Last: ${fruits.last}, Length: ${fruits.length}');
  print('Element at index 2: ${fruits[2]}');

  // Fixed-length list
  List<int> fixedList = List.filled(4, 0, growable: false);
  fixedList[0] = 10;
  fixedList[1] = 20;
  // fixedList.add(50); // Throws UnsupportedError at runtime!
  print('Fixed-length list: $fixedList');

  // List.generate
  List<int> squares = List.generate(5, (index) => (index + 1) * (index + 1));
  print('Generated squares: $squares');

  // Searching and Filtering
  print('Contains "Banana": ${fruits.contains("Banana")}');
  print('Index of "Cherry": ${fruits.indexOf("Cherry")}');

  // Sorting
  List<int> scores = [88, 42, 95, 70, 100];
  scores.sort(); // Natural ascending order
  print('Sorted scores: $scores');
  scores.sort((a, b) => b.compareTo(a)); // Custom descending order
  print('Descending sorted scores: $scores');

  // Sublist
  List<int> topThree = scores.sublist(0, 3);
  print('Top 3 scores: $topThree');
  print('');
}

// ============================================================================
// 2. Set
// ============================================================================
/// EXPLANATION:
/// `Set<E>` is an unordered collection of UNIQUE elements.
/// Duplicate items are automatically ignored.
///
/// KEY & IMPORTANT POINTS:
/// 1. Uniqueness is determined using `hashCode` and `operator ==` of the stored objects.
/// 2. Default implementation is `LinkedHashSet`, which preserves insertion order during iteration.
/// 3. `HashSet` (from `dart:collection`) offers higher performance when insertion order doesn't matter.
/// 4. Mathematical Set Operations:
///    - `union(otherSet)`: Elements in either set (A ∪ B).
///    - `intersection(otherSet)`: Elements in both sets (A ∩ B).
///    - `difference(otherSet)`: Elements in first set but not the second (A \ B).
/// 5. Lookup, insertion, and deletion are average O(1) time complexity.
void demonstrateSet() {
  print('--- 2. Set (Unique, Unordered Collection) ---');

  // Creating Set from list with duplicate rejection
  Set<String> tags = Set.from(['dart', 'flutter', 'web', 'dart', 'mobile']);
  print('Tags (duplicates automatically removed): $tags');

  tags.add('backend');
  tags.remove('web');
  print('Tags after add/remove: $tags');
  print('Contains "flutter": ${tags.contains("flutter")}');

  // Mathematical Set Operations
  Set<int> setA = {1, 2, 3, 4, 5};
  Set<int> setB = {4, 5, 6, 7, 8};

  Set<int> unionSet = setA.union(setB); // {1, 2, 3, 4, 5, 6, 7, 8}
  Set<int> intersectionSet = setA.intersection(setB); // {4, 5}
  Set<int> differenceSet = setA.difference(setB); // {1, 2, 3}

  print('Set A: $setA');
  print('Set B: $setB');
  print('Union (A ∪ B): $unionSet');
  print('Intersection (A ∩ B): $intersectionSet');
  print('Difference (A \\ B): $differenceSet');

  // Converting List to Set to remove duplicates
  List<int> rawListWithDups = [1, 2, 2, 3, 4, 4, 4, 5];
  List<int> distinctList = rawListWithDups.toSet().toList();
  print('Deduplicated list via .toSet().toList(): $distinctList');
  print('');
}

// ============================================================================
// 3. Map
// ============================================================================
/// EXPLANATION:
/// `Map<K, V>` is a collection of key-value pairs where each key is UNIQUE and maps to exactly one value.
///
/// KEY & IMPORTANT POINTS:
/// 1. Default implementation is `LinkedHashMap`, preserving insertion order.
/// 2. `HashMap` (unordered, fast) and `SplayTreeMap` (sorted by keys, O(log n)) are available in `dart:collection`.
/// 3. Accessing missing keys returns `null` (does NOT throw an exception):
///    `map['missing_key'] == null`.
/// 4. Useful methods:
///    - `.putIfAbsent(key, () => computeValue())`: Computes and inserts value only if key is not already present.
///    - `.update(key, (val) => newVal, ifAbsent: () => defaultVal)`: Safely mutates existing entry.
///    - `.containsKey(key)`, `.containsValue(value)`.
///    - `.entries`: Returns `Iterable<MapEntry<K, V>>` for clean iteration.
///    - `.map((k, v) => MapEntry(...))`: Transforms both keys and values.
void demonstrateMap() {
  print('--- 3. Map (Key-Value Pairs / Dictionaries) ---');

  // Map literal
  Map<String, int> countryCodes = {
    'US': 1,
    'UK': 44,
    'IN': 91,
    'JP': 81,
  };

  print('Country codes: $countryCodes');
  print('US Code: ${countryCodes['US']}');
  print('Missing key ("DE"): ${countryCodes['DE']} (returns null)');

  // Adding and updating
  countryCodes['DE'] = 49; // Add new key
  countryCodes['US'] = 101; // Overwrite existing

  // putIfAbsent: Only computes and inserts if key is absent
  countryCodes.putIfAbsent('FR', () => 33);
  countryCodes.putIfAbsent('IN', () => 999); // 'IN' already exists, 999 is ignored

  // update method
  countryCodes.update('UK', (current) => current + 100);

  print('Updated country codes: $countryCodes');
  print('Keys: ${countryCodes.keys}');
  print('Values: ${countryCodes.values}');

  // Iterating entries
  print('Iterating map entries:');
  for (final MapEntry(:key, :value) in countryCodes.entries) {
    print('  Country: $key -> Code: +$value');
  }

  // Sorted Map: SplayTreeMap (keys automatically sorted)
  SplayTreeMap<String, int> sortedMap = SplayTreeMap.from({
    'Zebra': 26,
    'Apple': 1,
    'Mango': 13,
  });
  print('SplayTreeMap (alphabetically sorted keys): $sortedMap');
  print('');
}

// ============================================================================
// 4. Queue & Iterables (dart:collection & Lazy Sequences)
// ============================================================================
/// EXPLANATION:
/// - `Queue<E>`: A double-ended queue (FIFO queue or LIFO stack) with O(1) additions/removals at both ends.
/// - `Iterable<E>`: The abstract base interface for all collections that can be stepped through sequentially.
///   Iterable methods (`where`, `map`, `take`, `skip`) are LAZILY evaluated!
///
/// KEY & IMPORTANT POINTS:
/// 1. `Queue` is ideal for Breadth-First Search (BFS), task schedulers, and sliding windows.
/// 2. Lazy Evaluation: `iterable.map(...)` does NOT compute immediately; computation happens
///    only when elements are consumed (e.g. via `.toList()`, `.first`, or `for-in`).
/// 3. Synchronous Generators (`sync*` & `yield`): Produce custom `Iterable` streams on demand.
void demonstrateQueueAndIterable() {
  print('--- 4. Queue & Iterable (Lazy Sequences & Queues) ---');

  // Queue (Double-ended FIFO / LIFO)
  Queue<String> taskQueue = Queue<String>();
  taskQueue.addLast('Task 1: Download data');
  taskQueue.addLast('Task 2: Process images');
  taskQueue.addFirst('Task 0: Authenticate (Priority)');

  print('Initial Queue: $taskQueue');
  String completedFirst = taskQueue.removeFirst();
  print('Processed first: $completedFirst');
  print('Remaining Queue: $taskQueue');

  // Lazy Evaluation Demonstration:
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  print('Demonstrating Lazy evaluation:');

  Iterable<int> lazyPipeline = numbers.where((n) {
    print('  [lazy where] filtering $n');
    return n.isEven;
  }).map((n) {
    print('  [lazy map] squaring $n');
    return n * n;
  });

  print('Pipeline defined (nothing computed yet!). Now requesting first 2 elements:');
  List<int> firstTwoEvenSquares = lazyPipeline.take(2).toList();
  print('Result: $firstTwoEvenSquares');

  // sync* generator function
  Iterable<int> countUpTo(int max) sync* {
    for (int i = 1; i <= max; i++) {
      yield i;
    }
  }

  print('sync* generator output: ${countUpTo(4).toList()}');
  print('');
}

// ============================================================================
// 5. Collection Operators (Spread, Collection-if, Collection-for)
// ============================================================================
/// EXPLANATION:
/// Dart provides powerful declarative collection operators:
/// 1. Spread Operator (`...`): Flattens and unpacks elements of one collection into another.
/// 2. Null-aware Spread Operator (`...?`): Safely ignores collection if it is `null`.
/// 3. Collection-if: Conditionally includes elements in list/set/map literals.
/// 4. Collection-for: Iterates and transforms elements inside collection literals.
///
/// KEY & IMPORTANT POINTS:
/// - These operators eliminate imperative boilerplate (such as `list.addAll()`, temporary variables,
///   and manual if-checks before building UI widget trees in Flutter)
void demonstrateCollectionOperators() {
  print('--- 5. Collection Operators (Spread, Collection-if, Collection-for) ---');

  // 1. Spread Operator (...) & Null-aware Spread (...?)
  List<int> mergeLists(List<int> a, List<int> b, List<int>? optional) {
    return [
      0,
      ...a,
      ...b,
      ...?optional, // Will NOT crash if null; safely ignored
      6,
    ];
  }

  print('Merged list with spread operators: ${mergeLists([1, 2, 3], [4, 5], null)}');

  // 2. Collection-if
  List<String> buildMenuItems({required bool isPremium, required bool isDebug}) => [
        'Dashboard',
        'Profile',
        if (isPremium) 'VIP Lounge',
        if (isDebug) 'Developer Tools',
        'Logout',
      ];

  print('Menu items (Collection-if): ${buildMenuItems(isPremium: true, isDebug: false)}');

  // 3. Collection-for
  List<int> baseNumbers = [1, 2, 3, 4];
  List<String> stringifiedLabels = [
    'Header',
    for (var n in baseNumbers) 'Item #$n (${n * 10} pts)',
    'Footer',
  ];
  print('Collection-for labels: $stringifiedLabels');

  // Combining Spread, Collection-for, and Collection-if in a Map:
  Map<String, String> baseHeaders = {'Accept': 'application/json'};
  bool includeAuth = true;

  Map<String, String> requestHeaders = {
    ...baseHeaders,
    if (includeAuth) 'Authorization': 'Bearer sample_token_123',
    for (var i = 1; i <= 2; i++) 'X-Custom-Header-$i': 'Value-$i',
  };
  print('Dynamic request headers map: $requestHeaders');
  print('');
}

// ============================================================================
// 6. Unmodifiable / Immutable Collections
// ============================================================================
/// EXPLANATION:
/// To prevent unintended mutations and protect application state, Dart provides
/// several ways to create immutable / unmodifiable collections.
///
/// THREE TIERS OF IMMUTABILITY:
/// 1. `const [1, 2, 3]`: Compile-time constant, deeply immutable, canonicalized in memory.
/// 2. `List.unmodifiable(iterable)`: Runtime immutable copy.
/// 3. `UnmodifiableListView(list)` (from `dart:collection`): An unmodifiable VIEW wrapping an existing list
///    (reflects underlying changes if the source list changes, but callers cannot mutate via this view).
///
/// KEY & IMPORTANT POINTS:
/// - Any mutating call (`.add()`, `.remove()`, `list[0] = x`) on unmodifiable collection
///   throws an `UnsupportedError` at runtime.
void demonstrateUnmodifiableCollections() {
  print('--- 6. Unmodifiable / Immutable Collections ---');

  // 1. List.unmodifiable (creates an unmodifiable copy)
  List<int> unmodifiableList = List.unmodifiable([10, 20, 30]);
  print('Unmodifiable list: $unmodifiableList');

  try {
    unmodifiableList.add(40);
  } catch (e) {
    print('Caught expected error mutating List.unmodifiable: $e');
  }

  // 2. UnmodifiableListView (view wrapper around mutable source)
  List<String> internalState = ['A', 'B', 'C'];
  UnmodifiableListView<String> publicView = UnmodifiableListView(internalState);

  print('Public view before source mutation: $publicView');
  internalState.add('D'); // Source mutates
  print('Public view after source mutation: $publicView'); // View reflects source change!

  try {
    publicView.remove('A'); // Cannot mutate through the view!
  } catch (e) {
    print('Caught expected error mutating UnmodifiableListView: $e');
  }
  print('');
}

// ============================================================================
// 7. Generics & Type Safety in Collections
// ============================================================================
/// EXPLANATION:
/// Dart collections are reified generics (generic type information is preserved at runtime).
///
/// KEY & IMPORTANT POINTS:
/// 1. Reified Generics: `[1, 2, 3].runtimeType` is `List<int>`. Unlike Java where generics are erased
///    at runtime (type erasure), Dart knows its generic types at runtime!
///    `list is List<int>` returns `true` reliably at runtime.
/// 2. Covariance: `List<Dog>` can be assigned to `List<Animal>`, but adding a `Cat` to it
///    will throw a `TypeError` at runtime to preserve type safety.
/// 3. Generic methods on collections: `.cast<T>()`, `.whereType<T>()`.
///
/// COMPARISON WITH OTHER LANGUAGES:
/// - vs Java: Java uses type erasure (at runtime `List<String>` is just raw `List`).
///   In Dart, generics are reified (`List<String>` stays `List<String>` at runtime).
/// - vs TypeScript: TypeScript types are completely erased at compile-time.
/// - vs C++: C++ templates generate specialized types at compile-time (monomorphization).
/// - vs C#: C# also has reified generics, similar to Dart.
void demonstrateGenericsInCollections() {
  print('--- 7. Generics & Type Safety in Collections ---');

  List<num> numbers = <num>[1, 2.5, 3, 4.75];
  print('numbers list: $numbers (runtimeType: ${numbers.runtimeType})');

  // whereType<T>() filters and casts to specific subtype cleanly
  List<int> integersOnly = numbers.whereType<int>().toList();
  List<double> doublesOnly = numbers.whereType<double>().toList();

  print('Filtered integers (whereType<int>): $integersOnly');
  print('Filtered doubles (whereType<double>): $doublesOnly');

  // Generic Type check at runtime (reified generics in action):
  Object testList = <String>['apple', 'banana'];
  if (testList is List<String>) {
    print('Runtime check: testList is confirmed to be List<String>!');
  }
  print('');
}

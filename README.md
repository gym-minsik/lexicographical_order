# About

A string generator created to make real-time editing of ordered sequences more efficient by facilitating the reordering, sorting, and interleaving of transactions.

# Usage

- **between(String prev, String next)**.    
This function returns a string that is lexicographically between two given strings, `prev` and `next`. The returned string is intended to be used as a sort key for some data.

  ```dart
  final mid = between(prev: 'B', next: 'D');
  assert(
    areEqual(
      [mid, 'D', 'B']..sort(),
      ['B', mid, 'D'],
    ),
  );
  ```

- **generateOrderKeys(int keyCount)**.   
This function generates a series of strings to serve as sorting keys for data.

  ```dart
  final keyCount = 100; 
  final orderKeys = generateOrderKeys(keyCount);
  ```
  Use cases:

  1. When 'between' is unsuitable due to an empty table or collection:

     ```dart
     Future<void> addTodo(CreateTodo command) async {
       final String orderKey = todos.isEmpty 
         ? generateOrderKeys(1).first // <==
         : between(prev: todos.last.orderKey);
       
       final todo = await todoRepository.create(command, orderKey);
       todos.add(todo);
     }
     ```

  2. During migration to an efficient ordered system:

     ```dart
     Future<void> migrateToLexicalOrderSystem(Table table) async {
       final itemCount = table.count();
       final orderKeys = generateOrderKeys(itemCount);
       /* omitted */
     }
     ```

# Caution

It's advised to use only 'between' and 'generateOrderKey' for key generation, as this package is specifically designed for this task. Utilizing arguments from other sources in conjunction with the 'between' function may compromise the ordered state of your data.

# About

This string generator helps with real-time editing of an ordered sequence, making reordering, sorting, and interleaving transactions faster and simpler.


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
`generateOrderKeys` is used to generate a sequence of strings that can be used as sort keys for some data.

  ```dart
  final keyCount = 100; 
  final orderKeys = generateOrderKeys(keyCount);
  ```
  This is useful for the following cases:

  1. `between` cannot be used because the table (collection) is empty.

     ```dart
     Future<void> addTodo(CreateTodo command) async {
       final String orderKey = todos.isEmpty 
         ? generateOrderKeys(1).first // <==
         : between(prev: todos.last.orderKey);
       
       final todo = await todoRepository.create(command, orderKey);
       todos.add(todo);
     }
     ```

  2. when migrating to an efficient ordered system.

     ```dart
     Future<void> migrateToLexicalOrderSystem(Table table) async {
       final itemCount = table.count();
       final orderKeys = generateOrderKeys(itemCount);
       /* omitted */
     }
     ```

# Caution

I recommend using only between and generateOrderKey to generate keys, as this package is designed specifically for that purpose. If you use arguments generated by other sources with the between function, it may disrupt the ordered state of your data.

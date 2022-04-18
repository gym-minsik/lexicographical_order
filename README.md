# About

A string generator that helps to implement  reordering on top of a database 

It makes reordering, sorting, interleaving transactions faster and simpler. 



# Usage

- **Get a string between two strings in the lexicographical(lexical or alphabetical) order.**

  ```dart
  final mid = between(prev: 'B', next: 'D');
  assert(
    areListsEqual(
      [mid, 'D', 'B']..sort(),
      ['B', mid, 'D'],
    ),
  );
  ```

- **Generate order keys**.

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
  
  2. when migrating to an efficient reorderable system.
  
     ```dart
     Future<void> migrateToLexicalOrderSystem(Table table) async {
       final itemCount = table.count();
       final orderKeys = generateOrderKeys(itemCount);
       /* omitted */
     }
     ```





# Caution

### **The `between` function accepts only allowed characters as arguments**

more precisely, the following code is used inside `between`.

```dart
LexOrderValidator().checkBetweenArgs(prev: prev, next: next);
```

The `LexOrderValidator` checks the follwing constraints:

 1.  both `prev` and `next` must be empty or composed of alphabets.

 2.  `next` must not be 'A'

 3.  `prev` and `next` must not be equal to each other.

 4.  if both `prev` and `next` are not empty, `prev` must not succeed `next` in the lexicographical order. for example:

     ```dart
     between(prev: 'C', next: 'B');
     ```


In debug mode, you get an error if you violate the above constraints. but not in release mode. you can check the constraints manually by using `LexOrderValidator`.










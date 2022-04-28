// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lexicographical_order/lexicographical_order.dart';
import 'package:to_string_pretty/to_string_pretty.dart';

main() async {
  final todoService = TodoService();

  await todoService.add(title: 'Create a backend.');
  await todoService.add(title: 'Write an article.');
  await todoService.add(title: 'Intensive Workout.');
  print(toStringPretty(todoService.todos));

  await todoService.completeTodoAndMoveDown(todoService.todos.first);
  print(toStringPretty(todoService.todos));

  await todoService.reorderBetween(
    target: todoService.todos.first,
    prev: todoService.todos.elementAt(1),
    next: todoService.todos.elementAt(2),
  );
  print(toStringPretty(todoService.todos));
}

class TodoService {
  static int _nextId = 1;

  /// The set is sorted by `Todo.orderKey`.
  var _memoryDB = ISet.withConfig(
    <Todo>{},
    ConfigSet(sort: true),
  );

  UnmodifiableSetFromISet get todos => UnmodifiableSetFromISet(_memoryDB);

  Future<Todo> add({
    required String title,
  }) async {
    final id = _nextId;
    _nextId++;
    final orderKey = _memoryDB.isEmpty
        ? generateOrderKeys(1).first
        : between(prev: _memoryDB.last.orderKey);

    final entity =
        Todo(id: id, title: title, orderKey: orderKey, isCompleted: false);

    _memoryDB = _memoryDB.add(entity);
    return entity;
  }

  Future<Todo> reorderBetween({
    required Todo target,
    Todo? prev,
    Todo? next,
  }) async {
    if (prev == null && next == null) {
      throw ArgumentError("the target can't be reordered");
    }
    final newOrderKey = between(
      prev: prev?.orderKey,
      next: next?.orderKey,
    );
    final copied = target.copyWith(orderKey: newOrderKey);
    _memoryDB = _memoryDB.remove(target).add(copied);

    return copied;
  }

  Future<Todo> completeTodoAndMoveDown(Todo target) async {
    final orderKey = _memoryDB.isEmpty
        ? generateOrderKeys(1).first
        : between(prev: _memoryDB.last.orderKey);

    final copied = target.copyWith(orderKey: orderKey, isCompleted: true);
    _memoryDB = _memoryDB.remove(target).add(copied);
    return copied;
  }
}

class Todo with EquatableMixin, Comparable<Todo> {
  final int id;
  final String title;
  final bool isCompleted;
  final String orderKey;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.orderKey,
  });

  @override
  List<Object> get props => [id];

  @override
  int compareTo(Todo other) => orderKey.compareTo(other.orderKey);

  Todo copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    String? orderKey,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      orderKey: orderKey ?? this.orderKey,
    );
  }

  @override
  String toString() {
    final checkbox = isCompleted ? '✅' : '▢';
    return '$checkbox $title';
  }
}

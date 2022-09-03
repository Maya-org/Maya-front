extension ListUtil<E> on List<E> {
  E? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return elementAt(index);
  }

  E? getFirstOrNull(bool Function(E element) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  List<E> filter(bool Function(E) b) {
    return where(b).toList();
  }

  bool any(bool Function(E) b) {
    for (E e in this) {
      if (b(e)) return true;
    }
    return false;
  }

  bool all(bool Function(E) b) {
    for (E e in this) {
      if (!b(e)) return false;
    }
    return true;
  }

  E maxBy(int Function(E) f) {
    E max = elementAt(0);
    for (E e in this) {
      if (f(e) > f(max)) max = e;
    }
    return max;
  }

  E maxByCompare(int Function(E, E) f) {
    E max = elementAt(0);
    for (E e in this) {
      if (f(e, max) > 0) max = e;
    }
    return max;
  }
}

extension ComparableListUtil<E extends Comparable<E>> on List<E> {
  E max() {
    E max = elementAt(0);
    for (E e in this) {
      if (e.compareTo(max) > 0) max = e;
    }
    return max;
  }
}

extension ListNullableUtil<E> on List<E?> {
  List<E> filterNotNull() {
    return whereType<E>().toList();
  }
}

extension MapUtil<K, V> on Map<K, V> {
  V? getOrNull(K key) {
    if (containsKey(key)) {
      return this[key];
    } else {
      return null;
    }
  }

  MapEntry<K, V>? getFirstOrNull(bool Function(MapEntry<K, V> element) test) {
    return entries.toList().getFirstOrNull(test);
  }
}

extension ListFlattenUtil<E> on List<List<E>> {
  List<E> flatten() {
    return expand((e) => e).toList();
  }
}

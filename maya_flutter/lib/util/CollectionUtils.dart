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
    for(E e in this) {
      if(b(e)) return true;
    }
    return false;
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

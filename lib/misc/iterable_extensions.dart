extension IterableExtensions<E> on Iterable<E> {
  Iterable<Iterable<E>> chunked(int chunkSize) sync* {
    if (length <= 0) {
      yield [];
      return;
    }
    int skip = 0;
    while (skip < length) {
      final Iterable<E> chunk = this.skip(skip).take(chunkSize);
      yield chunk.toList(growable: false);
      skip += chunkSize;
      if (chunk.length < chunkSize) return;
    }
  }

  E? firstWhereIf(bool Function(E element) test, {E? fallback}) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return fallback;
  }

  E? lastWhereIf(bool Function(E element) test, {E Function()? orElse}) {
    try {
      return lastWhere(test, orElse: orElse);
    } catch (_) {
      return null;
    }
  }
}

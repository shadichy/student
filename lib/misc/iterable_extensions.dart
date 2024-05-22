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
    for (E element in this) {
      if (test(element)) return element;
    }
    return fallback;
  }
}

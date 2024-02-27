class Interpolator<T> {
  final List<List<T>> input;
  late final List<T> output;
  Interpolator(this.input) {
    output = input.fold(<T>[], (List<T> a, List<T> b) => a + b);
  }
}

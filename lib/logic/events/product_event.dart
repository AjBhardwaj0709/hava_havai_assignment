abstract class ProductEvent {}

class FetchProducts extends ProductEvent {
  final int limit;
  final int skip;
  FetchProducts(this.limit, this.skip);
}

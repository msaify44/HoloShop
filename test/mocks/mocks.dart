import 'package:holo_shop/shared/product/data/datasource/remote/product_remote_datasource.dart';
import 'package:holo_shop/shared/product/domain/repository/product_repository.dart';
import 'package:mockito/annotations.dart';

// Generate mocks for testing
@GenerateMocks([
  ProductRemoteDatasource,
  ProductRepository,
])
void main() {}

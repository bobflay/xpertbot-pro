import 'package:dio/dio.dart';
import '../models/product.dart';

class ApiService {
  late Dio _dio;
  
  // Update this URL in Codespaces to match the forwarded port
  static const String baseUrl = 'http://localhost:8000/api';

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
  }

  // Get all products
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Get single product
  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  // Create product
  Future<Product> createProduct(Product product) async {
    try {
      final response = await _dio.post('/products', data: product.toJson());
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  // Update product
  Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await _dio.put('/products/$id', data: product.toJson());
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete('/products/$id');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
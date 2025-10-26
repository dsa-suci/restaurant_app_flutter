import 'dart:convert';
import 'dart:io'; // Tambahkan ini untuk SocketException & HttpException
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';

class ApiServices {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantListResponse> getRestaurantList() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/list"));

      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Gagal memuat data. Kode: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke internet. Periksa koneksi Anda.',
      );
    } on HttpException {
      throw Exception('Terjadi kesalahan pada server.');
    } on FormatException {
      throw Exception('Data yang diterima tidak valid.');
    } catch (_) {
      throw Exception('Terjadi kesalahan yang tidak diketahui.');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Gagal memuat detail restoran. Kode: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke internet. Periksa koneksi Anda.',
      );
    } on HttpException {
      throw Exception('Terjadi kesalahan pada server.');
    } on FormatException {
      throw Exception('Data yang diterima tidak valid.');
    } catch (_) {
      throw Exception('Terjadi kesalahan yang tidak diketahui.');
    }
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List restaurants = jsonData['restaurants'];
        return restaurants.map((r) => Restaurant.fromJson(r)).toList();
      } else {
        throw Exception('Gagal memuat hasil pencarian.');
      }
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke internet. Periksa koneksi Anda.',
      );
    } on HttpException {
      throw Exception('Terjadi kesalahan pada server.');
    } on FormatException {
      throw Exception('Data yang diterima tidak valid.');
    } catch (_) {
      throw Exception('Terjadi kesalahan yang tidak diketahui.');
    }
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import './helpers/test_helper.mocks.dart';

void main() {
  late MockApiServices mockApiServices;
  late RestaurantListProvider provider;

  setUp(() {
    mockApiServices = MockApiServices();
    provider = RestaurantListProvider(mockApiServices);
  });

  test('1️⃣ State awal provider harus None', () {
    expect(provider.resultState, isA<RestaurantListNoneState>());
  });

  test('2️⃣ Mengembalikan daftar restoran ketika sukses', () async {
    final mockResponse = {
      "error": false,
      "message": "success",
      "count": 1,
      "restaurants": [
        {
          "id": "1",
          "name": "Restaurant A",
          "description": "desc",
          "city": "Jakarta",
          "rating": 4.5,
          "pictureId": "pic1",
        },
      ],
    };

    when(
      mockApiServices.getRestaurantList(),
    ).thenAnswer((_) async => RestaurantListResponse.fromJson(mockResponse));

    await provider.fetchRestaurantList();

    expect(provider.resultState, isA<RestaurantListLoadedState>());
  });

  test('3️⃣ Mengembalikan error ketika gagal', () async {
    when(mockApiServices.getRestaurantList()).thenThrow(Exception('Error'));

    await provider.fetchRestaurantList();

    expect(provider.resultState, isA<RestaurantListErrorState>());
  });
}

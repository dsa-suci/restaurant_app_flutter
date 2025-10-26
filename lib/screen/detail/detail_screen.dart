import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/favorite/favorite_provider.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String restaurantId;
  bool isFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isFetched) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        restaurantId = args;
        final detailProvider = Provider.of<RestaurantDetailProvider>(
          context,
          listen: false,
        );
        final favProvider = Provider.of<FavoriteProvider>(
          context,
          listen: false,
        );

        Future.microtask(() async {
          await detailProvider.fetchRestaurantDetail(restaurantId);
          await favProvider.checkFavorite(restaurantId);
        });

        isFetched = true;
      } else {
        throw Exception("Expected restaurant ID (String) as argument.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Restaurant")),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, _) {
          final state = provider.resultState;

          if (state is RestaurantDetailLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RestaurantDetailErrorState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text(state.message)),
            );
          } else if (state is RestaurantDetailLoadedState) {
            final restaurant = state.restaurant;

            return Consumer<FavoriteProvider>(
              builder: (context, favProvider, _) {
                final isFavorite = favProvider.isFavorite;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: restaurant.pictureId,
                        child: Image.network(
                          'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            restaurant.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              if (isFavorite) {
                                await favProvider.removeFavorite(restaurant.id);
                              } else {
                                final restaurantToSave = Restaurant(
                                  id: restaurant.id,
                                  name: restaurant.name,
                                  description: restaurant.description,
                                  pictureId: restaurant.pictureId,
                                  city: restaurant.city,
                                  rating: restaurant.rating,
                                );
                                await favProvider.addFavorite(restaurantToSave);
                              }
                            },
                          ),
                        ],
                      ),
                      Text('${restaurant.city} - ${restaurant.address}'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star),
                          const SizedBox.square(dimension: 4),
                          Expanded(child: Text(restaurant.rating.toString())),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(restaurant.description),
                      const SizedBox(height: 16),
                      Text(
                        "Kategori: ${restaurant.categories.map((c) => c.name).join(', ')}",
                      ),
                      const SizedBox(height: 16),
                      Text("Menu Makanan:"),
                      ...restaurant.menus.foods.map(
                        (food) => Text('• ${food.name}'),
                      ),
                      const SizedBox(height: 8),
                      Text("Menu Minuman:"),
                      ...restaurant.menus.drinks.map(
                        (drink) => Text('• ${drink.name}'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Review Pelanggan",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...restaurant.customerReviews.map((review) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  review.review,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  review.date,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: Text("Tidak ada data"));
        },
      ),
    );
  }
}

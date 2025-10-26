import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/search/search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  void _startSearch(String query) {
    if (query.trim().isEmpty) return;

    final provider = Provider.of<SearchProvider>(context, listen: false);
    provider.search(query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Restoran')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onSubmitted: _startSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _startSearch(_controller.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: Text(provider.errorMessage!)),
                  );
                }

                if (provider.results.isEmpty) {
                  return const Center(child: Text('Tidak ada hasil'));
                }

                return ListView.builder(
                  itemCount: provider.results.length,
                  itemBuilder: (context, index) {
                    final restaurant = provider.results[index];
                    return ListTile(
                      leading: Image.network(
                        'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(restaurant.name),
                      subtitle: Text(
                        '${restaurant.city} • ⭐ ${restaurant.rating}',
                      ),
                      onTap: () {
                        Provider.of<SearchProvider>(
                          context,
                          listen: false,
                        ).clearSearch();
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: restaurant.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

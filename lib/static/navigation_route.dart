enum NavigationRoute {
  mainRoute("/"),
  detailRoute("/detail"),
  searchRoute("/search"),
  favoriteRoute("/favorite");

  const NavigationRoute(this.name);
  final String name;
}

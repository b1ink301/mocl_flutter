enum Flavor {
  prd,
  dev,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.prd:
        return 'Mocl';
      case Flavor.dev:
        return 'Mocl_DEV';
      default:
        return 'Mocl';
    }
  }
}

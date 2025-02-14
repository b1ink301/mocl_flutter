enum Flavor {
  prd,
  dev,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title => switch (appFlavor) {
        Flavor.prd => 'Mocl',
        Flavor.dev => 'Mocl_DEV',
        _ => 'Mocl'
      };
}

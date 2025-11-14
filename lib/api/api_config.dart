class ApiConfig {
  static const bool useHttps = true; // toggle this for http/https

  // prodbackend.polzet.in
  // www.polzet.com

  static String get baseUrl {
    final protocol = useHttps ? 'https' : 'http';
    final domain = 'prodbackend.polzet.in';
    return '$protocol://$domain/api';
  }

  // https://www.polzet.com/api/users/delete_account

  static String get baseUrlImage {
    final protocol = useHttps ? 'https' : 'http';
    final domain = 'prodbackend.polzet.in';
    return '$protocol://$domain';
  }
}

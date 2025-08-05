class ApiEndpoints {
  static const String baseUrl = 'http://192.168.1.41:8000';

  static const String login = '/api/login';
  static const String logout = '/api/logout';
  static const String signup = '/api/sign-up';
  static const String rent = '/api/view-properties/rent';
  static const String purchase = '/api/view-properties/purchase';
  static const String offplan = '/api/view-properties/off-plan';
  static const String profile = '/api/my-profile';
  static const String updateProfile = '/api/update-profile';
  static const String resetpassword = '/api/reset-password';
  static const String renthistory = '/api/view-my-properties/rent';
  static const String purchasehistory = '/api/view-my-properties/purchase';
  static const String offplanhistory = '/api/view-my-properties/off-plan';
  static const String addProperty = '/api/add-property';
  static const String upgradeAccount = '/api/upgrade-to-seller';
  static const String viewAmenities = '/api/view-amenities';
  static const String viewPropertyDetails = '/api/view-property-details';
  static const String viewrecommendedProperties = '/api/view-property-details';
  static const String viewCountries = '/api/view-countries';
}

class ApiEndpoints {
  static const String baseUrl = 'http://10.182.151.138:8000';
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
  static const String viewrecommendedProperties =
      '/api/view-recommended-properties';
  static const String viewCountries = '/api/view-countries';
  static const String deleteProperty = '/api/delete-property';
  static const String searchProperties = '/api/properties/search';

  static const String viewServiceCategories = '/api/view-service-categories';
  static const String viewServiceProviders = '/api/view-service-providers';
  static const String viewServiceProvidersDetails = '/api/view-service-provider-details';
  static const String viewServiceProviderServiceGallery = '/api/view-service-provider-service-gallery';
  static const String viewServiceProviderQuote='/api/provider/quotes';
  static const String submitQuote = '/api/quotes';
  static const String declineQuote = '/api/quotes';
  static const String requestService = '/api/quotes/request';
  static const String viewUserRequests = '/api/user/quotes';
  static const String confirmQuote = '/api/quotes';
   static const String updateQuote = '/api/quotes';
  static const String markServiceAsCompleted = '/api/service-activities';
  static const String rateService = '/api/service-activities';

  static const String addToFavorite = '/api/add-property-to-favorite';
  static const String removeFromFavorite = '/api/remove-property-from-favorite';
  static const String favoriteRent = '/api/view-favorite-properties/rent';
  static const String favoritePurchase =
      '/api/view-favorite-properties/purchase';
  static const String favoriteOffplan =
      '/api/view-favorite-properties/off-plan';
  static const String bestServiceProviders = '/api/view-best-service-providers';
  static const String viewSubscriptionPlan = '/api/view-subscription-plans';
  static const String upgradeToServiceProvider = '/api/upgrade-to-service-provider';
  static const String myServices = '/api/view-my-services';
  static const String removeService = '/api/remove-service';
  static const String editService = '/api/edit-service';
  static const String addService = '/api/add-service';
  static const String servicePaymentIntent = '/api/service-activities';


  static const String getConversation = '/api/conversations';
  static const String viewMassages = '/api/conversations';
  static const String sendMassage = '/api/conversations';
  static const String subscription = '/api/subscription/create-payment-intent';
  static const String propertiesPayment = '/api/properties';




}

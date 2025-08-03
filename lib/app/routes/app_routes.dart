part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const GETSTARTED = _Paths.GETSTARTED;
  static const AUTH = _Paths.AUTH;
  static const REGISTER = _Paths.REGISTER;
  static const LOGOUT = _Paths.LOGOUT;
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const RENT = _Paths.RENT;
  static const PropertiesUnifiedView = _Paths.PropertiesUnifiedView;
  static const OFFPLANE = _Paths.OFFPLANE;
  static const PURCHASE = _Paths.PURCHASE;
  static const PROPERTIES = _Paths.PROPERTIES;
  static const PROFILE = _Paths.PROFILE;
  static const UPDATEPROFILE = _Paths.UPDATEPROFILE;
  static const RESETPASSWORD = _Paths.RESETPASSWORD;
  static const VIEWHISTORY = _Paths.VIEWHISTORY;
  // static const VIEWRENTHISTORY = _Paths.VIEWRENTHISTORY;
  // static const VIEWPURCHASEHISTORY = _Paths.VIEWPURCHASEHISTORY;
  // static const VIEWOFFPLANHISTORY = _Paths.VIEWOFFPLANHISTORY;
  static const CUSTOM_MAP = _Paths.CUSTOM_MAP;
  static const ADDPROPERTY = _Paths.ADDPROPERTY;
  static const ApartmentForRentView = _Paths.ApartmentForRentView;
  static const UPGRADETOSELLER = _Paths.UPGRADETOSELLER;
  static const PROPERTY_DETAILS = _Paths.PROPERTY_DETAILS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const GETSTARTED = '/getstarted';
  static const AUTH = '/auth';
  static const LOGOUT = '/logout';
  static const REGISTER = '/register';
  static const SPLASH = '/splash';
  static const ONBOARDING = '/Onboarding';
  static const PropertiesUnifiedView = '/PropertiesUnifiedView';
  static const RENT = '/rent';
  static const OFFPLANE = '/offplane';
  static const PURCHASE = '/purchase';
  static const PROPERTIES = '/properties';
  static const PROFILE = '/profile';
  static const UPDATEPROFILE = '/updateprofile';
  static const RESETPASSWORD = '/resetpassword';
  static const VIEWHISTORY = '/history';
  static const ADDPROPERTY = '/addproperty';
  static const ADDMAINPROPERTY = '/addproperty';
  static const ApartmentForRentView = '/ApartmentForRentView';
  static const CUSTOM_MAP = '/CUSTOM_MAP';
  static const UPGRADETOSELLER = '/upgradetoseller';
  static const PROPERTY_DETAILS = '/property_details';
}

abstract class NetworkEnvironment {
  static const DEVELOPMENT = "DOMAIN_COME_HERE";
  static const PRODUCTION = "DOMAIN_COME_HERE";
  static const QA = "DOMAIN_COME_HERE";
  static const DYNAMIC_BASE_URL = "DOMAIN_COME_HERE";
}

abstract class NetworkResponse {
  static const STATUS = "status";
  static const DATA = "data";
  static const STATUS_CODE = "status_code";
  static const SUCCESS = "success";
  static const FAILURE = "failure";
  static const EXCEPTION = "exception";
  static const NO_INTERNET = "no_internet";
}

abstract class NetworkAPI {
  static const String BASE_URL = NetworkEnvironment.DYNAMIC_BASE_URL;

  //Login
  static const String APP_CHARGE = "payment_gateways_demo/stripe_demo/stripe_php_6.11.0/examples/app_charge.php";
}

abstract class NetworkParams {
  static const USER_TOKEN = "UserToken";

  // Login & SignUp
  static const STRIPE_TOKEN = "stripeToken";
  static const STRIPE_EMAIL = "stripeEmail";
  static const STRIPE_AMOUNT = "stripeAmount";
  static const STRIPE_CURRENCY = "stripeCurrency";
}

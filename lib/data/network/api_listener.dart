abstract class ApiListener {
  void setLoadingState(bool isShow);
  void onApiSuccess(String statusCode, dynamic mObject);
  void onApiFailure(String statusCode, String message);
  void onException();
  void onNoInternetConnection();
}

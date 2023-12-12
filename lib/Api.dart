const String prod = "http://35.236.62.29";
const String dev = "http://127.0.0.1:8080";

class Api {
  static String token = "";
  static String refreshToken = "";
  static String endpoint = dev;
  static String instagramToken = "";
  static String instagramUserId = "";
  static final Api _this = Api._();
  Api._();
  factory Api() {
    return _this;
  }
}

const String prod = "https://egoapi-3abuugltmq-uw.a.run.app";
const String dev = "http://localhost:8080";

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

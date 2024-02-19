class AppString {
  AppString._();

  //Api call error
  static const cancelRequest = "Request to API server was cancelled";
  static const connectionTimeOut = "Connection timeout with API server";
  static const receiveTimeOut = "Receive timeout in connection with API server";
  static const sendTimeOut = "Send timeout in connection with API server";
  static const socketException = "Check your internet connection";
  static const unexpectedError = "Unexpected error occurred";
  static const unknownError = "Something went wrong";
  static const duplicateEmail = "Email has already been taken";
  static const farFromCheckIn = "Không thể xác nhận vì còn xa điểm đến";
  static const canNotGetLocation =
      "Không thể lấy được vị trí hiện tại. Vui lòng thử lại sau!";
  static const canNotCreateTrip = "Không thể tạo phiếu yêu cầu";
  //status code
  static const badRequest = "Bad request";
  static const unauthorized = "Unauthorized";
  static const forbidden = "Forbidden";
  static const notFound = "Not found";
  static const internalServerError = "Internal server error";
  static const badGateway = "Bad gateway";

  static const appFont = "Roboto";
  static const fakeGPS = 'Tín hiệu GPS hiện đang bị giả mạo, vui lòng kiểm tra';
}

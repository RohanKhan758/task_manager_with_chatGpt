/// Centralized API endpoint paths.
class ApiPaths {
  ApiPaths._();

  // ---- Auth ----
  static const String registration   = '/Registration';
  static const String login          = '/Login';
  static const String profileUpdate  = '/ProfileUpdate';
  static const String profileDetails = '/ProfileDetails';

  // ---- Password recovery (3 steps) ----
  // STEP 1: GET /RecoverVerifyEmail/:email
  static String recoverVerifyEmail(String email) =>
      '/RecoverVerifyEmail/$email';

  // STEP 2: GET /RecoverVerifyOtp/:email/:otp
  static String recoverVerifyOtp(String email, String otp) =>
      '/RecoverVerifyOtp/$email/$otp';

  // STEP 3: POST /RecoverResetPassword
  static const String recoverResetPassword = '/RecoverResetPassword';

  // ---- Tasks ----
  static const String createTask = '/createTask';
  static String listTaskByStatus(String status) => '/listTaskByStatus/$status';
  static String updateTaskStatus(String id, String status) =>
      '/updateTaskStatus/$id/$status';
  static String deleteTask(String id) => '/deleteTask/$id';
  static const String taskStatusCount = '/taskStatusCount';
}

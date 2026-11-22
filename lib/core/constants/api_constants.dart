class ApiConstants {
  static const String newsApiKey = '229d8c21cbd94ee7b04b3f997ac88594';
  static const String newsApiUrl =
      'https://newsapi.org/v2/everything?q=plants+agriculture+nature&language=en&pageSize=20&sortBy=publishedAt&apiKey=$newsApiKey';

  static const String geminiApiKey = 'AIzaSyC0mtM1QOi_p6EVjh6HWO0ayS6ZtWU2puA';
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=';

  static const String flaskPredictUrl = 'http://192.168.20.32:5000/predict';

  static const String razorpayKey = 'rzp_test_SzQbItYGKXrpzq';

  static const String cloudinaryCloudName = 'ds0psaxoc';
  static const String cloudinaryApiKey = '467315474851437';
  static const String cloudinaryApiSecret = 'DuxlsUbu1oahxHDkQkzXmggBb7Q';
}

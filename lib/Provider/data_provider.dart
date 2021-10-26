import 'package:flutter/cupertino.dart';
import 'package:flutter_pagination_demo/Models/news_model.dart';

class DataProvider extends ChangeNotifier {
  int page = 1;

  bool hasMore = true, isLoading = false, isFirstTimeLoading = false;

  List<NewsModel> news = [];
}

import 'package:flutter/material.dart';
import 'package:flutter_pagination_demo/Models/news_model.dart';
import 'package:flutter_pagination_demo/Provider/data_provider.dart';
import 'package:provider/provider.dart';

import 'Controllers/news_controller.dart';

class Pagination extends StatefulWidget {
  const Pagination({Key? key}) : super(key: key);

  @override
  _PaginationState createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  late News news;
  List<NewsModel> data = [];
  late Future<bool> _future;
  bool end = false;

  Future<bool> getData(BuildContext context) async {
    try {
      //  news = News();
      await news.getNews(context);
      data = Provider.of<DataProvider>(context, listen: false).news;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("in init");
    _future = Future.value(false);
    news = News();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      //UserController().fetchUserCurrentLocation(context);
      _future = getData(context);
      print(_future);
      setState(() {});
      //  await news.getNews(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return getListView(context);
                } else {
                  return Container(
                    child: const Text("error"),
                  );
                }
              }),
        ),
      ),
    );
  }

  // Widget SliverList(BuildContext context) {
  //   return CustomScrollView(
  //     slivers: <Widget>[
  //       SliverGrid(
  //         delegate: SliverChildBuilderDelegate(
  //           (context, index) => Column(
  //             children: [
  //               const SizedBox(
  //                 height: 8,
  //               ),
  //               Container(
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(8),
  //                     color: Colors.grey[400]),
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(index.toString()),
  //                     const SizedBox(
  //                       width: 4,
  //                     ),
  //                     Flexible(
  //                       child: Text(
  //                         data[index].title,
  //                         maxLines: 4,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 8,
  //               ),
  //               Container(
  //                 height: 2,
  //                 color: Colors.black,
  //               ),
  //               const SizedBox(
  //                 height: 8,
  //               ),
  //             ],
  //           ),
  //           childCount: data.length,
  //         ),
  //         gridDelegate:
  //             SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
  //       ),
  //       SliverToBoxAdapter(
  //         child: CircularProgressIndicator(),
  //       )
  //     ],
  //   );
  // }

  Widget getListView(BuildContext context) {
    return Consumer(
        builder: (context, DataProvider dataProvider, Widget? child) {
      return NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          var metrics = scrollEnd.metrics;
          if (metrics.atEdge) {
            if (scrollEnd is ScrollEndNotification) {
              if (metrics.pixels == 0) {
                dataProvider.isLoading = false;
                dataProvider.notifyListeners();
                // setState(() {});
                print('At top = ' + dataProvider.isLoading.toString());
              } else {
                // setState(() {});
                dataProvider.isLoading = true;
                dataProvider.notifyListeners();
                news.getNews(context);
                print('At bottom = ' + dataProvider.isLoading.toString());
              }
            }
          } else {
            end = false;
            setState(() {});
          }
          return true;
        },
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: data.length,
                itemBuilder: ((context, index) {
                  if (data.length == index) {}
                  return Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[400]),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(index.toString()),
                            const SizedBox(
                              width: 4,
                            ),
                            Flexible(
                              child: Text(
                                data[index].title,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (data.length == index + 1 && dataProvider.isLoading)
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      //  : Container()
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app_newsapi/helper/data.dart';
import 'package:test_app_newsapi/helper/news.dart';
import 'package:test_app_newsapi/models/ArticleModel.dart';
import 'package:test_app_newsapi/models/category_model.dart';
import 'package:test_app_newsapi/views/article_view.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({Key key, this.title}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categoris = new List<CategoryModel>();
  List<ArticleModel> article = new List<ArticleModel>();

  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoris = getCategory();
    getNews();
  }

  getNews() async {
    News news = News();
    await news.getNews();
    article = news.news;
    setState(() {
      print("check");
      _loading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Flutter"),
            Text(
              "News",
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading
          ? Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.all(10),
                child: Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: categoris.length,
                      itemBuilder: (context, index) {
                        return CategoryTitle(
                          CategoryName: categoris[index].categoryName,
                          imageUrl: categoris[index].imageURL,
                        );
                      }),
                ),
              ),
              Container(
                child: Expanded(
                  child: ListView.builder(itemBuilder: (context, index) {
                    print(article[index].urlToImage);
                    return BlogTile(
                      title: article[index].title,
                      desc: article[index].description,
                      imageURL: article[index].urlToImage,
                      url: article[index].url,
                    );
                  }),
                ),
              )
            ])),
    );
  }
}

class CategoryTitle extends StatelessWidget {
  final imageUrl, CategoryName;
  const CategoryTitle({Key key, this.imageUrl, this.CategoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black26,
              ),
              child: Text(
                CategoryName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  const BlogTile({Key key, this.imageURL, this.title, this.desc, this.url})
      : super(key: key);

  final String imageURL, title, desc, url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createRoute(url));
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: Column(
          children: <Widget>[
            Image.network(
              imageURL,
              fit: BoxFit.fill,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
            Text(
              title,
              style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal),
            ),
            Text(
              desc,
              style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 13,
                  fontStyle: FontStyle.normal),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRoute(String url) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        Article_view(url: url),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

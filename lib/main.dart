/*import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hover_wide_wallpaper/res/strings.dart';
import 'package:hover_wide_wallpaper/ui/fullview/fullview.dart';
import 'package:provider/provider.dart';
import 'AppStateNotifier.dart';
import 'draggable_plugin.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';
import 'package:hover_wide_wallpaper/data/models/api_result_model.dart';
import 'package:http/http.dart' as http;
import 'package:draw/draw.dart';

// void main() {
//   debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
//   runApp(MyApp());
// }
bool isDesktop;
bool isWeb;
Reddit reddit;
Future<void> main() async {
  //debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  if (kIsWeb) {
    isWeb = true;
    isDesktop = false;
  } else {
    isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }
  reddit = await Reddit.createReadOnlyInstance(
    clientId: AppStrings.clientId,
    clientSecret: AppStrings.clientSecret,
    userAgent: AppStrings.userAgent,
  );
  print(reddit.auth.credentials);
  //Redditor currentUser = null;

  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'R/WIDESCREENWALLPAPER',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            fontFamily: 'BlenderPro',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: Color(0xFF191919),
            fontFamily: 'BlenderPro',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: HomeUI(),
        );
      },
    );
  }
}

class HomeUI extends StatelessWidget {
  const HomeUI({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DraggableAppBar(
        title: 'R/WIDESCREENWALLPAPER',
        isDesktop: isDesktop,
        isWeb: isWeb,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Platform.operatingSystem,
                  style: TextStyle(fontSize: 18),
                ),
                FutureBuilder(
                  future: fetchPosts(http.Client()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(child: PostsList());
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          if (isDesktop) // Resize Handle
            Align(
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: 0.2,
                child: GestureDetector(
                  child: Icon(Icons.signal_cellular_4_bar),
                  onPanStart: DraggablePlugin.onResizeStart,
                  onPanUpdate: DraggablePlugin.onResizeUpdate,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class PostsList extends StatefulWidget {
  const PostsList({Key key}) : super(key: key);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  ScrollController _scrollCtrl = new ScrollController();
  bool loading = false;
  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() async {
      if (_scrollCtrl.position.pixels + 1500 >=
              _scrollCtrl.position.maxScrollExtent &&
          !loading) {
        setState(() {
          loading = true;
        });
        await fetchPosts(http.Client());
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  var width = 21;
  var height = 9;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: currentPosts.length,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, childAspectRatio: width / height),
              controller: _scrollCtrl,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Fullview(url: currentPosts[index].url)));
                  },
                  child: Card(
                      margin: EdgeInsets.all(5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.network(
                              currentPosts[index].thumbnail,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                              left: 10, top: 10, child: Text(index.toString())),
                        ],
                      )),
                );
              }),
        ),
        //if (loading) CircularProgressIndicator()
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_study_project/wechat_sound/wechat_sound_page.dart' deferred as wechat_sound_page;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(splashFactory: NoSplash.splashFactory),
        ),
      ),
      home: const Home(
        title: "CongDuan Flutter Demo",
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var routeList = routes.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(routeList[index]);
            },
            child: Card(
              child: Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                child: Text(routeList[index]),
              ),
            ),
          );
        },
        itemCount: routes.length,
      ),
    );
  }
}

class ContainerAsyncRouterPage extends StatelessWidget {
  final Future libraryFuture;

  ///不能直接传widget，因为 release 打包时 dart2js 优化会导致时许不对
  final WidgetBuilder child;

  const ContainerAsyncRouterPage(this.libraryFuture, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: libraryFuture,
        builder: (c, s) {
          if (s.connectionState == ConnectionState.done) {
            if (s.hasError) {
              return Scaffold(
                appBar: AppBar(),
                body: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Error: ${s.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
            return child.call(context);
          }
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          );
        });
  }
}

Map<String, WidgetBuilder> routes = {
  "仿微信发送语音": (context) {
    return ContainerAsyncRouterPage(
      wechat_sound_page.loadLibrary(),
      (context) => wechat_sound_page.WechatSoundPage(),
    );
  }
};

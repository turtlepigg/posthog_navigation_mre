import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = PostHogConfig('phc_QFbR1y41s5sxnNTZoyKG2NJo2RlsCIWkUfdpawgb40D');
  config.debug = true;
  config.captureApplicationLifecycleEvents = false;
  config.host = 'https://us.i.posthog.com';
  config.sessionReplay = true;
  config.sessionReplayConfig.maskAllTexts = false;
  config.sessionReplayConfig.maskAllImages = false;
  config.sessionReplayConfig.throttleDelay = const Duration(milliseconds: 1000);
  config.flushAt = 1;
  await Posthog().setup(config);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final router = GoRouter(
    observers: [PosthogObserver(), TestNavigationObserver()],
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const _InitialScreen(),
      ),
      GoRoute(
        path: '/second_route',
        builder: (context, state) => const _SecondRoute(),
      ),
      GoRoute(
        path: '/third_route',
        builder: (context, state) => const ThirdRoute(),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PostHogWidget(
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Flutter App',
      ),
    );
  }
}

class _InitialScreen extends StatefulWidget {
  const _InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<_InitialScreen> {
  final _posthogFlutterPlugin = Posthog();
  dynamic _result = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostHog Flutter App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.go('/second_route');
                  },
                  child: const PostHogMaskWidget(
                    child: Text(
                      'Go to Second Route',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Capture",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _posthogFlutterPlugin.screen(screenName: "my screen", properties: {
                          "foo": "bar",
                        });
                      },
                      child: const Text("Capture Screen manually"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _posthogFlutterPlugin.capture(eventName: "eventName", properties: {
                          "foo": "bar",
                        });
                      },
                      child: const Text("Capture Event"),
                    ),
                  ],
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Activity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _posthogFlutterPlugin.disable();
                      },
                      child: const Text("Disable Capture"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        _posthogFlutterPlugin.enable();
                      },
                      child: const Text("Enable Capture"),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _posthogFlutterPlugin.register("foo", "bar");
                  },
                  child: const Text("Register"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _posthogFlutterPlugin.unregister("foo");
                  },
                  child: const Text("Unregister"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _posthogFlutterPlugin.group(groupType: "theType", groupKey: "theKey", groupProperties: {
                      "foo": "bar",
                    });
                  },
                  child: const Text("Group"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _posthogFlutterPlugin.identify(userId: "myId", userProperties: {
                      "foo": "bar",
                    }, userPropertiesSetOnce: {
                      "foo1": "bar1",
                    });
                  },
                  child: const Text("Identify"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _posthogFlutterPlugin.alias(alias: "myAlias");
                  },
                  child: const Text("Alias"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _posthogFlutterPlugin.debug(true);
                  },
                  child: const Text("Debug"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _posthogFlutterPlugin.reset();
                  },
                  child: const Text("Reset"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _posthogFlutterPlugin.flush();
                  },
                  child: const Text("Flush"),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final result = await _posthogFlutterPlugin.getDistinctId();
                      setState(() {
                        _result = result;
                      });
                    },
                    child: const PostHogMaskWidget(
                      child: Text("distinctId"),
                    )),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Feature flags",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await _posthogFlutterPlugin.getFeatureFlag("feature_name");
                    setState(() {
                      _result = result;
                    });
                  },
                  child: const Text("Get Feature Flag status"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await _posthogFlutterPlugin.isFeatureEnabled("feature_name");
                    setState(() {
                      _result = result;
                    });
                  },
                  child: const Text("isFeatureEnabled"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await _posthogFlutterPlugin.getFeatureFlagPayload("feature_name");
                    setState(() {
                      _result = result;
                    });
                  },
                  child: const Text("getFeatureFlagPayload"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _posthogFlutterPlugin.reloadFeatureFlags();
                  },
                  child: const PostHogMaskWidget(child: Text("reloadFeatureFlags")),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Data result",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(_result.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondRoute extends StatefulWidget {
  const _SecondRoute();

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<_SecondRoute> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const PostHogMaskWidget(child: Text('First Route')),
      ),
      body: Center(
        child: RepaintBoundary(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const PostHogMaskWidget(child: Text('Open route')),
                onPressed: () {
                  context.go("/third_route");
                },
              ),
              const SizedBox(height: 20),
              const PostHogMaskWidget(
                  child: TextField(
                decoration: InputDecoration(
                  labelText: 'Sensitive Text Input',
                  hintText: 'Enter sensitive data',
                  border: OutlineInputBorder(),
                ),
              )),
              const SizedBox(height: 20),
              PostHogMaskWidget(
                  child: Image.asset(
                'assets/training_posthog.png',
                height: 200,
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ThirdRoute extends StatelessWidget {
  const ThirdRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Route'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: 16,
          itemBuilder: (context, index) {
            return Image.asset(
              'assets/posthog_logo.png',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}

class TestNavigationObserver extends RouteObserver<ModalRoute<dynamic>> {
  @override
  void didPush(Route route, Route? previousRoute) {
    print('didPush: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('didPop: ${route.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    print('didRemove: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print('didReplace: ${newRoute?.settings.name}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didChangeTop(Route topRoute, Route? previousTopRoute) {
    print('didChangeTop: ${topRoute.settings.name}');
    super.didChangeTop(topRoute, previousTopRoute);
  }
}

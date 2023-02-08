import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:keysight_pma/cache/appcache.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/localization.dart';
import 'package:keysight_pma/const/notificationCounter.dart';
import 'package:keysight_pma/const/themedata.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:keysight_pma/controller/alert/alertBottomBarProvider.dart';
import 'package:keysight_pma/firebase_option.dart';
import 'package:keysight_pma/routes/approutes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:umeng_push_sdk/umeng_push_sdk.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Utils.printInfo("*** Background Message Data: ${message.data}");
  Utils.printInfo(
      "*** Background Message Title : ${message.notification?.title}");
  Utils.printInfo(
      "*** Background Message Body : ${message.notification?.body}");
  AppCache.payload = message.data;
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Constants.IS_SUPPORT_GOOGLE) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  } else {
    UmengCommonSdk.initCommon(Constants.UMENG_ANDROID_APP_KEY,
        Constants.UMENG_IOS_APP_KEY, Constants.UMENG_CHANNEL);
    UmengCommonSdk.setPageCollectionModeManual();
    UmengPushSdk.register();
    UmengPushSdk.setPushEnable(true);
  }

  AppCache.getThemeValue().then(
    (value) {
      var isDarkTheme = value;
      AppCache.sortFilterCacheDTO!.currentTheme = isDarkTheme;
      return runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeClass(isDarkTheme)),
            ChangeNotifierProvider(create: (_) => Counter()),
          ],
          child: MyHomePage(),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AlertBottomBarProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyHomePageState? state =
        context.findAncestorStateOfType<_MyHomePageState>();
    state!.setLocale(newLocale);
  }

  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();

  void callStartTimer(DateTime expired) {
    Duration diff = expired.difference(DateTime.now());
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (timer.tick == (diff.inSeconds - 20)) {
          timer.cancel();
          await refreshAuth();
        }
      },
    );
  }

  Future refreshAuth() async {
    FlutterAppAuth _appAuth = FlutterAppAuth();
    AppCache.getStringValue(AppCache.REFRESH_TOKEN_PREF).then((value) async {
      TokenResponse? response = await _appAuth.token(
        TokenRequest(
          Constants.AUTH_CLIENT_ID,
          Constants.AUTH_REDIRECT_URI,
          clientSecret: Constants.AUTH_CLIENT_SECRET,
          discoveryUrl: Constants.AUTH_MAIN_DISCOVERY_URL,
          refreshToken: value,
          scopes: ['openid', 'profile'],
          allowInsecureConnections: true,
        ),
      );

      if (response != null) {
        AppCache.removeAuthToken();
        AppCache.setAuthToken(
            response.accessToken!, response.refreshToken!, response.idToken!);
        callStartTimer(response.accessTokenExpirationDateTime!);
      }
    });
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>(debugLabel: 'main_navigator');

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  void configEasyLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = AppColors.appBlue()
      ..backgroundColor = Colors.transparent
      ..indicatorColor = AppColors.appBlue()
      ..textColor = AppColors.appPrimaryWhite()
      ..maskColor = AppColors.appPrimaryBlack().withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  late Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    configEasyLoading();
    initialiseLocalNotifcation();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        Utils.printInfo("FCM Listen onMessage: ${message.notification?.title}");
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: android.smallIcon,
                ),
              ),
              payload: json.encode(message.data));
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        Utils.printInfo("****** ON MESSAGE OPENED APP ******");

        Utils.printInfo("*** Message Data: ${message.data}");
        Utils.printInfo("*** Message Title : ${message.notification?.title}");
        Utils.printInfo("*** Message Body : ${message.notification?.body}");

        AppCache.payload = message.data;
        // HomeBase.homeKey.currentState?.checkPush();
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        Utils.printInfo("****** ON GET INITIAL MESSAGE ******");
        if (message != null) {
          AppCache.payload = message.data;
        }
      },
    );
  }

  void initialiseLocalNotifcation() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((message) {
      if (message != null) {
        if (message.didNotificationLaunchApp) {
          AppCache.payload = json.decode(message.payload!);
        }
      }
    });

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    void selectNotification(String? payload) {
      //Handle notification tapped logic here
      Utils.printInfo("*** onTap Notification Bar: $payload");
      if (payload != null) {
        var data = json.decode(payload);
        Utils.printInfo("*** payloadData: $data");
        var dataMap = {
          'ref': data['ref'],
          'refId': data['refId'],
          'body': data['body'],
          'title': data['title'],
        };
        //Android local notification
        AppCache.payload = dataMap;
        // HomeBase.homeKey.currentState?.checkPush();
      }
    }

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Utils.printInfo("*** iOS onTap LocalNotification Bar| Title: $title");
    Utils.printInfo("*** iOS onTap LocalNotification Bar| Body: $body");
    Utils.printInfo("*** iOS onTap LocalNotification Bar| Payload: $payload");
  }

  @override
  void didChangeDependencies() {
    if (AppCache.me != null) {
      setState(() {
        this._locale = Utils.mylocale(AppCache.me!.data!.preferredLangCode!);
      });
    } else {
      setState(() {
        this._locale = Utils.mylocale(Constants.ENGLISH);
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeClass>(
      builder: (context, value, child) {
        return MaterialApp(
          title: 'Keysight PWA',
          theme: value.getTheme(),
          onGenerateRoute: AppRoutes.generatedRoute,
          initialRoute: AppRoutes.splashScreenRoute,
          navigatorKey: navigatorKey,
          navigatorObservers: <NavigatorObserver>[observer],
          locale: _locale,
          supportedLocales: [
            Locale("en"),
            Locale("zh"),
          ],
          localizationsDelegates: [
            MyLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale!.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          builder: (context, child) {
            return MediaQuery(
              child: FlutterEasyLoading(
                child: child,
              ),
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
        );
      },
    );
  }
}

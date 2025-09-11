// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/LoginDirect.dart';
import 'package:empire_ios/Models/EmpOrderSettingModel.dart';
import 'package:empire_ios/Models/FireUserModel.dart';
import 'package:empire_ios/Models/HideUnhideModel.dart';
import 'package:empire_ios/Models/LoginUserModel.dart';
import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/NotificationService/FirebaseApi.dart';
import 'package:empire_ios/auth.dart';

import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/AddNewproduct.dart';
import 'package:empire_ios/screen/firebaseHomeEnter.dart';
import 'package:empire_ios/screen/testAws.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ndialog/ndialog.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';
import 'package:yet_another_json_isolate/yet_another_json_isolate.dart';
import 'NotificationService/NotificationService.dart';
import 'amplifyconfiguration.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:timezone/data/latest.dart' as tz;

//lazy box

List<HideUnhideModel> hideUnhideSettings = [];
bool autoSync = true;
var srrr = 0;
var lFolder = 'TRADING';
var syncEmpire_OrderSnapShot;
var syncEmpire_Order_DeleteSnapShot;
var syncEmpire_Order_ColorSnapShot;
Map<String, dynamic> hiveBoxOpenedMap = {};
EmpOrderSettingModel empOrderSettingModel = EmpOrderSettingModel();
GetOptions fireGetOption = GetOptions(source: Source.server);
List currentYears = urldata.defultYears;
var fcmToken = "";
double screenWidthMobile = 0.0;
LoginUserModel loginUserModel = LoginUserModel();
FireUserModel fireUserModel = FireUserModel();
dynamic directLoginUserJson = {};
late Directory myUniqueApp;
//--------desktop.  var
Box? mainHiveStreamBox;
var jsonIsolate = YAJsonIsolate()..initialize();
StreamController<bool> somthingHaschange = StreamController<bool>.broadcast();

final StreamController<bool> DesktopOrderChangeStream = StreamController<bool>.broadcast();
//--------desktop.  var
bool firebaseFirstLoaded = false;
final StreamController<String> searchFilterChange = StreamController<String>.broadcast();
var firebaseSoftwaresName = "EMPIRE";
var androidId = "com.unique.empire_ios";
var IosId = "1611697370";
bool backgroundSyncInProcess = false;
var backgroundSyncInProcessForCompanyYear = "";
bool mycomputerSyncAccess = false;
late ProgressDialog progressDialog;
bool requestSent = false;
final processListSyncdone = StreamController<List<Map<String, dynamic>>>.broadcast();
final StreamController<String> SyncStatus = StreamController<String>.broadcast();
final StreamController<String> lastUpdateDateControl = StreamController<String>.broadcast();
final StreamController<String> pdfStatus = StreamController<String>.broadcast();
final StreamController<String> sftExpStatus = StreamController<String>.broadcast();
// final StreamController<String> somthingHaschange = StreamController<String>.broadcast();
Map<String, dynamic> GLB_CURRENT_USER = {};
Codec<String, String> stringToBase64 = utf8.fuse(base64);
const AndroidChennal = MethodChannel("shareAndroid");
const IosMethodChennal = MethodChannel("shareIosUnique");
SharedPreferences? prefs;
late TextEditingController ipController = TextEditingController();
var IosPlateForm;
var serverPort = 8080;
var boolPortChanged = false;
InAppLocalhostServer localhostServer = InAppLocalhostServer(port: serverPort);
var ColorHex = "588c7e";
var companyName = "UNIQUE";
var CD = "";
var assethtmlFolder = "/";
var assethtmlSubFolder = "uniquesoftwares/";
Color jsmColor = HexColor(ColorHex);
Color? basebcColor = Colors.greenAccent[300];

var firebaseLoginuser = FirebaseAuth.instance.currentUser;
final FirebaseAuth auth = FirebaseAuth.instance;
var firebEmail = kIsWeb ? "parmarprashant69@gmail.com" : dotenv.env["FB_LOGIN_EMAIL"];
var firebpass = kIsWeb ? "9251526910" : dotenv.env["FB_LOGIN_PASS"];
var fireBCollection = FirebaseFirestore.instance;
dynamic firebaseCurrntSupUserObj = {};
dynamic firebaseCurrntUserObj = {};
dynamic firebSoftwraesInfo = {};
String contactForPayment = "8469190530";
String contactEmail = "softwares.unique@gmail.com";
var admin = false;
final StreamController<List<XFile>> uploadImgListSelect = StreamController<List<XFile>>.broadcast();
Map<String, dynamic> importProductObj = {};
var bucketPublicBaseUrl = kIsWeb ? "9251526910" : dotenv.env["bucketPublicBaseUrl"];
final StreamController<bool> shareButtonBool = StreamController<bool>.broadcast();
List<ProductModel> tempSelectImglist = [];
final StreamController<List<ProductModel>> shareImgObjList = StreamController<List<ProductModel>>.broadcast();
Map<String, dynamic> shareSettingObj = {};
Map<String, dynamic> imgCacheUrlById = {};
Map<String, dynamic> imgFirebaseObjById = {};
Map<String, Map<String, dynamic>> QualLocalObjById = {};
Map<String, Map<String, dynamic>> QualMainScreenObjById = {};
var uuid = const Uuid();
late Box hiveMainBox;
late Box loginUsersBox;
Box? currentHiveBox;
Box? mediaBox;

Color? opColors = Color(0xFF0E3311).withOpacity(0.5);
ScreenshotController screenshotController = ScreenshotController();
final BaseCacheManager baseCacheManager = DefaultCacheManager();
var savedUrlForHomeScreen = "";
final StreamController<List<dynamic>> filterProductTagList = StreamController<List<dynamic>>.broadcast();
final StreamController<List<dynamic>> filterProductTag_LIDList = StreamController<List<dynamic>>.broadcast();
bool internetConnect = true;
//---------bulk pdf generate
List<dynamic> urlListgetedForBulkPdf = [];
List<XFile> pdfFileCreatedForBulkPdf = [];
var logger = Logger();
//---------bulk pdf generate
List<SharedFile>? receivedIntentShareList;
late Directory appDocumentDir;
//--comunication for local data retrive isolate
late SendPort sendPort;
var receivePort = ReceivePort();
bool boolHardwareAcceleration = true;
var basicAuthForLocal = "";
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isolateBinaryMessenger = ServicesBinding.instance.defaultBinaryMessenger;
  await dotenv.load(fileName: ".env");
  IosPlateForm = await Myf.isIos();
  if (kIsWeb) {
    //----------web load app
    await Hive.initFlutter();
    // await FirebaseFirestore.instance.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCBGSFMVIgPQZAqtgTTTHdy5NAo_Ss6EQc",
        authDomain: "autobackupdatabase-90253.firebaseapp.com",
        projectId: "autobackupdatabase-90253",
        storageBucket: "autobackupdatabase-90253.appspot.com",
        messagingSenderId: "56693222734",
        appId: "1:56693222734:web:768dd2f85901704c51421f",
        measurementId: "G-48X5DV5P9M",
      ),
    );
//  apiKey: dotenv.env['FB_API_KEY']!,
//           authDomain: dotenv.env['FB_AUTH_DOMAIN']!,
//           projectId: dotenv.env['FB_PROJECT_ID']!,
//           storageBucket: dotenv.env['FB_STORAGE_BUCKET']!,
//           messagingSenderId: dotenv.env['FB_MESSAGING_SENDER_ID']!,
//           appId: dotenv.env['FB_APP_ID']!,
//           measurementId: dotenv.env['FB_MEASUREMENT_ID']!),
    runApp(ProviderScope(child: const MyApp()));
  } else {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
    appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    //----------mobile load app
    if (Platform.isAndroid) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    // Myf.getNameOfHiveBoxs();
    if (kReleaseMode) {
      await SentryFlutter.init(
        (options) {
          options.dsn =
              kIsWeb ? "https://9e864194862212532c31dcec49fa5a3e@o4506631431651328.ingest.sentry.io/4506631513374720" : dotenv.env['sentry_dsn'];
          options.tracesSampleRate = 0.01;
          options.sampleRate = 0.00;
        },
        appRunner: () => runApp(ProviderScope(child: const MyApp())),
      );
    } else {
      runApp(ProviderScope(child: const MyApp()));
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme.apply(
          fontSizeFactor: 1,
          fontFamily: GoogleFonts.varelaRound().fontFamily,
        );
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UNIQUE',
        theme: ThemeData(
          textTheme: _textTheme,
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
            child: child!,
          );
        },
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DateTime currentBackPressTime;
  var _isLoading = true;

  Future<bool> _initializeApp() async {
    hiveMainBox = await SyncLocalFunction.openBoxCheck("hiveMainBox");
    loginUsersBox = await SyncLocalFunction.openBoxCheck("loginUsersBox");

    prefs = await SharedPreferences.getInstance();
    await FirebaseApi().initNotification(context);

    await kIsWeb ? null : await checkLocalServer();
    await firebaseUserIni();
    await _configureAmplify();
    tz.initializeTimeZones();
    // await kIsWeb ? null : await iniReceivedIntent();
    await kIsWeb ? null : deletePdfFilesOnOpen();
    kIsWeb ? null : loadAssets();
    kIsWeb ? await Logindirect.login() : null; //for empire softwares only
    // Myf.loadIsoLate();
    return true;
  }

  checkLocalServer() async {
    serverPort = await Myf.findFreePort();
    localhostServer = InAppLocalhostServer(port: serverPort, shared: true);
    var isServerIsRunning = await localhostServer.isRunning();
    try {
      if (!isServerIsRunning) {
        await localhostServer.start();
      }
    } catch (e) {
      Myf.noteError(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeApp().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  firebaseUserIni() async {
    try {
      var firebSoftwraesInfoString = prefs!.getString("firebSoftwraesInfo");
      if (firebSoftwraesInfoString != null) {
        firebSoftwraesInfo = jsonDecode(firebSoftwraesInfoString);
      }
    } catch (e) {
      print(e);
      Myf.noteError(e);
    }
    try {
      firebaseLoginuser = await FirebaseAuth.instance.currentUser;
      if (firebaseLoginuser == null) {
        await firebaseAuthfunction.SignInEmail("$firebEmail", "$firebpass");
      }
      fireBCollection.collection("softwares").doc("$firebaseSoftwaresName").get().then((value) async {
        dynamic d = await value.data();
        firebSoftwraesInfo = d;
        try {
          prefs!.setString("firebSoftwraesInfo", jsonEncode(firebSoftwraesInfo));
        } catch (e) {}
      });
    } catch (e) {}
  }

  // iniReceivedIntent() async {
  //   //print("iniReceivedIntent");
  //   try {
  //     StreamSubscription _intentDataStreamSubscription = FlutterSharingIntent.instance.getMediaStream().listen((List<SharedFile> value) async {
  //       value.length > 0 ? await recIntentFile(value) : null;
  //     }, onError: (err) {
  //       //print("getIntentDataStream error: $err");
  //       Myf.noteError(err);
  //     });

  //     // For sharing images coming from outside the app while the app is closed
  //     FlutterSharingIntent.instance.getInitialSharing().then((List<SharedFile> value) async {
  //       value.length > 0 ? await recIntentFile(value) : null;
  //     });
  //   } catch (e) {
  //     Myf.noteError(e);
  //     logger.e("iniReceivedIntent===${e}");
  //   }
  // }

  // Future<void> recIntentFile(List<SharedFile> value) async {
  //   receivedIntentShareList = value;
  //   List<XFile> recFileList = [];
  //   value.map((f) {
  //     recFileList.add(XFile(f.value.toString()));
  //     return f.value;
  //   }).join(",");
  //   var st = prefs!.getString("GLB_CURRENT_USER");
  //   Map<String, dynamic> GLB_CURRENT_USER = jsonDecode(st ?? "{}");
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => AddNewproduct(QUL_OBJ: {}, UserObj: GLB_CURRENT_USER),
  //       ));
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   uploadImgListSelect.sink.add(recFileList);
  // }

// ...
  Future<void> _configureAmplify() async {
    //print("_configureAmplify");
    try {
      final auth = AmplifyAuthCognito(
        /// Keychain Sharing in Xcode as described in the docs:
        /// https://docs.amplify.aws/lib/project-setup/platform-setup/q/platform/flutter/#enable-keychain
        secureStorageFactory: AmplifySecureStorage.factoryFrom(
          macOSOptions:
              // ignore: invalid_use_of_visible_for_testing_member
              MacOSSecureStorageOptions(useDataProtection: false),
        ),
      );
      final storage = AmplifyStorageS3();
      await Amplify.addPlugins([auth, storage]);
      if (amplifyconfig == null || amplifyconfig is! String || (amplifyconfig).isEmpty) {
        throw Exception("Amplify configuration is missing or invalid. Please check your amplifyconfiguration.dart file.");
      }
      await Amplify.configure(amplifyconfig);

      try {
        var awsUserEmail = kIsWeb ? "softwares.unique@gmail.com" : dotenv.env['awsUserEmail']!;
        var awsUsesPass = kIsWeb ? "Parasanshi@94281" : dotenv.env['awsUsesPass'];
        await Amplify.Auth.signIn(username: awsUserEmail, password: awsUsesPass);
      } catch (e) {
        // await Amplify.Auth.signOut();
      }
    } on Exception catch (e) {
      logger.e('_configureAmplify An error occurred configuring Amplify: $e');
      Myf.noteError("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidthMobile = ScreenWidth(context);
    return Scaffold(
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...Myf.MainAppIcon(context),
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Please wait", style: TextStyle(fontSize: 20)),
                ],
              ),
            )
          : FirebaseGetSoftwaresInfo(),
    );
  }

  void loadAssets() async {
    final appDir = await getApplicationDocumentsDirectory();
    final myUniqueAppName = 'myUniqueApp';
    final myUniqueAppPath = '${appDir.path}/$myUniqueAppName';
    myUniqueApp = Directory(myUniqueAppPath);
    var loadFirstTimeAssets = prefs!.getString("loadFirstTimeAssets").toString().contains("true");
    var st = prefs!.getString("GLB_CURRENT_USER");
    Map<String, dynamic> GLB_CURRENT_USER = jsonDecode(st ?? "{}");
    if (IosPlateForm) {
      int lastLoadTimestamp = prefs!.getInt('last_load_timestamp') ?? 0;
      int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      int difference = currentTimestamp - lastLoadTimestamp;
      // Myf.copyAllAssetsToDirectory(context, myUniqueApp.path, currentTimestamp);
      if (difference >= 86400000) {
        Myf.copyAllAssetsToDirectory(context, myUniqueApp.path, currentTimestamp);
      }
    }
  }

  // Function to delete PDF files in the documents directory
  void deletePdfFilesOnOpen() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> files = documentsDirectory.listSync();
      for (FileSystemEntity file in files) {
        if (file.path.endsWith('.pdf')) {
          await file.delete();
        }
      }
    } catch (e) {
      //print('Error deleting PDF files: $e');
    }
  }
}

double ScreenWidth(context) => MediaQuery.of(context).size.width;
double ScreenHeight(context) => MediaQuery.of(context).size.height;
double friendlyScreenWidth(BuildContext context, BoxConstraints constraints) {
  return widthResponsive(context)!;
}

double? widthResponsive(BuildContext context) => getValueForScreenType(context: context, mobile: 800, desktop: 800, tablet: 800);

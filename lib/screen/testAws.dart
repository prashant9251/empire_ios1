// import 'package:empire_ios/amplifyconfiguration.dart';
// import 'package:empire_ios/main.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_authenticator/amplify_authenticator.dart';
// import 'package:amplify_core/amplify_core.dart';
// import 'package:amplify_secure_storage/amplify_secure_storage.dart';
// import 'package:amplify_storage_s3/amplify_storage_s3.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:path_provider/path_provider.dart';

// class testAwsStart extends StatefulWidget {
//   const testAwsStart({Key? key}) : super(key: key);

//   @override
//   State<testAwsStart> createState() => _testAwsStartState();
// }

// class _testAwsStartState extends State<testAwsStart> {
//   static final _router = GoRouter(
//     routes: [
//       GoRoute(
//         path: '/',
//         builder: (BuildContext _, GoRouterState __) => const Testaws(),
//       ),
//     ],
//   );

//   @override
//   void initState() {
//     super.initState();
//     configureAmplify();
//   }

//   Future<void> configureAmplify() async {
//     final auth = AmplifyAuthCognito(
//       // FIXME: In your app, make sure to remove this line and set up
//       /// Keychain Sharing in Xcode as described in the docs:
//       /// https://docs.amplify.aws/lib/project-setup/platform-setup/q/platform/flutter/#enable-keychain
//       secureStorageFactory: AmplifySecureStorage.factoryFrom(
//         macOSOptions:
//             // ignore: invalid_use_of_visible_for_testing_member
//             MacOSSecureStorageOptions(useDataProtection: false),
//       ),
//     );
//     final storage = AmplifyStorageS3();

//     try {
//       await Amplify.addPlugins([auth, storage]);
//       await Amplify.configure(amplifyconfig);
//       try {
//         await Amplify.Auth.signIn(username: "softwares.unique@gmail.com", password: "Parasanshi@94281");
//       } catch (e) {
//         print(e);
//         // await Amplify.Auth.signOut();
//       }
//       // _logger.debug('Successfully configured Amplify');
//     } on Exception catch (error) {
//       // _logger.error('Something went wrong configuring Amplify: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Authenticator(
//       preferPrivateSession: true,
//       child: MaterialApp.router(
//         title: 'Flutter Demo',
//         builder: Authenticator.builder(),
//         theme: ThemeData.light(useMaterial3: true),
//         darkTheme: ThemeData.dark(useMaterial3: true),
//         routeInformationParser: _router.routeInformationParser,
//         routerDelegate: _router.routerDelegate,
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

// class Testaws extends StatefulWidget {
//   const Testaws({Key? key}) : super(key: key);

//   @override
//   State<Testaws> createState() => _TestawsState();
// }

// class _TestawsState extends State<Testaws> {
//   List<StorageItem> list = [];
//   var imageUrl = '';

//   @override
//   void initState() {
//     super.initState();
//     _checkAuthStatus();
//     _listAllPublicFiles();
//   }

//   // sign out of the app
//   Future<void> _signOut() async {
//     try {
//       await Amplify.Auth.signOut();
//       // _logger.debug('Signed out');
//     } on AuthException catch (e) {
//       // _logger.error('Could not sign out - ${e.message}');
//     }
//   }

//   // check if the user is signed in
//   Future<void> _checkAuthStatus() async {
//     try {
//       final session = await Amplify.Auth.fetchAuthSession();
//       // _logger.debug('Signed in: ${session.isSignedIn}');
//     } on AuthException catch (e) {
//       // _logger.error('Could not check auth status - ${e.message}');
//     }
//   }

//   // upload a file to the S3 bucket
//   Future<void> _uploadFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       withReadStream: true,
//       withData: false,
//     );

//     if (result == null) {
//       // _logger.debug('No file selected');
//       return;
//     }

//     final platformFile = result.files.single;

//     try {
//       await Amplify.Storage.uploadFile(
//         localFile: AWSFile.fromStream(
//           platformFile.readStream!,
//           size: platformFile.size,
//         ),
//         key: 'CLNT/${platformFile.name}',
//         // onProgress: (p) => _logger.debug('Uploading: ${p.transferredBytes}/${p.totalBytes}'),
//       ).result;
//       await _listAllPublicFiles();
//     } on StorageException catch (e) {}
//   }

//   // list all files in the S3 bucket
//   Future<void> _listAllPublicFiles() async {
//     try {
//       final result = await Amplify.Storage.list(
//         path: 'CLNT/',
//         options: const StorageListOptions(
//           pluginOptions: S3ListPluginOptions.listAll(),
//         ),
//       ).result;
//       setState(() {
//         list = result.items;
//       });
//     } on StorageException catch (e) {
//       // _logger.error('List error - ${e.message}');
//     }
//   }

//   // download file on mobile
//   Future<void> downloadFileMobile(String path) async {
//     final documentsDir = await getApplicationDocumentsDirectory();
//     final filepath = '${documentsDir.path}/$path';
//     try {
//       await Amplify.Storage.downloadFile(
//         key: path,
//         localFile: AWSFile.fromPath(filepath),
//         // onProgress: (p0) => _logger.debug('Progress: ${(p0.transferredBytes / p0.totalBytes) * 100}%'),
//       ).result;
//       await _listAllPublicFiles();
//     } on StorageException catch (e) {
//       // _logger.error('Download error - ${e.message}');
//     }
//   }

//   // download file on web
//   Future<void> downloadFileWeb(String path) async {
//     try {
//       await Amplify.Storage.downloadFile(
//         key: path,
//         localFile: AWSFile.fromPath(path),
//         // onProgress: (p0) => _logger.debug('Progress: ${(p0.transferredBytes / p0.totalBytes) * 100}%'),
//       ).result;
//       await _listAllPublicFiles();
//     } on StorageException catch (e) {
//       // _logger.error('Download error - ${e.message}');
//     }
//   }

//   // delete file from S3 bucket
//   Future<void> removeFile(String path) async {
//     try {
//       await Amplify.Storage.remove(
//         key: path,
//       ).result;
//       setState(() {
//         // set the imageUrl to empty if the deleted file is the one being displayed
//         imageUrl = '';
//       });
//       await _listAllPublicFiles();
//     } on StorageException catch (e) {
//       // _logger.error('Delete error - ${e.message}');
//     }
//   }

//   // get the url of a file in the S3 bucket
//   Future<String> getUrl(String path) async {
//     try {
//       final result = await Amplify.Storage.getUrl(
//         key: path,
//         options: const StorageGetUrlOptions(
//           pluginOptions: S3GetUrlPluginOptions(
//             validateObjectExistence: true,
//             expiresIn: Duration(minutes: 1),
//           ),
//         ),
//       ).result;
//       setState(() {
//         imageUrl = result.url.toString();
//         print(imageUrl);
//       });
//       return result.url.toString();
//     } on StorageException catch (e) {
//       // _logger.error('Get URL error - ${e.message}');
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Amplify Storage Example'),
//       ),
//       body: Text(
//         'Hello',
//       ),
//     );
//   }
// }

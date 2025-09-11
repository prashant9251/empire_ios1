import 'package:empire_ios/functions/StickerPrintingClass.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/JobCardForm/JobCardForm.dart';
import 'package:empire_ios/screen/JobCardForm/JobCardFormCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sidebarx/sidebarx.dart';

class JobCardPanel extends StatelessWidget {
  JobCardPanel({Key? key}) : super(key: key);

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Scaffold(
          key: _key,
          appBar: isSmallScreen
              ? AppBar(
                  backgroundColor: canvasColor,
                  title: Text(_getTitleByIndex(_controller.selectedIndex)),
                  leading: IconButton(
                    onPressed: () {
                      // if (!Platform.isAndroid && !Platform.isIOS) {
                      //   _controller.setExtended(true);
                      // }
                      _key.currentState?.openDrawer();
                    },
                    icon: const Icon(Icons.menu),
                  ),
                )
              : null,
          drawer: DrawerSidebarX(controller: _controller),
          body: Row(
            children: [
              if (!isSmallScreen) DrawerSidebarX(controller: _controller),
              Expanded(
                child: Center(child: _ScreensExample(controller: _controller)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DrawerSidebarX extends StatelessWidget {
  const DrawerSidebarX({Key? key, required SidebarXController controller})
      : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: white)),
        hoverColor: primaryColor,
        textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.black),
        hoverTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: actionColor.withAlpha((0.37 * 255).toInt())),
          gradient: const LinearGradient(colors: [canvasColor, canvasColor]),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.37 * 255).toInt()), blurRadius: 30)],
        ),
        iconTheme: IconThemeData(color: Colors.black..withAlpha((0.37 * 255).toInt()), size: 20),
        selectedIconTheme: const IconThemeData(color: Colors.black, size: 20),
      ),
      extendedTheme: const SidebarXTheme(width: 200, decoration: BoxDecoration(color: primaryColor)),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/img/applogo.png',
            ),
          ),
        );
      },
      items: [
        SidebarXItem(icon: Icons.home, label: 'Home', onTap: () {}),
        SidebarXItem(
            icon: Icons.search,
            label: 'Settings',
            onTap: () {
              Myf.Navi(context, TSCPrintScreen());
            }),
      ],
    );
  }

  void _showDisabledAlert(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item disabled for selecting', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({Key? key, required this.controller}) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return BlocProvider(create: (context) => JobCardFormCubit(context), child: JobCardForm());
          default:
            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      pageTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(color: primaryColor),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Sticker Size", style: theme.textTheme.titleLarge?.copyWith(color: Colors.black)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.mobile ? 1 : 2,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Height',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.mobile ? 1 : 2,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Width',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        flex: getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.mobile ? 1 : 2,
                        child: SizedBox(
                          width: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GFButton(
                        onPressed: () {
                          // Add your save logic here
                        },
                        color: Colors.green,
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Settings';
    default:
      return 'Not found page';
  }
}

// Color palette based on #588c7e
const primaryColor = Color(0xFF588C7E);
const canvasColor = Color(0xFFF5F5FA);
const scaffoldBackgroundColor = Color(0xFFFFFFFF);
const accentCanvasColor = Color(0xFFE0E0F6);
const white = Colors.white;
final actionColor = const Color(0xFF588C7E).withOpacity(0.6);
final divider = Divider(color: primaryColor.withOpacity(0.3), height: 1);

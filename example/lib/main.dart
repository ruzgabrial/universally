import 'package:flutter/material.dart';
import 'package:universally/component/src/switch_api.dart';
import 'package:universally/universally.dart';

import 'page/webview_page.dart';

Future<void> main() async {
  isBeta = true;

  await GlobalConfig().setDefaultConfig(ProjectConfig(
      mainColor: Colors.blueAccent,
      betaUrl: '这是设置测试url',
      releaseUrl: '这里设置发布版url',
      initializeSP: true,
      toastOptions: const ToastOptions(ignoring: false)));

  runApp(BasicApp(
      alertNotNetwork: (ConnectivityResult result) {
        return alertOnlyMessage('Not Network')!;
      },
      showNetworkToast: (ConnectivityResult result) {
        switch (result) {
          case ConnectivityResult.wifi:
            showToast('use wifi');
            break;
          case ConnectivityResult.ethernet:
            showToast('use ethernet');
            break;
          case ConnectivityResult.mobile:
            showToast('use Cellular networks');
            break;
          case ConnectivityResult.none:
            break;
          case ConnectivityResult.bluetooth:
            break;
        }
      },
      providers: [ChangeNotifierProvider(create: (_) => AppState())],
      home: const HomePage(),
      initState: (context, bool network, ConnectivityResult? result) async {}));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
        padding: EdgeInsets.fromLTRB(
            15, getStatusBarHeight + 15, 15, getBottomNavigationBarHeight + 15),
        isScroll: true,
        child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              if (isMobile) ...[
                ElevatedText(
                    onPressed: () => push(const FlWebViewPage()),
                    text: 'WebView'),
                ElevatedText(
                    onPressed: () =>
                        push(const FlWebViewPage(isCalculateHeight: true)),
                    text: 'WebView CalculateHeight'),
              ],
              ElevatedText(onPressed: _callPhone, text: 'Call Phone'),
              ElevatedText(
                  onPressed: () {
                    showDoubleChooseAlert(
                        title: 'title', left: 'left', right: 'right');
                  },
                  text: 'showDoubleChooseAlert'),
              ElevatedButton(
                  onPressed: () {}, child: const CleanCache(color: UCS.white)),
              ElevatedButton(
                  onPressed: () {},
                  child: const SwitchApiButton(color: UCS.white)),
              const PushSwitchState(),
            ]));
  }

  Future<void> _callPhone() async {
    await UrlLauncher().openUrl('tel:10086');
  }
}

class ElevatedText extends StatelessWidget {
  const ElevatedText({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) =>
      ElevatedButton(onPressed: onPressed, child: Text(text));
}

class AppState with ChangeNotifier {}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetConnection extends StatelessWidget {
  final Widget? child;
  final AppBar? appBar;
  final bool? isExtendBodyBehindAppBar;
  final bool? isResizeToAvoidBottomInset;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  InternetConnection({
    this.child,
    this.appBar,
    this.isExtendBodyBehindAppBar = false,
    this.isResizeToAvoidBottomInset = false,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: isExtendBodyBehindAppBar!,
      resizeToAvoidBottomInset: isResizeToAvoidBottomInset,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      appBar: appBar,
      body: StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (BuildContext ctxt, AsyncSnapshot<ConnectivityResult> snapShot) {
          if (!snapShot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var result = snapShot.data;
          switch (result) {
            case ConnectivityResult.mobile:
            case ConnectivityResult.wifi:
              return child!;
            case ConnectivityResult.none:
              return const Center(
                child: Text(
                  "No Internet Connection!",
                  style: TextStyle(fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            default:
              return child!;
          }
        },
      ),
    );
  }
}

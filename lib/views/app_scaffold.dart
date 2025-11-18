import 'package:flutter/cupertino.dart';
import 'package:flutter_launch/go_router_builder.dart';
import 'package:flutter_launch/components/address_debugger.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const AppScaffold({super.key, required this.child, required this.state});

  int _calculateCurrentIndex(GoRouterState state) {
    if (state.uri.toString() == '/details') {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      // appBar: PlatformAppBar(title: const AddressDebugger()),
      body: child,
      bottomNavBar: PlatformNavBar(
        itemChanged: (index) {
          switch (index) {
            case 0:
              HomeScreenRoute().go(context);
              break;
            case 1:
              DetailsScreenRoute().go(context);
              break;
          }
        },
        currentIndex: _calculateCurrentIndex(state),
        items: [
          BottomNavigationBarItem(
            icon: Icon(context.platformIcons.home, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(context.platformIcons.info, size: 24),
            label: 'Details',
          ),
        ],
      ),
    );
  }
}

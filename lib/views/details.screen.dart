import 'package:barrio_bites/go_router_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DetailsScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: const Text('Details Screen')),
      body: Center(
        child: PlatformElevatedButton(
          onPressed: () => HomeScreenRoute().go(context),
          child: const Text('Go back to the Home screen'),
        ),
      ),
    );
  }
}

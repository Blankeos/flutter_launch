import 'package:barrio_bites/providers/auth_provider.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = useAuth(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlatformElevatedButton(
              onPressed: () {
                GoRouter.of(context).go("/details");
              },
              child: const Text('Go to the Details screen'),
            ),
            Container(height: 50),
            PlatformElevatedButton(
              onPressed: () {
                GoRouter.of(context).replace("/onboarding");
              },
              child: const Text('Go to Onboarding'),
            ),
            Container(height: 50),

            if (auth.isAuthenticated)
              const Text("Is Authenticated")
            else
              const Text("Is not Authenticated"),
            Container(height: 50),

            PlatformElevatedButton(
              onPressed: () {
                auth.login();
              },
              child: const Text('Login (fake)'),
            ),
            Container(height: 10),
            PlatformElevatedButton(
              onPressed: () {
                auth.logout();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

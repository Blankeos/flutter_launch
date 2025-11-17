import 'package:barrio_bites/providers/auth.provider.dart';
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
                auth.getCurrentUser();
              },
              child: const Text('Get current user'),
            ),
            Container(height: 20),

            OtpLoginForm(),

            Container(height: 20),
            PlatformElevatedButton(
              onPressed: () {
                auth.logoutCommand.run();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpLoginForm extends StatefulWidget {
  const OtpLoginForm({super.key});

  @override
  State<OtpLoginForm> createState() => _OtpLoginFormState();
}

class _OtpLoginFormState extends State<OtpLoginForm> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  String? _userId;

  @override
  Widget build(BuildContext context) {
    final auth = useAuth(context);

    return Column(
      children: [
        PlatformText("Email"),
        if (auth.loginOtpCommand.isRunning.value) PlatformText("(loading...)"),
        Container(height: 10),
        PlatformTextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        if (_userId != null) ...[
          PlatformText("OTP"),
          if (auth.verifyOtpCommand.isRunning.value)
            PlatformText("(loading...)"),
          Container(height: 10),
          PlatformTextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
          ),
        ],
        Container(height: 10),
        PlatformElevatedButton(
          onPressed: () async {
            if (_userId == null) {
              // Send OTP
              final userId = await auth.loginOtpCommand.runAsync(
                _emailController.text,
              );
              if (userId != null) {
                setState(() {
                  _userId = userId;
                });
              }
            } else {
              // Verify OTP
              await auth.verifyOtpCommand.runAsync((
                userId: _userId!,
                code: _otpController.text,
              ));
            }
          },
          child: Text(_userId == null ? 'Send OTP' : 'Login with OTP'),
        ),
      ],
    );
  }
}

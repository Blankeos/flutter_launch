import 'dart:convert';

import 'package:barrio_bites/providers/auth.provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              Text(
                JsonEncoder.withIndent('  ').convert(auth.user),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14.0, // Optional: adjust size for readability
                ),
              )
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

            OAuthButtons(),

            Container(height: 20),

            if (auth.isAuthenticated)
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
        ValueListenableBuilder<bool>(
          valueListenable: auth.loginOtpCommand.isRunning,
          builder: (context, result, _) {
            if (result) {
              return PlatformText("(loading...)");
            }
            return PlatformText("(status)");
          },
        ),
        Container(height: 10),
        PlatformTextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        if (_userId != null) ...[
          PlatformText("OTP"),
          ValueListenableBuilder<bool>(
            valueListenable: auth.verifyOtpCommand.isRunning,
            builder: (context, result, _) {
              if (result) {
                return PlatformText("(loading...)");
              }
              return PlatformText("(status)");
            },
          ),
          Container(height: 10),
          PlatformTextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
          ),
        ],
        Container(height: 10),
        PlatformElevatedButton(
          onPressed: () async {
            try {
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

                _userId = null;
                _emailController.clear();
                _otpController.clear();
              }
            } catch (error) {
              debugPrint(error.toString());
            }
          },
          child: Text(_userId == null ? 'Send OTP' : 'Login with OTP'),
        ),
      ],
    );
  }
}

class OAuthButtons extends StatefulWidget {
  const OAuthButtons({super.key});
  @override
  State<OAuthButtons> createState() => _OAuthButtonsState();
}

class _OAuthButtonsState extends State<OAuthButtons> {
  @override
  Widget build(BuildContext context) {
    final auth = useAuth(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        PlatformTextButton(
          onPressed: () async {
            final url = await auth.getLoginGoogleUrl();
            debugPrint("URL: $url");

            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          },
          child: SvgPicture.asset(
            "assets/icons/google.svg",
            semanticsLabel: 'Google Logo',
            width: 24,
            height: 24,
          ),
        ),
        PlatformTextButton(
          onPressed: () {},
          child: SvgPicture.asset(
            "assets/icons/github.svg",
            semanticsLabel: 'GitHub Logo',
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}

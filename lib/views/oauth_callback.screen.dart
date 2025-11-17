import 'package:barrio_bites/go_router_builder.dart';
import 'package:barrio_bites/providers/auth.provider.dart';
import 'package:flutter/material.dart';

class OAuthCallbackScreen extends StatefulWidget {
  const OAuthCallbackScreen({super.key, required this.authCode});

  final String? authCode;

  @override
  State<OAuthCallbackScreen> createState() => _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends State<OAuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate login process - will be replaced with actual loginOAuthToken() call
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      debugPrint("[oauth_callback.screen] ${widget.authCode}");
      if (widget.authCode == null) {
        HomeScreenRoute().go(context);
      }

      final auth = useAuth(context, listen: false);

      await auth.loginOAuthTokenCommand.runAsync(widget.authCode);

      // ignore: use_build_context_synchronously
      HomeScreenRoute().go(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              widget.authCode != null
                  ? 'Logging in...'
                  : 'Failed to login. Redirecting you back...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

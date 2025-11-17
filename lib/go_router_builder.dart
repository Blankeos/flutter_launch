import 'package:barrio_bites/providers/has_onboarded.provider.dart';
import 'package:barrio_bites/views/address_debugger.dart';
import 'package:barrio_bites/views/details.screen.dart';
import 'package:barrio_bites/views/home.screen.dart';
import 'package:barrio_bites/views/oauth_callback.screen.dart';
import 'package:barrio_bites/views/onboarding.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

part 'go_router_builder.g.dart';

@TypedGoRoute<HomeScreenRoute>(
  path: '/',
  routes: [
    TypedGoRoute<DetailsScreenRoute>(path: "/details"),
    TypedGoRoute<OnboardingRoute>(path: "/onboarding"),
    TypedGoRoute<OAuthCallbackRoute>(path: "/oauth_callback"),
  ],
)
@immutable
class HomeScreenRoute extends GoRouteData with _$HomeScreenRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

@immutable
class DetailsScreenRoute extends GoRouteData with _$DetailsScreenRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DetailsScreen();
  }
}

@immutable
class OnboardingRoute extends GoRouteData with _$OnboardingRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OnboardingScreen();
  }
}

@immutable
class OAuthCallbackRoute extends GoRouteData with _$OAuthCallbackRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final authCode = state.uri.queryParameters['auth_code'];
    return OAuthCallbackScreen(authCode: authCode);
  }
}

final routerConfig = GoRouter(
  redirect: (BuildContext context, GoRouterState state) async {
    final hasOnboardedProvider = useHasOnboardedProvider(
      context,
      listen: false,
    );
    await hasOnboardedProvider.initLoad();

    final bool hasOnboarded = hasOnboardedProvider.hasOnboarded;
    if (!hasOnboarded && state.matchedLocation != '/onboarding') {
      return '/onboarding';
    }

    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => PlatformScaffold(
        appBar: PlatformAppBar(title: AddressDebugger()),
        body: child,
      ),
      routes: $appRoutes,
    ),
  ],
);

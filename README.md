# flutter_launch

## Renaming this template:

1. Look for these exact texts in the entire codebase, and replace it:

- `flutter_launch` - generally renames everything.
- `Flutter Launch` - Display Name (in Info.plist).
- `flutterlaunch` - Deeplink scheme I set here in Info.plist, change it to anything unique. Also, bundle identifier doesn't have to be the same btw.
- `flutterLaunch` - Bundle identifier as well, but not sure why it's a different case.

Use your editor i.e. Zed can do this easily

A new Flutter project.

- [x] Routing & Navigation (typesafe) & Nested Layouts & Params (go_router + go_router_builder.dart)
- [x] DeepLinks (handled by go_router by default, just make sure to add schemes in the manifests)
- [x] API Calls & Parsing models
- [x] Svgs and Static Images, Images from src. (flutter_svg)
- [ ] Fonts
- [ ] Gestures Tap and Touch
- [ ] Gestures Swipe, used for navigation?
- [ ] Animations
- [x] Cookie Auth simple fetch. (cookie_jar, dio, dio_cookie_manager)
- [x] Cookie Auth + WebView Redirect (OAuth) - I would generally adivce using just `url_launcher`, feels safer. Not webview.
- [ ] Canvas Skia?
- [ ] Superwall? Paywall experiments?
- [ ] Offline Experience - fallback + disabling actions (rn's netinfo)
- [ ] UI:Drag and Drop
- [ ] UI: Morphing Modals
- [ ] Apple-like bottomsheet
- [ ] Lottie
- [ ] Native Modules: Camera
- [ ] Native Modules: Location and Geo

import 'package:barrio_bites/go_router_builder.dart';
import 'package:barrio_bites/providers/auth.provider.dart';
import 'package:barrio_bites/providers/has_onboarded.provider.dart';
import 'package:barrio_bites/services/auth.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HasOnboardedProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAuthService;

      if (mounted) {
        final authProvider = useAuth(context, listen: false);
        await authProvider.init();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(routerConfig: routerConfig);
  }
}

/*
Explanation of the 'const' keyword and the "Invalid Constant" error:

1.  What is 'const'?
    - In Dart and Flutter, 'const' is used to mark something as a compile-time constant.
    - When you mark a widget with 'const' (e.g., `const Text('Hello')`), the Flutter framework understands that this widget and its properties will *never* change after being created.
    - Flutter can optimize performance by creating 'const' widgets only *once* at compile time and reusing that single instance whenever needed in the widget tree, instead of rebuilding it every time `build` is called.

2.  Rule for using 'const':
    - You can only mark an object (like a widget instance) as 'const' if *all* of its constructor arguments are also compile-time constants.
    - This means every value passed to the constructor must be something known definitively at the time the code is compiled (like string literals, number literals, booleans, or other const variables/objects).

3.  The Problem with Interactive Widgets (like TextButton) and 'const':
    - Widgets that respond to user interaction, like `TextButton`, often require a callback function for events like `onPressed`.
    - In the original code, we provide `onPressed: () {}`. The `() {}` is an anonymous function literal (a function without a name).
    - A function literal like `() {}` is *not* a compile-time constant. Its exact instance and memory location are determined at runtime, not compile time.

4.  Consequence:
    - Because the `onPressed` argument (`() {}`) is not a compile-time constant, the `TextButton` instance created with `TextButton(onPressed: () {}, ...)` *cannot* be marked `const`. If you tried to write `const TextButton(...)` with that `onPressed` value, you would get a compile-time error: "Invalid constant value."

5.  How this affects Parent Widgets:
    - If a widget cannot be marked `const`, then any widget that *contains* it also cannot be marked `const` *if* the containing widget's constructor is called with `const`.
    - For example, if `TextButton(onPressed: () {}, ...)` is a child of a `Column`, and you tried to make that `Column` a `const Column(...)`, you would get the "Invalid Constant" error. This error propagates up the tree: `const Scaffold(...)` containing that column would fail, `const MaterialApp(...)` containing that scaffold would fail, and so on.

6.  Why the change shown in the prompt's example "fixes" the old "Invalid Constant" error related to TextButton (in that specific context):
    - The prompt's example code *removed* the `onPressed: () {}` argument from the `TextButton`.
    - By removing `onPressed: () {}`, the `TextButton` no longer has a non-constant argument being passed to its constructor (assuming its `child` is also const, which `const Text('Click me!')` was originally).
    - *Without* the non-constant `onPressed` callback, the `TextButton(child: ...)` *becomes capable* of being part of a constant widget tree.
    - Therefore, if you previously had an error trying to mark a parent widget (like `MaterialApp` as shown in the prompt's example) as `const` because of the `TextButton` with `onPressed: () {}`, removing that `onPressed` callback allows the `TextButton` (and thus its parents) to be `const`-constructible, resolving that *specific* "Invalid Constant" error originating from the `TextButton`.

7.  Important Caveat:
    - While removing `onPressed: () {}` allows the button to be part of a `const` tree, it also makes the button *non-interactive*. Clicking it will do nothing. This is usually not the desired behavior for a button in a real app.

8.  Correct Handling (as in the original code block above):
    - The code provided above (the original `<rewrite_this>` section) correctly handles this:
        - It uses `const` on `Text` widgets where appropriate, as they are constant.
        - It provides the necessary `onPressed: () {}` callback for the `TextButton` so it's interactive.
        - It *does not* mark the `TextButton` itself, or its parent containers (`Column`, `Center`, `Scaffold`, `MaterialApp`), as `const`, because the `TextButton` with its non-constant `onPressed` prevents them from being valid compile-time constants.
    - This approach is standard and avoids the "Invalid Constant" error while maintaining the button's functionality.
*/

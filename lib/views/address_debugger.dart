import 'package:barrio_bites/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

class AddressDebugger extends StatefulWidget {
  final String buttonText;

  const AddressDebugger({super.key, this.buttonText = "Go"});

  @override
  State<AddressDebugger> createState() => _AddressDebuggerState();
}

class _AddressDebuggerState extends State<AddressDebugger> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: PlatformTextField(
            onTapOutside: (event) {
              print('onTapOutside');
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: _controller,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.go,
          ),
        ),
        const SizedBox(width: 8.0),
        PlatformElevatedButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            final String address = _controller.text;
            if (address.isNotEmpty) {
              context.go(address);
            }
          },
          child: Text(widget.buttonText),
        ),
      ],
    );
  }
}

part of ui.components;

class Atmosphere extends StatefulWidget {
  final ViewController viewController;
  final Widget lithosphere;

  const Atmosphere({
    required this.viewController,
    required this.lithosphere,
    Key? key,
  }) : super(key: key);

  @override
  State<Atmosphere> createState() => _AtmosphereState();
}

class _AtmosphereState extends State<Atmosphere> {
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: KeyboardListener(
          autofocus: true,
          focusNode: focusNode,
          onKeyEvent: (KeyEvent keyEvent) {},
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: FoundationColor.blue100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: widget.lithosphere,
              ),
              Stack(
                children: [
                  if (widget
                      .viewController.toastController.toastQueue.isNotEmpty)
                    Positioned(
                      left: -340,
                      top: 0,
                      child: Toast(
                        widget.viewController.toastController.toastQueue.first,
                        key: UniqueKey(),
                      ),
                    ),
                  // Atmospheric Widgets
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToastController {
  final List<ToastData> toastQueue = [];
  final ViewController viewController;

  ToastController(this.viewController);

  void addToQueue(ToastData toastData) {
    viewController.setState(() {
      toastQueue.add(toastData);
    });
  }

  void clearToastQueue() {
    toastQueue.removeWhere((ToastData t) => t.hasBeenShown == true);
  }

  void refresh() {
    clearToastQueue();
  }
}

class KeybineController {
  final ViewController viewController;

  KeybineController(this.viewController);

  void recordKeyEvent(KeyEvent keyEvent) {}
}

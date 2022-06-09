import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WindowListener {
  bool value = false;

  int index = 0;

  final settingsController = ScrollController();
  final viewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('Confirm close'),
            content: const Text('Are you sure you want to close this window?'),
            actions: [
              FilledButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: DragToMoveArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Win Fluent ",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (i) => setState(() => index = i),
        displayMode: PaneDisplayMode.auto,
        items: [
          // It doesn't look good when resizing from compact to open
          // PaneItemHeader(header: Text('User Interaction')),
          PaneItem(
            icon: const Icon(FluentIcons.dashboard_add),
            title: const Text('Dashboard'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.page_arrow_right),
            title: const Text('Page 1'),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.page_arrow_right),
            title: const Text('Page 2'),
          ),
        ],
        autoSuggestBox: AutoSuggestBox(
          controller: TextEditingController(),
          items: const ['Item 1', 'Item 2', 'Item 3', 'Item 4'],
        ),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        footerItems: [
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
          ),
        ],
      ),
      content: NavigationBody(
        index: index,
        children: [
          // ignore: avoid_unnecessary_containers
          Container(
            child: const Center(
              child: Text("Home 01"),
            ),
          ),
          Container(
            child: const Center(
              child: Text("Page 01"),
            ),
          ),
          Container(
            child: const Center(
              child: Text("Home 02"),
            ),
          ),
          Container(
            child: const Center(
              child: Text("Settings page"),
            ),
          ),
        ],
      ),
    );
  }
}

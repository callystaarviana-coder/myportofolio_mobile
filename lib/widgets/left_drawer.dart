import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      'Explore personal projects and experiences!',
                      style: TextStyle(color: colors.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => _goHome(context),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () => _replacePage(context, const ProjectFormPage()),
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Add Education'),
            onTap: () => _replacePage(context, const EducationFormPage()),
          ),
        ],
      ),
    );
  }

  void _goHome(BuildContext context) {
    // A form opened from a card already has Home at the bottom of the stack.
    if (ModalRoute.of(context)?.isFirst == false) {
      final navigator = Navigator.of(context);
      navigator.pop();
      navigator.popUntil((route) => route.isFirst);
      return;
    }
    _replacePage(context, const MyHomePage());
  }

  void _replacePage(BuildContext context, Widget page) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.pushReplacement<void, void>(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}

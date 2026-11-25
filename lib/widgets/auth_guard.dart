import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;
  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute<bool>(builder: (_) => const LoginScreen()),
  );
  return loggedIn ?? false;
}

Future<void> logoutWithFeedback(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);
  var message = 'Berhasil logout.';
  try {
    await context.read<AuthState>().logout();
  } catch (_) {
    message = 'Keluar dari aplikasi. Server belum mengonfirmasi logout.';
  }
  if (!messenger.mounted) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

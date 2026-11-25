import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _techStack = '';
  String _projectUrl = '';
  String _projectImageUrl = '';
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: _decoration('Nama Proyek'),
                      onSaved: (value) => _title = value!.trim(),
                      validator: (value) =>
                          _required(value, 'Nama proyek', maxLength: 255),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _decoration('Deskripsi Proyek'),
                      maxLines: 5,
                      onSaved: (value) => _description = value!.trim(),
                      validator: (value) =>
                          _required(value, 'Deskripsi proyek'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _decoration(
                        'Teknologi yang Digunakan',
                        hint: 'Contoh: Flutter, Django, Figma',
                      ),
                      onSaved: (value) => _techStack = value!.trim(),
                      validator: (value) =>
                          _required(value, 'Teknologi', maxLength: 255),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _decoration(
                        'Tautan Proyek',
                        hint: 'URL Proyek (opsional)',
                      ),
                      keyboardType: TextInputType.url,
                      onSaved: (value) => _projectUrl = value!.trim(),
                      validator: (value) => _validateUrl(value, maxLength: 200),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _decoration(
                        'URL Gambar Proyek',
                        hint: 'URL gambar (opsional)',
                      ),
                      keyboardType: TextInputType.url,
                      onSaved: (value) => _projectImageUrl = value!.trim(),
                      validator: (value) => _validateUrl(value, maxLength: 500),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                        ),
                        onPressed: _isSubmitting ? null : _submit,
                        child: Text(_isSubmitting ? 'Menyimpan…' : 'Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: const OutlineInputBorder(),
    );
  }

  String? _required(String? value, String label, {int? maxLength}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label tidak boleh kosong!';
    if (maxLength != null && text.runes.length > maxLength) {
      return 'Maksimal $maxLength karakter.';
    }
    return null;
  }

  String? _validateUrl(String? value, {required int maxLength}) {
    final url = value?.trim() ?? '';
    if (url.isEmpty) return null;
    if (url.runes.length > maxLength) return 'Maksimal $maxLength karakter.';
    final uri = Uri.tryParse(url);
    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty ||
        url.contains(RegExp(r'\s'))) {
      return 'Masukkan URL http atau https yang valid.';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();
    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);
    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();

    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = auth.token;
      if (token == null) return;
      final project = Project(
        title: _title,
        description: _description,
        techStack: _techStack,
        projectUrl: _projectUrl,
        projectImageUrl: _projectImageUrl,
      );

      final Project saved;
      try {
        saved = await api.createProject(project, token: token);
      } on ApiException catch (error) {
        if (!mounted) return;
        if (error.statusCode == 401) {
          auth.clearSession(token);
          _showError('Sesi berakhir. Login ulang untuk menyimpan proyek.');
          await ensureLoggedIn(context);
          return;
        }
        _showError(switch (error.statusCode) {
          400 => 'Data proyek ditolak. Periksa kembali isian formulir.',
          403 => 'Hanya pemilik portofolio yang dapat menambahkan proyek.',
          _ => 'Proyek gagal disimpan (HTTP ${error.statusCode}).',
        });
        return;
      }

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: Text(saved.title),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) form.reset();
    } catch (_) {
      if (mounted) _showError('Proyek gagal disimpan. Periksa koneksi.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

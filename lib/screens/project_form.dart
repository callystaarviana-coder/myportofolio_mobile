import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  static const _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  String _projectName = '';
  String _description = '';
  String _category = _categories.first;
  String _technologies = '';
  String _projectLink = '';

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
                      onChanged: (value) => _projectName = value,
                      validator: (value) => _required(value, 'Nama proyek'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _decoration('Deskripsi Proyek'),
                      maxLines: 5,
                      onChanged: (value) => _description = value,
                      validator: (value) =>
                          _required(value, 'Deskripsi proyek'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: _decoration('Kategori Proyek'),
                      initialValue: _categories.first,
                      isExpanded: true,
                      items: [
                        for (final category in _categories)
                          DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) =>
                          _category = value ?? _categories.first,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _decoration(
                        'Teknologi yang Digunakan',
                        hint: 'Contoh: Flutter, Django, Figma',
                      ),
                      onChanged: (value) => _technologies = value,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _decoration(
                        'Tautan Proyek',
                        hint: 'URL Proyek (opsional)',
                      ),
                      keyboardType: TextInputType.url,
                      onChanged: (value) => _projectLink = value,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                        ),
                        onPressed: _showSummary,
                        child: const Text('Save'),
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

  String? _required(String? value, String label) {
    return value == null || value.trim().isEmpty
        ? '$label tidak boleh kosong!'
        : null;
  }

  void _showSummary() {
    final form = _formKey.currentState!;
    if (!form.validate()) return;

    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Proyek berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nama Proyek: $_projectName'),
              Text('Deskripsi: $_description'),
              Text('Kategori: $_category'),
              Text('Teknologi: $_technologies'),
              Text('Tautan: $_projectLink'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              form.reset();
              _projectName = '';
              _description = '';
              _category = _categories.first;
              _technologies = '';
              _projectLink = '';
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

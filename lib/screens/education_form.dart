import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _institution = TextEditingController();
  final _degree = TextEditingController();
  final _description = TextEditingController();
  final _startYear = TextEditingController();
  final _endYear = TextEditingController();
  bool _isCurrent = false;

  @override
  void dispose() {
    _institution.dispose();
    _degree.dispose();
    _description.dispose();
    _startYear.dispose();
    _endYear.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Edukasi'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _institution,
                      decoration: _decoration('Nama Sekolah / Universitas'),
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          _requiredText(value, maxLength: 255),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _degree,
                      decoration: _decoration('Jenjang / Program Studi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          _requiredText(value, maxLength: 255),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _description,
                      decoration: _decoration('Deskripsi'),
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 5,
                      validator: _requiredText,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _startYear,
                      decoration: _decoration('Tahun Masuk', hint: '2025'),
                      keyboardType: TextInputType.number,
                      textInputAction: _isCurrent
                          ? TextInputAction.done
                          : TextInputAction.next,
                      validator: _validateYear,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Masih menempuh pendidikan'),
                      value: _isCurrent,
                      onChanged: (value) => setState(() => _isCurrent = value),
                    ),
                    if (!_isCurrent) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _endYear,
                        decoration: _decoration('Tahun Selesai', hint: '2029'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        validator: _validateEndYear,
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _showSummary,
                      child: const Text('Simpan'),
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

  String? _requiredText(String? value, {int? maxLength}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Kolom ini wajib diisi.';
    if (maxLength != null && text.runes.length > maxLength) {
      return 'Maksimal $maxLength karakter.';
    }
    return null;
  }

  String? _validateYear(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Kolom ini wajib diisi.';
    if (!RegExp(r'^[0-9]{4}$').hasMatch(text) || text == '0000') {
      return 'Masukkan tahun yang valid dalam 4 digit.';
    }
    return null;
  }

  String? _validateEndYear(String? value) {
    final error = _validateYear(value);
    if (error != null) return error;

    final startYear = _startYear.text.trim();
    if (_validateYear(startYear) == null &&
        int.parse(value!.trim()) < int.parse(startYear)) {
      return 'Tahun selesai tidak boleh sebelum tahun masuk.';
    }
    return null;
  }

  void _showSummary() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final summary = {
      'Institusi': _institution.text.trim(),
      'Jenjang / Program Studi': _degree.text.trim(),
      'Deskripsi': _description.text.trim(),
      'Tahun Masuk': _startYear.text.trim(),
      'Tahun Selesai': _isCurrent ? 'Belum selesai' : _endYear.text.trim(),
      'Masih menempuh pendidikan': _isCurrent ? 'Ya' : 'Tidak',
    };

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ringkasan Edukasi'),
        scrollable: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entry in summary.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('${entry.key}: ${entry.value}'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

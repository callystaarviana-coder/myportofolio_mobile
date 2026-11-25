import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Proyek')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  project.techStack,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 16),
                if (project.projectImageUrl.isNotEmpty) ...[
                  Image.network(
                    project.projectImageUrl,
                    height: 240,
                    fit: BoxFit.contain,
                    webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                    errorBuilder: (_, _, _) =>
                        const Text('Gambar gagal dimuat.'),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(project.description),
                if (project.projectUrl.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Tautan Proyek'),
                  SelectableText(project.projectUrl),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

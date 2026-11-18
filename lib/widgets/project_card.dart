import 'package:material_ui/material_ui.dart';

class ItemHomepage {
  const ItemHomepage(this.name, this.icon, this.color, {this.page});

  final String name;
  final IconData icon;
  final Color color;
  final Widget? page;
}

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final ItemHomepage item;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return Material(
      color: item.color,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Kamu telah menekan tombol ${item.name}!'),
              ),
            );

          final page = item.page;
          if (page != null) {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(builder: (_) => page),
            );
          }
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 136),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 30, color: Colors.white),
                const SizedBox(height: 6),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

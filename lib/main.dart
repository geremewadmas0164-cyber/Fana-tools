import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fana Tools',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const IgaPage(),
    );
  }
}

class AppDb {
  static Future<List<Map<String, Object?>>> all(String table) async => [];
  static Future<void> add(String table, Map<String, dynamic> data) async {}
  static Future<void> update(String table, Map<String, dynamic> data, int id) async {}
}

class IgaPage extends StatefulWidget {
  const IgaPage({super.key});

  @override
  State<IgaPage> createState() => _IgaPageState();
}

class _IgaPageState extends State<IgaPage> {
  List<Map<String, Object?>> rows = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    rows = await AppDb.all('iga_projects');
    if (mounted) setState(() {});
  }

  Future<void> form([Map<String, Object?>? old]) async {
    final n = TextEditingController(
      text: old != null ? old['project_name']?.toString() ?? '' : '',
    );
    final rev = TextEditingController(
      text: old != null ? old['monthly_revenue']?.toString() ?? '0' : '0',
    );
    String st = old != null ? old['status']?.toString() ?? 'በስራ ላይ' : 'በስራ ላይ';

    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(old == null ? 'IGA ጨምር' : 'IGA አስተካክል'),
        content: StatefulBuilder(
          builder: (c, set) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: n,
                decoration: const InputDecoration(labelText: 'የፕሮጀክት ስም'),
              ),
              TextField(
                controller: rev,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ወርሃዊ ገቢ'),
              ),
              DropdownButton<String>(
                value: st,
                isExpanded: true,
                items: const ['በስራ ላይ', 'በማልማት ላይ', 'ተጠናቋል']
                    .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                    .toList(),
                onChanged: (v) => set(() => st = v!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('ዝጋ'),
          ),
          FilledButton(
            onPressed: () async {
              final vals = {
                'project_name': n.text,
                'status': st,
                'monthly_revenue': double.tryParse(rev.text) ?? 0,
              };
              if (old == null) {
                await AppDb.add('iga_projects', vals);
              } else {
                await AppDb.update('iga_projects', vals, old['id'] as int);
              }
              if (c.mounted) Navigator.pop(c);
              await load();
            },
            child: const Text('አስቀምጥ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => form(),
          label: const Text('ፕሮጀክት ጨምር'),
          icon: const Icon(Icons.add),
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: rows
              .map(
                (r) => Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.assignment_turned_in,
                      color: Colors.teal,
                    ),
                    title: Text(r['title']?.toString() ?? ''),
                    subtitle: Text(
                      'ተጠቃሚ፡ ${r['target_beneficiaries'] ?? ''} | በጀት፡ ${r['budget'] ?? 0} ብር | ${r['status'] ?? ''}',
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
}

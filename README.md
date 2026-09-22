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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const IgaPage(),
    );
  }
}

class IgaPage extends StatefulWidget {
  const IgaPage({super.key});

  @override
  State<IgaPage> createState() => _IgaPageState();
}

class _IgaPageState extends State<IgaPage> {
  final List<Map<String, dynamic>> rows = [];

  void form([Map<String, dynamic>? old]) {
    final n = TextEditingController(
      text: old != null ? old['project_name'].toString() : '',
    );
    final rev = TextEditingController(
      text: old != null ? old['monthly_revenue'].toString() : '0',
    );
    String st = old != null ? old['status'].toString() : 'በስራ ላይ';

    showDialog(
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
              const SizedBox(height: 10),
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
            onPressed: () {
              setState(() {
                if (old == null) {
                  rows.add({
                    'id': rows.length + 1,
                    'project_name': n.text,
                    'status': st,
                    'monthly_revenue': double.tryParse(rev.text) ?? 0,
                  });
                } else {
                  old['project_name'] = n.text;
                  old['status'] = st;
                  old['monthly_revenue'] = double.tryParse(rev.text) ?? 0;
                }
              });
              Navigator.pop(c);
            },
            child: const Text('አስቀምጥ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fana Tools'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => form(),
        label: const Text('ፕሮጀክት ጨምር'),
        icon: const Icon(Icons.add),
      ),
      body: rows.isEmpty
          ? const Center(child: Text('ምንም የተመዘገበ ፕሮጀክት የለም'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: rows.length,
              itemBuilder: (context, index) {
                final r = rows[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.assignment_turned_in,
                      color: Colors.teal,
                    ),
                    title: Text(r['project_name'].toString()),
                    subtitle: Text(
                      'ገቢ፡ ${r['monthly_revenue']} ብር | ${r['status']}',
                    ),
                    onTap: () => form(r),
                  ),
                );
              },
            ),
    );
  }
}

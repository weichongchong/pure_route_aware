import 'package:flutter/material.dart';
import 'package:pure_route_aware/pure_route_aware.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pure Route Aware Demo',
      // Step 1: Register the PureRouteObserver
      navigatorObservers: [PureRouteObserver()],
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Step 2: Use PureRouteAwareMixin
class _HomePageState extends State<HomePage> with PureRouteAwareMixin<HomePage> {
  String _status = 'Visible';
  final List<String> _logs = [];

  void _addLog(String message) {
    setState(() {
      _logs.insert(0, '${DateTime.now().toString().substring(11, 19)} $message');
      if (_logs.length > 10) _logs.removeLast();
    });
  }

  @override
  void didPushNext() {
    super.didPushNext();
    // Called when a new route is pushed on top (page becomes hidden)
    setState(() => _status = 'Hidden');
    _addLog('didPushNext - Page hidden');
    debugPrint('HomePage: didPushNext');
  }

  @override
  void didPopNext() {
    super.didPopNext();
    // Called when the route above is popped (page becomes visible)
    setState(() => _status = 'Visible');
    _addLog('didPopNext - Page visible');
    debugPrint('HomePage: didPopNext');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Route Status: $_status',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('isRouteVisible: $isRouteVisible'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DetailPage()),
                );
              },
              child: const Text('Go to Detail Page'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Dialogs don't trigger didPushNext (PopupRoute is filtered)
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Dialog'),
                    content: const Text(
                      'This dialog does NOT trigger didPushNext\n'
                      'because PopupRoute is automatically filtered.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Show Dialog (no callback)'),
            ),
            const SizedBox(height: 16),
            const Text('Event Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(_logs[index], style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with PureRouteAwareMixin<DetailPage> {
  @override
  void didPushNext() {
    super.didPushNext();
    debugPrint('DetailPage: didPushNext - hidden');
  }

  @override
  void didPopNext() {
    super.didPopNext();
    debugPrint('DetailPage: didPopNext - visible');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}

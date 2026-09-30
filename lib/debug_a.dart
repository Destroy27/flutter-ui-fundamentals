import 'package:flutter/material.dart';

const String studentName = 'Gede Pasek Ary Sugiantara';
const String studentId = '2415051074';

class DebugPageA extends StatelessWidget {
  const DebugPageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus A: Row Overflow')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Versi bermasalah (Row tanpa Expanded):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info),
                const SizedBox(width: 8),
                Text(
                  '$studentId - $studentName - Ini adalah teks yang sangat '
                  'panjang untuk menguji layout dan sengaja dibuat melebihi '
                  'lebar layar.',
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              'Versi diperbaiki (Text dibungkus Expanded):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$studentId - $studentName - Ini adalah teks yang sangat '
                    'panjang untuk menguji layout dan sengaja dibuat melebihi '
                    'lebar layar.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
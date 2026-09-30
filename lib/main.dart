import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadStudentData() async {
  final String jsonString = await rootBundle.loadString(
        'assets/data/student_data.json',
  );
  final Map<String, dynamic> data =
      jsonDecode(jsonString) as Map<String, dynamic>;

  debugPrint('=== student_data.json berhasil dimuat ===');
  debugPrint('nim     : ${data['student']['nim']}');
  debugPrint('name    : ${data['student']['name']}');
  debugPrint('courses : ${(data['courses'] as List<dynamic>).length} item');

  return data;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
         home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Gagal memuat data: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          final int totalCredits = courses.fold<int>(
            0,
            (sum, course) => sum + (course['credits'] as int),
          );
          final int doneCount = courses
              .where((course) => course['status'] == 'done')
              .length;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ProfileCard(student: student),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.menu_book,
                          value: '${courses.length}',
                          label: 'Mata Kuliah',
                          color: Colors.indigo,
                        ),
                      ),
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.workspace_premium,
                          value: '$totalCredits',
                          label: 'Total SKS',
                          color: Colors.teal,
                        ),
                      ),
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.task_alt,
                          value: '$doneCount',
                          label: 'Selesai',
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    'Daftar Mata Kuliah',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return CourseCard(
                    course: courses[index] as Map<String, dynamic>,
                  );
                },
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.student});

  final Map<String, dynamic> student;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 42,
                            backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(height: 12),
            Text(
              student['name'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'NIM ${student['nim']}',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.indigo,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _InfoRow(
              label: 'Program Studi',
              value: student['program'] as String,
            ),
            _InfoRow(
              label: 'Kelas',
              value: student['kelas'] as String,
            ),
            _InfoRow(
              label: 'Dosen Pengampu',
              value: student['lecturer'] as String,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    final String status = course['status'] as String;

    final IconData statusIcon;
    final Color statusColor;
    final String statusLabel;

    switch (status) {
      case 'done':
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        statusLabel = 'Selesai';
      case 'active':
        statusIcon = Icons.play_circle;
        statusColor = Colors.blue;
        statusLabel = 'Sedang';
      default:
        statusIcon = Icons.schedule;
        statusColor = Colors.orange;
        statusLabel = 'Direncanakan';
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor),
        title: Text(course['title'] as String),
        subtitle: Text(
          '${course['code']} | ${course['credits']} SKS',
        ),
        trailing: Chip(
          label: Text(statusLabel),
          labelStyle: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
          backgroundColor: statusColor,
          side: BorderSide.none,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
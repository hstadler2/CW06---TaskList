import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _tasksRef = FirebaseFirestore.instance.collection('tasks');

  // Controllers for new task input fields.
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _subtasksController = TextEditingController();

  // Add a new task.
  Future<void> _addTask() async {
    final user = _auth.currentUser;
    if (user == null) return;
    String taskName = _taskController.text.trim();
    if (taskName.isEmpty) return;

    // Parse subtasks (comma-separated).
    List<String> subtasks = [];
    if (_subtasksController.text.trim().isNotEmpty) {
      subtasks = _subtasksController.text
          .split(',')
          .map((e) => e.trim())
          .where((element) => element.isNotEmpty)
          .toList();
    }
    await _tasksRef.add({
      'name': taskName,
      'completed': false,
      'subtasks': subtasks,
      'userId': user.uid,
      'timestamp': FieldValue.serverTimestamp()
    });
    _taskController.clear();
    _subtasksController.clear();
  }

  // Toggle task completion.
  Future<void> _toggleTask(DocumentSnapshot task) async {
    bool currentStatus = task['completed'] ?? false;
    await _tasksRef.doc(task.id).update({'completed': !currentStatus});
  }

  // Delete a task.
  Future<void> _deleteTask(String taskId) async {
    await _tasksRef.doc(taskId).delete();
  }

  // Sign out.
  void _logout() async {
    await AuthService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Input area for a new task.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    labelText: 'Task Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _subtasksController,
                  decoration: const InputDecoration(
                    labelText: 'Subtasks (comma separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
          const Divider(),
          // List of tasks from Firestore.
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _tasksRef
                  .where('userId', isEqualTo: user?.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // Show the actual error message.
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final tasks = snapshot.data!.docs;
                if (tasks.isEmpty) {
                  return const Center(child: Text('No tasks added.'));
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot task = tasks[index];
                    List<dynamic>? subtasks = task['subtasks'];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: task['completed'] ?? false,
                                  onChanged: (val) {
                                    _toggleTask(task);
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    task['name'] ?? 'No name',
                                    style: TextStyle(
                                      decoration: task['completed']
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteTask(task.id),
                                ),
                              ],
                            ),
                            // Nested list for subtasks.
                            if (subtasks != null && subtasks.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0, top: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: subtasks.map((subtask) => Text("- $subtask")).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

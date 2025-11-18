import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<String> _routes = [
    '/homepage',
    '/keuangan',
    '/warga',
    '/kegiatan',
    '/pengaturan',
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    context.go(_routes[index]); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey[300]!, 
              width: 1, 
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          selectedItemColor: Colors.deepPurpleAccent[400],
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined),
              label: "Keuangan",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: "Warga",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              label: "Kegiatan",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Pengaturan",
            ),
          ],
        ),
      ),
    );
  }
}

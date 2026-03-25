import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final bool isActive;
  final VoidCallback onRequestSetup;

  const StatusCard({
    super.key,
    required this.isActive,
    required this.onRequestSetup,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isActive 
              ? [Colors.deepPurple, Colors.indigo] 
              : [Colors.redAccent, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? Icons.verified_user : Icons.warning_amber_rounded,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isActive ? 'Service Active' : 'Service Inactive',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    isActive 
                      ? 'The app is set as default call screening service.' 
                      : 'Grant default app status to enable features.',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            if (!isActive)
              ElevatedButton(
                onPressed: onRequestSetup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.redAccent,
                ),
                child: const Text('Setup'),
              ),
          ],
        ),
      ),
    );
  }
}

//pest_control_screen.dart
import 'package:flutter/material.dart';

class PestControlScreen extends StatelessWidget {
  const PestControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco-friendly Pest Control'),
        backgroundColor: Color(0xFFDCECCF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green.withOpacity(0.2),
              ),
              child: Image.asset(
                'assets/pest_control_banner.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.pest_control,
                      size: 80,
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Overview section
            const Text(
              'Chemical-Free Pest Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Our eco-friendly pest control system combines enzyme-based pest control with frequency-based repellent technologies to protect your crops without harmful chemicals.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Current status card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'System Status: Active',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Enzyme Dispenser',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '85%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text('Remaining'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Frequency Emitter',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Active',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text('All zones'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Technologies section
            const Text(
              'Our Technologies',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Enzyme-based control
            _buildTechnologyCard(
              title: 'Enzyme-Based Pest Control',
              description:
                  'Natural enzymes that target specific pest species while being harmless to beneficial insects, plants, and humans.',
              icon: Icons.science,
              benefits: [
                'Biodegradable and non-toxic',
                'Species-specific targeting',
                'No resistance development',
                '100% chemical-free solution',
              ],
            ),
            const SizedBox(height: 16),

            // Frequency-based repellent
            _buildTechnologyCard(
              title: 'Frequency-Based Repellent',
              description:
                  'Ultrasonic and electromagnetic waves that deter pests from entering your farm without harming them.',
              icon: Icons.graphic_eq,
              benefits: [
                'No physical harm to any species',
                'Coverage up to 5 acres per device',
                'Energy efficient operation',
                'Weather-resistant equipment',
              ],
            ),
            const SizedBox(height: 20),

            // Pest detection history
            const Text(
              'Recent Pest Detections',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                final List<Map<String, dynamic>> detections = [
                  {
                    'pest': 'Aphids',
                    'date': 'March 18, 2025',
                    'status': 'Controlled',
                    'location': 'North Field',
                  },
                  {
                    'pest': 'Cabbage Loopers',
                    'date': 'March 15, 2025',
                    'status': 'Controlled',
                    'location': 'East Field',
                  },
                  {
                    'pest': 'Spider Mites',
                    'date': 'March 10, 2025',
                    'status': 'Controlled',
                    'location': 'South Field',
                  },
                ];

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.bug_report, color: Colors.amber),
                    title: Text(detections[index]['pest']),
                    subtitle: Text(
                      '${detections[index]['date']} • ${detections[index]['location']}',
                    ),
                    trailing: Chip(
                      label: Text(
                        detections[index]['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Control buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Activate All Systems'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Color(0xFFA3C585),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All systems activated')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.schedule),
                    label: const Text('Schedule Treatment'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 105, 188, 255),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Schedule coming soon')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnologyCard({
    required String title,
    required String description,
    required IconData icon,
    required List<String> benefits,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            const Text(
              'Benefits:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  benefits
                      .map(
                        (benefit) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(benefit)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

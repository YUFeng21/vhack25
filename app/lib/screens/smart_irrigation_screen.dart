//smart_irrigation_screen.dart
import 'package:flutter/material.dart';

class SmartIrrigationScreen extends StatelessWidget {
  const SmartIrrigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Irrigation & Fertilization'),
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
                'assets/irrigation_banner.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.water_drop,
                      size: 80,
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Section: Water Optimization
            _buildSection(
              title: 'Water Optimization',
              content:
                  'Our smart irrigation system analyzes real-time soil moisture, weather forecasts, and crop water requirements to deliver precisely the right amount of water at the right time.',
              icon: Icons.water_drop,
            ),

            // Water usage metrics
            _buildMetricsCard(
              title: 'Current Soil Moisture',
              value: '62%',
              subtitle: 'Optimal range: 60-70%',
              icon: Icons.water,
              color: Colors.blue,
            ),

            _buildMetricsCard(
              title: 'Water Saved This Month',
              value: '1,240 Liters',
              subtitle: '30% reduction from previous month',
              icon: Icons.savings,
              color: Colors.green,
            ),

            const SizedBox(height: 20),

            // Section: Fertilization
            _buildSection(
              title: 'Smart Fertilization',
              content:
                  'Based on soil tests and plant nutrient needs, our system provides customized fertilizer recommendations to ensure optimal growth while minimizing chemical usage.',
              icon: Icons.eco,
            ),

            // Fertilizer recommendation card
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
                    Text(
                      'Current Fertilizer Recommendation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: Icon(Icons.nature, color: Colors.green),
                      title: Text('Nitrogen (N)'),
                      subtitle: Text('20 kg/acre - Apply within 5 days'),
                    ),
                    ListTile(
                      leading: Icon(Icons.nature, color: Colors.brown),
                      title: Text('Phosphorus (P)'),
                      subtitle: Text('15 kg/acre - Current levels optimal'),
                    ),
                    ListTile(
                      leading: Icon(Icons.nature, color: Colors.purple),
                      title: Text('Potassium (K)'),
                      subtitle: Text('25 kg/acre - Apply within 3 days'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Irrigation'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 105, 188, 255),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Irrigation started')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.schedule),
                    label: const Text('Schedule'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Color(0xFFA3C585),
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

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMetricsCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

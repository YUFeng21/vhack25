// farm_data_provider.dart
import 'package:flutter/foundation.dart';

class FarmDataProvider with ChangeNotifier {
  // Weather data
  final Map<String, dynamic> _currentWeather = {
    'location': 'Cameron Highlands',
    'temp': 24,
    'rainfall': 2.5,
    'windSpeed': 8,
    'condition': 'Partly Cloudy',
    'lastUpdated': '2025-03-25 08:30',
  };

  // Farms data
  final List<Map<String, dynamic>> _farms = [
    {
      'name': 'Tomatoes farm 🍅',
      'location': 'Cameron Highlands',
      'size': '10 acres',
      'crops': ['Tomatoes'],
      'image': 'assets/farm1.jpg',
      'soilMoisture': 72,
      'pH': 6.5,
      'temperature': 28,
      'humidity': 65,
    },
    {
      'name': 'Big Red Strawberries Farm 🍓',
      'location': 'Cameron Highlands',
      'size': '8 acres',
      'crops': ['Strawberries'],
      'image': 'assets/farm2.jpg',
      'soilMoisture': 68,
      'pH': 5.8,
      'temperature': 26,
      'humidity': 70,
    },
    {
      'name': 'Lettuces Farm 🥬',
      'location': 'Cameron Highlands',
      'size': '15 acres',
      'crops': ['Lettuces'],
      'image': 'assets/farm3.jpg',
      'soilMoisture': 75,
      'pH': 6.2,
      'temperature': 25,
      'humidity': 68,
    },
  ];

  // Crops data
  final List<Map<String, dynamic>> _crops = [
    {
      'name': 'Tomatoes',
      'variety': 'Cherry Tomato',
      'farm': 'Tomatoes Farm',
      'planted': 'Mar 15, 2024',
      'status': 'Growing',
      'health': 'Good',
      'image': 'assets/crop1.jpg',
      'healthScore': 85,
      'diseaseRisk': 'Low',
      'growthStage': 'Vegetative',
      'daysToHarvest': 28,
      'recommendations': [
        'Increase watering frequency by 10%',
        'Apply organic fertilizer within 3 days',
        'Monitor for aphids on lower leaves',
      ],
    },
    {
      'name': 'Strawberries',
      'variety': 'Sweet Charlie',
      'farm': 'Big Red Strawberries Farm',
      'planted': 'Feb 05, 2024',
      'status': 'Flowering',
      'health': 'Good',
      'image': 'assets/crop2.jpg',
      'healthScore': 88,
      'diseaseRisk': 'Low',
      'growthStage': 'Flowering',
      'daysToHarvest': 14,
      'recommendations': [
        'Maintain soil moisture at 80%',
        'Apply foliar spray for bloom enhancement',
        'Install bird netting within 7 days',
      ],
    },
    {
      'name': 'Lettuce',
      'variety': 'Romaine',
      'farm': 'Lettuces Farm',
      'planted': 'Mar 20, 2024',
      'status': 'Seedling',
      'health': 'Fair',
      'image': 'assets/crop3.jpg',
      'healthScore': 72,
      'diseaseRisk': 'Moderate',
      'growthStage': 'Early vegetative',
      'daysToHarvest': 35,
      'recommendations': [
        'Improve drainage in rows 3-5',
        'Apply fungicide treatment preventatively',
        'Consider shade cloth during peak sun hours',
      ],
    },
  ];

  // Farm news data
  final List<Map<String, dynamic>> _farmNews = [
    {
      'title': 'New Organic Fertilizer Benefits',
      'description':
          'Research shows 20% yield increase with new organic formula.',
      'image': 'assets/news1.jpg',
      'date': 'Mar 21, 2025',
    },
    {
      'title': 'Sustainable Irrigation Methods',
      'description':
          'Water consumption reduced by 30% with smart drip systems.',
      'image': 'assets/news2.png',
      'date': 'Mar 20, 2025',
    },
    {
      'title': 'Pest Control Innovation',
      'description': 'New eco-friendly approach to combat common crop pests.',
      'image': 'assets/news3.png',
      'date': 'Mar 19, 2025',
    },
  ];

  // Getters
  Map<String, dynamic> get currentWeather => _currentWeather;
  List<Map<String, dynamic>> get farms => _farms;
  List<Map<String, dynamic>> get crops => _crops;
  List<Map<String, dynamic>> get farmNews => _farmNews;

  // Get farm by index (for home screen)
  Map<String, dynamic> getFarmByIndex(int index) {
    if (index >= 0 && index < _farms.length) {
      return _farms[index];
    }
    return {};
  }

  // Get crop by index (for home screen)
  Map<String, dynamic> getCropByIndex(int index) {
    if (index >= 0 && index < _crops.length) {
      return _crops[index];
    }
    return {};
  }
}

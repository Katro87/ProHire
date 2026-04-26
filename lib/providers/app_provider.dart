import 'package:flutter/material.dart';
import '../../data/models/professional_model.dart';
import '../../data/mock/mock_data.dart';

class AppProvider extends ChangeNotifier {
  // Theme Mode
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Professionals
  List<Professional> _professionals = [];
  List<Professional> get professionals => _professionals;
  
  List<Professional> _filteredProfessionals = [];
  List<Professional> get filteredProfessionals => 
      _filteredProfessionals.isEmpty ? _professionals : _filteredProfessionals;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Categories
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  // Hire History
  List<HireRequest> _hireHistory = [];
  List<HireRequest> get hireHistory => _hireHistory;

  // Selected Professional for viewing
  Professional? _selectedProfessional;
  Professional? get selectedProfessional => _selectedProfessional;

  // Initialize with mock data
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    _professionals = MockData.professionals;
    _categories = MockData.categories;
    _hireHistory = MockData.hireHistory;
    _filteredProfessionals = _professionals;

    _isLoading = false;
    notifyListeners();
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Search professionals
  void searchProfessionals(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProfessionals = _professionals.where((prof) {
      final matchesCategory = _selectedCategory == 'All' || 
          prof.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          prof.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prof.profession.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          prof.skills.any((skill) => 
              skill.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  // Select professional for detail view
  void selectProfessional(Professional professional) {
    _selectedProfessional = professional;
    notifyListeners();
  }

  // Add hire request
  void addHireRequest(HireRequest request) {
    _hireHistory.insert(0, request);
    notifyListeners();
  }

  // Update hire status
  void updateHireStatus(String requestId, String newStatus) {
    final index = _hireHistory.indexWhere((h) => h.id == requestId);
    if (index != -1) {
      final oldRequest = _hireHistory[index];
      _hireHistory[index] = HireRequest(
        id: oldRequest.id,
        professional: oldRequest.professional,
        hireDate: oldRequest.hireDate,
        message: oldRequest.message,
        status: newStatus,
        createdAt: oldRequest.createdAt,
      );
      notifyListeners();
    }
  }

  // Get professionals by category
  List<Professional> getProfessionalsByCategory(String category) {
    if (category == 'All') return _professionals;
    return _professionals.where((p) => p.category == category).toList();
  }

  // Get featured professionals (top rated)
  List<Professional> get featuredProfessionals {
    final sorted = List<Professional>.from(_professionals);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(6).toList();
  }

  // Bottom Navigation Index
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }
}

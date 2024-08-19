import 'package:flutter/material.dart';
import 'package:markflip/models/banner_model.dart';
import 'package:markflip/services/banner_service.dart';

class BannerProvider extends ChangeNotifier {
  final BannerService _bannerService = BannerService();
  List<BannerModel> _banners = [];
  bool _isLoading = false;

  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;

  Future<void> loadBanners() async {
    try {
      _isLoading = true;
      notifyListeners();

      _banners = await _bannerService.loadBanners();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Handle error
      _isLoading = false;
      notifyListeners();
    }
  }
}

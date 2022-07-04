import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home/home_fragment.dart';
import 'profile/profile_fragment.dart';
import 'transaction/list/transaction_fragment.dart';

class MainViewModel extends GetxController {
  //Bottom Navigation Bar
  int _selectedIndex = 1;
  int get selectedIndex => _selectedIndex;
  void navigateToIndex(int index) {
    _selectedIndex = index;
    switch (_selectedIndex) {
      case 0:
        _selectedFragment = TransactionFragment();
        break;
      case 1:
        _selectedFragment = HomeFragment();
        break;
      case 2:
        _selectedFragment = ProfileFragment();
        break;
      default:
        break;
    }
    update();
  }

  Widget _selectedFragment = HomeFragment();
  Widget get selectedFragment => _selectedFragment;
}

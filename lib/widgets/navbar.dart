import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_firebase_app/screen/home/home.dart';
import 'package:flutter_firebase_app/screen/profile/profil.dart';
import 'package:flutter_firebase_app/screen/transaction.dart';
import 'package:flutter_firebase_app/screen/chat.dart';

class CustomNavBar extends StatefulWidget {
  final int initialIndex;
  
  const CustomNavBar({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return _buildBottomNavBar();
  }

  Widget _buildBottomNavBar() {
    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavItem(0, defaultIcon: 'assets/home_false.svg', selectedIcon: 'assets/home_true.svg'),
          _buildNavItem(1, defaultIcon: 'assets/shop_false.svg', selectedIcon: 'assets/shop_true.svg'),
          _buildNavItem(2, defaultIcon: 'assets/chat_false.svg', selectedIcon: 'assets/chat_true.svg'),
          _buildNavItem(3, defaultIcon: 'assets/akun_false.svg', selectedIcon: 'assets/akun_true.svg'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, {required String defaultIcon, required String selectedIcon}) {
    final bool isSelected = _selectedIndex == index;

    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () {
            // Hanya lakukan navigasi jika tab yang diklik berbeda dengan tab saat ini
            if (_selectedIndex != index) {
              setState(() {
                _selectedIndex = index;
              });
              
              // Buat instance halaman sesuai indeks yang dipilih
              Widget page;
              
              switch (index) {
                case 0:
                  page = HomePage();
                  break;
                case 1:
                  page = const TransactionScreen();
                  break;
                case 2:
                  page = const ChatScreen();
                  break;
                case 3:
                  page = ProfileScreen();
                  break;
                default:
                  page = HomePage();
                  break;
              }
              
              // Navigasi dengan Navigator
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => page),
                (route) => false,
              );
            }
          },
          child: SvgPicture.asset(
            isSelected ? selectedIcon : defaultIcon,
            width: 30,
            height: 30,
          ),
        ),
      ),
    );
  }
}
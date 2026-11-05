import 'package:flutter/material.dart';
import 'package:portfolioapp/presentation/pages/portfolio_page.dart';
import 'package:portfolioapp/presentation/pages/profile.dart';
import 'package:portfolioapp/presentation/widget/floating_bottom_nav_bar.dart';
import 'package:portfolioapp/key.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/presentation/pages/version.dart';
import 'package:portfolioapp/presentation/pages/history.dart';
import 'package:portfolioapp/presentation/pages/loginpage.dart';
import 'package:portfolioapp/presentation/pages/about.dart';
import 'package:portfolioapp/domain/repository/auth_repository.dart';
import 'package:portfolioapp/presentation/widget/app_drawer.dart';
import 'package:portfolioapp/presentation/pages/settings.dart';
import 'package:portfolioapp/presentation/pages/faq.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/data/models/user_model.dart';
import 'package:portfolioapp/data/models/scrip_model.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

var currentIndex = 0;

class _HomepageState extends State<Homepage> {
  String? name;
  String? email;
  String? holdings;
  double currentValue = 0;
  double profit = 0;
  double invested = 0;
  List<ScripModel> scrips = [];

  static const List<FloatingNavItem> _navItems = [
    FloatingNavItem(icon: Icons.pie_chart_rounded, label: 'Portfolio'),
    FloatingNavItem(icon: Icons.add_circle_rounded, label: 'Buy'),
    FloatingNavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  Future<void> getUerData() async {
    setState(() {
      currentValue = 0;
      invested = 0;
      profit = 0;
    });
    final userrepo = s1<UserRepository>();
    UserModel userModel = await userrepo.userData();
    setState(() {
      email = userModel.email;
      name = userModel.name;
      scrips = userModel.scrip;
      for (int i = 0; i < scrips.length; i++) {
        currentValue += scrips[i].total;
        invested += scrips[i].invested;
        profit += scrips[i].currentProfit;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUerData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      PortfolioPage(
        key: portfoliopagekey,
        name: name,
        email: email,
        holdings: holdings,
        currentValue: currentValue,
        invested: invested,
        profit: profit,
        scrips: scrips,
        getUserData: getUerData,
      ),
      SizedBox(),
      ProfilePage(key: profilepagekey, showScaffold: false),
    ];
    return Scaffold(
      appBar: (currentIndex == 0)
          ? AppBar()
          : profilepagekey.currentState?.profilepageAppbar(),
      drawer: AppDrawer(
        name: name,
        email: email,
        onProfile: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ProfilePage(showScaffold: true),
          ),
        ),
        onSettings: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SettingsPage(userName: name, email: email),
          ),
        ),
        onHistory: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => History()),
        ),
        onAboutApp: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => About()),
        ),
        onFaq: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Faq()),
        ),
        onLogoutConfirmed: () {
          final authrepo = s1<AuthRepository>();
          authrepo.googleSignOut();
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Loginpage()),
            );
          }
        },

        onVersion: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Version()),
        ),
      ),
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: FloatingBottomNavBar(
        items: _navItems,
        selectedIndex: currentIndex,
        onTap: (x) {
          if (x == 1) {
            portfoliopagekey.currentState?.buymodelButtomSheet();
          } else {
            setState(() {
              currentIndex = x;
            });
          }
        },
      ),
    );
  }
}

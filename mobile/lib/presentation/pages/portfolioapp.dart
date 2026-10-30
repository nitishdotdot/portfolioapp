import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/data/datasource/local/localstorage.dart';
import 'package:portfolioapp/data/models/scrip_model.dart';
import 'package:portfolioapp/data/models/user_model.dart';
import 'package:portfolioapp/data/repository/auth_repository_impl.dart';
import 'package:portfolioapp/domain/api/user_api.dart';
import 'package:portfolioapp/domain/repository/auth_repository.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/main.dart';
import 'package:portfolioapp/presentation/bloc/login_bloc.dart';
import 'package:portfolioapp/presentation/bloc/login_event.dart';
import 'package:portfolioapp/presentation/bloc/login_state.dart';
import 'package:portfolioapp/presentation/pages/faq.dart';
import 'package:portfolioapp/presentation/pages/history.dart';
import 'package:portfolioapp/presentation/pages/loginpage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:portfolioapp/presentation/pages/profile.dart';
import 'package:portfolioapp/presentation/pages/settings.dart';
import 'package:portfolioapp/presentation/pages/version.dart';

// New presentation-only files
import 'package:portfolioapp/presentation/widget/floating_bottom_nav_bar.dart';
import 'package:portfolioapp/presentation/widget/portfolio_graph.dart';
import 'package:portfolioapp/presentation/widget/swipeable_scrip_card.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart';
import 'package:portfolioapp/presentation/widget/app_drawer.dart';
import 'package:portfolioapp/presentation/widget/trade_sheet.dart';

class Portfolioapp extends StatefulWidget {
  const Portfolioapp({super.key});

  @override
  State<Portfolioapp> createState() => _PortfolioappState();
}

class _PortfolioappState extends State<Portfolioapp> {
  final userApi = s1<UserApi>();

  TextEditingController name1 = TextEditingController();
  TextEditingController kitta1 = TextEditingController();
  TextEditingController buyprice1 = TextEditingController();
  String? token;
  String? email;
  int? l;
  String? name;
  DateTime? datetime;
  String? date;
  String? holdings;
  double currentValue = 0;
  double profit = 0;
  double invested = 0;
  List<ScripModel> scrips = [];

  // UI-only: selected tab in the floating navigation bar.
  int currentIndex = 0;

  static const List<FloatingNavItem> _navItems = [
    FloatingNavItem(icon: Icons.pie_chart_rounded, label: 'Portfolio'),
    FloatingNavItem(icon: Icons.add_circle_rounded, label: 'Buy'),
    FloatingNavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    getUerData();
  }

  Future<bool> deletescrip(String scripname) async {
    final userapi = s1<UserRepository>();
    return await userapi.deletescrip(scripname);
  }

  // ---------------------------------------------------------------------
  // Existing buy / sell sheets: UNCHANGED
  // ---------------------------------------------------------------------

  void sellmodelButtomSheet() {
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                10,
                10,
                10,
                MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: TradeSheet(
                  isBuy: false,
                  nameController: name1,
                  quantityController: kitta1,
                  priceController: buyprice1,
                  dateText: datetime == null
                      ? 'Select date'
                      : datetime.toString().split(' ')[0],
                  onPickDate: () async {
                    datetime =
                        await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        ) ??
                        DateTime.now();
                    setState(() {
                      date = (datetime ?? DateTime.now())
                          .toUtc()
                          .toIso8601String();
                    });
                    setSheetState(() {}); // refresh the date label in the sheet
                  },
                  onSubmit: () async {
                    final userrepo = s1<UserRepository>();
                    bool responce = await userrepo.sellUser(
                      name1.text,
                      int.parse(kitta1.text),
                      int.parse(buyprice1.text),
                      (datetime ?? DateTime.now()).toUtc().toIso8601String(),
                    );
                    if (context.mounted) {
                      if (responce == true) {
                        getUerData();
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              content: Text('error in selling'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ok'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void buymodelButtomSheet() {
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                10,
                10,
                10,
                MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: TradeSheet(
                  isBuy: true,
                  nameController: name1,
                  quantityController: kitta1,
                  priceController: buyprice1,
                  dateText: datetime == null
                      ? 'Select date'
                      : datetime.toString().split(' ')[0],
                  onPickDate: () async {
                    datetime =
                        await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        ) ??
                        DateTime.now();
                    setState(() {
                      date = (datetime ?? DateTime.now())
                          .toUtc()
                          .toIso8601String();
                    });
                    setSheetState(() {}); // refresh the date label in the sheet
                  },
                  onSubmit: () async {
                    final userrepo = s1<UserRepository>();
                    bool responce = await userrepo.addUser(
                      name1.text,
                      int.parse(kitta1.text),
                      int.parse(buyprice1.text),
                      (datetime ?? DateTime.now()).toUtc().toIso8601String(),
                    );
                    if (context.mounted) {
                      if (responce == true) {
                        getUerData();
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              content: Text('error in buying'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ok'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void getUerData() async {
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

  void refresh() {
    setState(() {
      currentValue = 0;
      invested = 0;
      profit = 0;
    });
    getUerData();
  }

  // Existing long-press delete flow, moved into a method (logic unchanged).
  void confirmDeleteScrip(String scripName) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure to delete this scrip'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final deleted = await deletescrip(scripName);
                      if (context.mounted) {
                        if (deleted) {
                          refresh();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('error in deleting scrip')),
                          );
                        }
                      }
                    },
                    child: Text('yes'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('no'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final w = s.width;
    final pad = pagePadding(w);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              refresh();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      drawer: AppDrawer(
        name: name,
        email: email,
        onProfile: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => ProfilePage()),
        ),
        onSettings: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SettingsPage()),
        ),
        onHistory: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => History()),
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

      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          // Keeps the dashboard readable on tablets / wide windows.
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(pad, 4, pad, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: scrips.length + 3,
            itemBuilder: (BuildContext context, int i) {
              if (i == 0) {
                // Portfolio totals are not exposed by the existing code, so
                // they are left null (shown as an em dash). Pass your existing
                // already-formatted values here when you have them.
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: PortfolioSummaryCard(
                    userName: name,
                    holdingsCount: scrips.length,
                    currentValueText: currentValue.toStringAsFixed(3),
                    investedText: invested.toStringAsFixed(3),
                    profitText: profit.toStringAsFixed(3),
                    profitValue: profit.toStringAsFixed(3),
                    profitpercent: (profit * 100 / invested).toStringAsFixed(3),
                  ),
                );
              }
              if (i == 1) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: PortfolioGraph(),
                );
              }
              if (i == 2) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SectionHeader(
                    title: 'My Holdings',
                    trailing: Text(
                      'Swipe → Buy   ← Sell',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(130),
                      ),
                    ),
                  ),
                );
              }

              final scrip = scrips[i - 3];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SwipeableScripCard(
                  // Existing handlers, reused as-is. Swiping only opens the
                  // sheet; nothing is submitted until the user confirms there.
                  onBuy: buymodelButtomSheet,
                  onSell: sellmodelButtomSheet,
                  onLongPress: () => confirmDeleteScrip(scrip.name),
                  child: ScripInfoCard(
                    name: scrip.name,
                    companyName: scrip.companyName,
                    kitta: scrip.kitta,
                    wacc: scrip.wacc,
                    total: scrip.total.toStringAsFixed(3),
                    ltp: scrip.ltp,
                    currentProfit: scrip.currentProfit.toStringAsFixed(3),
                    percentprofit:
                        (scrip.currentProfit.toDouble() * 100 / scrip.invested)
                            .toStringAsFixed(3),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: FloatingBottomNavBar(
        items: _navItems,
        selectedIndex: currentIndex,
        onTap: (x) {
          // Same behaviour as before: only the middle tab opens the buy sheet.
          if (x == 1) {
            buymodelButtomSheet();
          } else if (x == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage()),
            );
          } else {
            setState(() => currentIndex = x);
          }
        },
      ),
    );
  }
}

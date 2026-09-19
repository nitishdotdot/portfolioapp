import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:portfolioapp/presentation/pages/loginpage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:portfolioapp/presentation/pages/profile_page.dart';
import 'package:portfolioapp/presentation/widget/card.dart';

class Portfolioapp extends StatefulWidget {
  const Portfolioapp({super.key});

  @override
  State<Portfolioapp> createState() => _PortfolioappState();
}

class _PortfolioappState extends State<Portfolioapp> {
  final userApi = s1<UserApi>();
  String? token;
  String? email;
  int? l;
  String? name;
  List<ScripModel> scrips = [];
  @override
  void initState() {
    super.initState();
    getUerData();
  }

  void getUerData() async {
    final userrepo = s1<UserRepository>();
    UserModel userModel = await userrepo.userData();
    setState(() {
      email = userModel.email;
      name = userModel.name;
      scrips = userModel.scrip;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final w = s.width;
    final h = s.height;
    int currentIndex = 0;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        width: w * .9,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(10, 40, 0, 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            content: Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Are you sure'),
                                  ElevatedButton(
                                    onPressed: () {
                                      final authrepo = s1<AuthRepository>();
                                      authrepo.googleSignOut();
                                      if (context.mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => Loginpage(),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text('ok'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.logout),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Image.network(),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  ],
                ),
                Divider(thickness: 2),
                ListTile(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ProfilePage(),
                    ),
                  ),
                  leading: Icon(Icons.person),
                  title: Text('$name'),
                  subtitle: Text('$email'),
                ),
                Divider(thickness: 2),
                Align(alignment: Alignment.topLeft, child: Text('Seetings')),
                ListTile(leading: Icon(Icons.settings), title: Text('setting')),
                Divider(thickness: 2),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('My Portfolio'),
                ),
                ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text('My Shares'),
                ),
                ListTile(leading: Icon(Icons.history), title: Text('History')),
                Divider(thickness: 2),
                Align(alignment: Alignment.topLeft, child: Text('About ')),
                ListTile(
                  leading: Icon(Icons.question_mark_sharp),
                  title: Text('Faqs'),
                ),
                ListTile(
                  leading: Icon(Icons.phone_android),
                  title: Text('About'),
                ),
                ListTile(leading: Icon(Icons.android), title: Text('Version')),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: scrips.length + 1,
                itemBuilder: (BuildContext context, int i) {
                  if (i == 0) {
                    return Card(
                      color: Colors.pink,
                      child: SizedBox(width: w, height: h * .2),
                    );
                  }
                  return MyCard(
                    child: ListTile(
                      leading: Icon(Icons.house),
                      title: Text('${scrips[i - 1].name}'),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('unit= ${scrips[i - 1].kitta}'),
                          Text(
                            'buydate=${scrips[i - 1].buydatetime.split('T')[0]}',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (x) {
          if (x == 1) {
            setState(() {
              currentIndex = x;
            });
            showModalBottomSheet(
              enableDrag: true,
              showDragHandle: true,
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Center();
              },
            );
          }
        },
        backgroundColor: Colors.red.withAlpha(50),
        elevation: 10,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

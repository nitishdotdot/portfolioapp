import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/data/datasource/local/localstorage.dart';
import 'package:portfolioapp/data/models/alluser_model.dart';
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

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final userApi = s1<UserApi>();
  String? token;
  List<AlluserModel> allUser = [];
  int? l;
  String? name;
  String? email;
  DateTime? datetime;
  String? date;
  List<ScripModel> scrips = [];
  @override
  void initState() {
    super.initState();
    getUerData();
  }

  void getUerData() async {
    final userrepo = s1<UserRepository>();
    List<AlluserModel> alluser = await userrepo.getallUser();
    UserModel user = await userrepo.userData();
    setState(() {
      allUser = alluser;
      name = user.name;
      email = user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final w = s.width;
    final h = s.height;
    TextEditingController name1 = TextEditingController();
    TextEditingController kitta1 = TextEditingController();
    TextEditingController buyprice1 = TextEditingController();

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
                itemCount: allUser.length + 1,
                itemBuilder: (BuildContext context, int i) {
                  if (i == 0) {
                    return Card(
                      color: Colors.green,
                      child: SizedBox(width: w, height: h * .2),
                    );
                  }
                  return MyCard(
                    child: ListTile(
                      leading: Icon(Icons.house),
                      title: Text(allUser[i - 1].name),
                      subtitle: Text(allUser[i - 1].email),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

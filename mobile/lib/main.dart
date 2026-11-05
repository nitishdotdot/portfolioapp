import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolioapp/core/di/injection_container.dart' as d;
import 'package:portfolioapp/presentation/bloc/login_bloc.dart';
import 'package:portfolioapp/presentation/pages/loginpage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  d.init();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => LoginBloc())],
      child: MaterialApp(
        title: 'PortfolioApp',
        navigatorKey: navigatorkey,
        home: Loginpage(),
      ),
    );
  }
}

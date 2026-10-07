import 'package:portfolioapp/data/models/alluser_model.dart';
import 'package:portfolioapp/data/models/sell_scrip_history_model.dart';
import 'package:portfolioapp/data/models/user_model.dart';
import 'package:portfolioapp/data/models/buy_scrip_history_model.dart';

abstract class UserRepository {
  Future<UserModel> userData();
  Future<bool> deleteuser();
  Future<bool> addUser(
    String name,
    int kitta,
    int buyprice,
    String buydatetime,
  );
  Future<List<AlluserModel>> getallUser();
  Future<bool> sellUser(
    String name,
    int kitta,
    int sellprice,
    String selldatetime,
  );

  Future<bool> deletescrip(String name);
  Future<List<BuyScripHistoryModel>> buyscripHistory();
  Future<List<SellScripHistoryModel>> sellScripHistory();
}

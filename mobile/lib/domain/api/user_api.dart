import 'package:portfolioapp/data/models/alluser_model.dart';
import 'package:portfolioapp/data/models/sell_scrip_history_model.dart';
import 'package:portfolioapp/data/models/user_model.dart';
import 'package:portfolioapp/data/models/buy_scrip_history_model.dart';

abstract class UserApi {
  Future<UserModel> userDataApi();
  Future<bool> deleteaUserApi();
  Future<bool> addUserApi(String name, int kitta, int buyprice, String buytime);

  Future<bool> sellUserApi(
    String name,
    int kitta,
    int sellprice,
    String selltime,
  );
  Future<List<AlluserModel>> getallUserApi();
  Future<bool> deletescrip(String scripname);
  Future<List<BuyScripHistoryModel>> buyscripHistoryApi();
  Future<List<SellScripHistoryModel>> sellScripHistoryApi();
}

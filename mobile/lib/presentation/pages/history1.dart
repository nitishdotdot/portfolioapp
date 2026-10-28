import 'package:flutter/material.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/data/models/buy_scrip_history_model.dart';
import 'package:portfolioapp/data/models/sell_scrip_history_model.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/presentation/pages/portfolioapp.dart';
import 'package:portfolioapp/presentation/widget/card.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<BuyScripHistoryModel> buyscriphistory = [];
  List<SellScripHistoryModel> sellscriphistory = [];
  @override
  void initState() {
    super.initState();
    buyHistory();
    sellHistory();
    setState(() {
      i = 0;
    });
  }

  void buyHistory() async {
    final userrepo = s1<UserRepository>();
    List<BuyScripHistoryModel> buyHistory = await userrepo.buyscripHistory();
    print(buyHistory.length);
    setState(() {
      buyscriphistory = buyHistory;
    });
  }

  void sellHistory() async {
    final userrepo = s1<UserRepository>();
    List<SellScripHistoryModel> sellScrip = await userrepo.sellScripHistory();
    setState(() {
      sellscriphistory = sellScrip;
    });
  }

  int? i;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Portfolioapp()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          MyCard(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      i = 1;
                    });
                  },
                  child: Text('BUY'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      i = 2;
                    });
                  },
                  child: Text('SELL'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      i = 0;
                    });
                  },
                  child: Text('ALL'),
                ),
              ],
            ),
          ),
        ],
        title: Text('History'),
      ),
      body: IndexedStack(
        index: i,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: buyscriphistory.length,
                  itemBuilder: (BuildContext context, int i) {
                    final item = buyscriphistory[i];
                    return MyCard(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.kitta.toString()),
                            Text(item.buyprice.toString()),
                            Text(item.buydatetime.toString().split('T')[0]),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sellscriphistory.length,
                  itemBuilder: (BuildContext context, int i) {
                    final item = sellscriphistory[i];
                    return MyCard(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.kitta.toString()),
                            Text(item.sellpice.toString()),
                            Text(item.selldatetime.toString().split('T')[0]),
                            Text(item.profit.toString()),
                            Text(item.total.toString()),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: buyscriphistory.length,
            itemBuilder: (BuildContext context, int i) {
              final item = buyscriphistory[i];
              return MyCard(
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.kitta.toString()),
                      Text(item.buyprice.toString()),
                      Text(item.buydatetime.toString().split('T')[0]),
                    ],
                  ),
                ),
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: sellscriphistory.length,
            itemBuilder: (BuildContext context, int i) {
              final item = sellscriphistory[i];
              return MyCard(
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.kitta.toString()),
                      Text(item.sellpice.toString()),
                      Text(item.selldatetime.toString().split('T')[0]),
                      Text(item.profit.toString()),
                      Text(item.total.toString()),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/data/models/buy_scrip_history_model.dart';
import 'package:portfolioapp/data/models/sell_scrip_history_model.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/presentation/pages/portfolioapp.dart';
import 'package:portfolioapp/presentation/widget/history_widgets.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<BuyScripHistoryModel> buyscriphistory = [];
  List<SellScripHistoryModel> sellscriphistory = [];

  // 0 = ALL, 1 = BUY, 2 = SELL (same meaning as before).
  int i = 0;

  @override
  void initState() {
    super.initState();
    buyHistory();
    sellHistory();
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

  @override
  Widget build(BuildContext context) {
    final pad = pagePadding(MediaQuery.of(context).size.width);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Portfolioapp()),
            );
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                // The old BUY / SELL / ALL buttons now live here, right under
                // the app bar, as one animated switch.
                Padding(
                  padding: EdgeInsets.fromLTRB(pad, 4, pad, 8),
                  child: HistoryFilterBar(
                    selected: i,
                    onChanged: (v) => setState(() => i = v),
                    buyCount: buyscriphistory.length,
                    sellCount: sellscriphistory.length,
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOutCubic,
                    child: _buildContent(pad),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(double pad) {
    final showBuy = i == 0 || i == 1;
    final showSell = i == 0 || i == 2;
    final hasBuy = showBuy && buyscriphistory.isNotEmpty;
    final hasSell = showSell && sellscriphistory.isNotEmpty;

    if (!hasBuy && !hasSell) {
      return HistoryEmptyState(
        key: ValueKey('empty$i'),
        message: i == 1
            ? 'No buy history yet'
            : i == 2
            ? 'No sell history yet'
            : 'No history yet',
      );
    }

    return CustomScrollView(
      key: ValueKey('list$i'),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (hasBuy) ...[
          if (i == 0)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(pad, 8, pad, 10),
                child: SectionHeader(
                  title: 'Buy',
                  trailing: Text('${buyscriphistory.length}'),
                ),
              ),
            ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(pad, i == 0 ? 0 : 8, pad, 0),
            sliver: SliverList.builder(
              itemCount: buyscriphistory.length,
              itemBuilder: (BuildContext context, int index) {
                final item = buyscriphistory[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BuyHistoryCard(
                    name: item.name,
                    kitta: item.kitta.toString(),
                    price: item.buyprice.toString(),
                    date: item.buydatetime.toString().split('T')[0],
                  ),
                );
              },
            ),
          ),
        ],
        if (hasSell) ...[
          if (i == 0)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(pad, 12, pad, 10),
                child: SectionHeader(
                  title: 'Sell',
                  trailing: Text('${sellscriphistory.length}'),
                ),
              ),
            ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(pad, i == 0 ? 0 : 8, pad, 0),
            sliver: SliverList.builder(
              itemCount: sellscriphistory.length,
              itemBuilder: (BuildContext context, int index) {
                final item = sellscriphistory[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SellHistoryCard(
                    name: item.name,
                    kitta: item.kitta.toString(),
                    price: item.sellpice.toString(),
                    date: item.selldatetime.toString().split('T')[0],
                    profit: item.profit.toString(),
                    total: item.total.toString(),
                    profitPercent: item.profitPercent,
                  ),
                );
              },
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/presentation/widget/brokerage_widgets.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart'; // AppColors, pagePadding
import 'package:portfolioapp/presentation/widget/faq_widgets.dart'; // FaqStateMessage

/// Values exactly as they come from the API, kept as text for display.
class BrokerageRates {
  const BrokerageRates({
    required this.sebonCommission,
    required this.brokerCommission,
    required this.dpCharge,
    required this.shortTermTax,
    required this.longTermTax,
  });

  final String sebonCommission; // sebComm
  final String brokerCommission; // brComm
  final String dpCharge; // dpCharge
  final String shortTermTax; // shortTax
  final String longTermTax; // longTax
}

class Brokerage extends StatefulWidget {
  const Brokerage({super.key});

  @override
  State<Brokerage> createState() => _BrokerageState();
}

class _BrokerageState extends State<Brokerage> {
  BrokerageRates? _rates; // null until the API answers
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBrokerage();
  }

  Future<void> _loadBrokerage() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final userRepository = s1<UserRepository>();
      final data = await userRepository.brokerage();
      if (!mounted) return;

      // Field names follow the API keys. If your model uses other names,
      // change them here (only this block needs editing).
      _rates = BrokerageRates(
        sebonCommission: '${data.sebComm}',
        brokerCommission: '${data.brComm}',
        dpCharge: '${data.dpCharge}',
        shortTermTax: '${data.shortTax}',
        longTermTax: '${data.longTax}',
      );
      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text(
        'Brokerage & fees',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
    );

    if (_loading) {
      return Scaffold(
        appBar: appBar,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.brandStart),
        ),
      );
    }

    if (_error != null || _rates == null) {
      return Scaffold(
        appBar: appBar,
        body: FaqStateMessage(
          icon: Icons.wifi_off_rounded,
          color: AppColors.loss,
          title: 'Could not load charges',
          subtitle: 'Check your connection and try again.',
          actionLabel: 'Retry',
          onAction: _loadBrokerage,
        ),
      );
    }

    final r = _rates!;
    final pad = pagePadding(MediaQuery.of(context).size.width);

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.brandStart,
          onRefresh: _loadBrokerage,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(pad, 12, pad, 32),
            children: [
              const BrokerageHeaderCard(),
              const SizedBox(height: 20),

              BrokerageGroupCard(
                title: 'Transaction charges',
                children: [
                  BrokerageRateTile(
                    icon: Icons.account_balance_rounded,
                    title: 'SEBON commission',
                    description: 'Regulator fee on each transaction',
                    value: '${r.sebonCommission}%',
                    color: AppColors.buy,
                  ),
                  BrokerageRateTile(
                    icon: Icons.handshake_outlined,
                    title: 'Broker commission',
                    description: 'Fee charged by your broker',
                    value: '${r.brokerCommission}%',
                    color: AppColors.brandStart,
                  ),
                  BrokerageRateTile(
                    icon: Icons.inventory_2_outlined,
                    title: 'DP charge',
                    description: 'Depository participant fee',
                    value: 'Rs. ${r.dpCharge}',
                    color: AppColors.brandEnd,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              BrokerageGroupCard(
                title: 'Capital gains tax',
                children: [
                  BrokerageRateTile(
                    icon: Icons.trending_up_rounded,
                    title: 'Short-term tax',
                    description: 'On profit from shares held for a short time',
                    value: '${r.shortTermTax}%',
                    color: AppColors.loss,
                  ),
                  BrokerageRateTile(
                    icon: Icons.hourglass_bottom_rounded,
                    title: 'Long-term tax',
                    description: 'On profit from shares held for a long time',
                    value: '${r.longTermTax}%',
                    color: AppColors.profit,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const BrokerageNote(
                text:
                    'These rates are set by the server. Percentages apply to '
                    'the transaction amount (or profit, for tax); the DP charge '
                    'is a flat amount.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

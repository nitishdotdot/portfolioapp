import 'package:flutter/material.dart';
import 'package:portfolioapp/core/di/injection_container.dart';
import 'package:portfolioapp/data/models/faq_model.dart';
import 'package:portfolioapp/domain/repository/user_repository.dart';
import 'package:portfolioapp/presentation/widget/faq_widgets.dart';
import 'package:portfolioapp/presentation/widget/widgets.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  List<FaqModel> _all = [];
  String _query = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFaq();
  }

  Future<void> _loadFaq() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final userRepository = s1<UserRepository>();
      final data = await userRepository.faq();
      if (!mounted) return; // page was closed while waiting
      setState(() {
        _all = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<FaqModel> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _all;
    return _all
        .where(
          (f) =>
              f.question.toLowerCase().contains(q) ||
              f.answer.toLowerCase().contains(q),
        )
        .toList();
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.brandStart),
      );
    }
    if (_error != null) {
      return FaqStateMessage(
        icon: Icons.wifi_off_rounded,
        color: AppColors.loss,
        title: 'Could not load FAQs',
        subtitle: 'Check your connection and try again.',
        actionLabel: 'Retry',
        onAction: _loadFaq,
      );
    }

    final items = _filtered;
    if (items.isEmpty) {
      return FaqStateMessage(
        icon: Icons.search_off_rounded,
        title: _query.isEmpty ? 'No FAQs yet' : 'No results',
        subtitle: _query.isEmpty
            ? 'Questions will appear here soon.'
            : 'Try a different word.',
      );
    }

    return RefreshIndicator(
      color: AppColors.brandStart,
      onRefresh: _loadFaq,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          pagePadding(MediaQuery.of(context).size.width),
          4,
          pagePadding(MediaQuery.of(context).size.width),
          32,
        ),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => FaqTile(
          index: i + 1,
          question: items[i].question,
          answer: items[i].answer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pad = pagePadding(MediaQuery.of(context).size.width);
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        // Default back arrow is used: it pops back to the previous page.
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(pad, 8, pad, 12),
              child: FaqSearchField(
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }
}

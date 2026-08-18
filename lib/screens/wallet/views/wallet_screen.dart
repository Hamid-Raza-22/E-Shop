import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/repositories/wallet_repository.dart';
import 'package:shop/utils/formatters.dart';

import 'components/wallet_balance_card.dart';
import 'components/wallet_history_card.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  /// Preset top-up amounts offered in the charge-balance sheet.
  static const List<double> _topUpAmounts = [25, 50, 100, 250];

  Future<void> _chargeBalance(BuildContext context) async {
    final amount = await showModalBottomSheet<double>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorderRadious * 2),
          topRight: Radius.circular(defaultBorderRadious * 2),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(
                "Charge balance",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            ..._topUpAmounts.map(
              (amount) => Column(
                children: [
                  ListTile(
                    title: Text(formatPrice(amount)),
                    onTap: () => Navigator.pop(context, amount),
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );

    if (amount == null || !context.mounted) return;
    WalletRepository.instance.topUp(amount);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${formatPrice(amount)} added to your wallet")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository = WalletRepository.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: ListenableBuilder(
            listenable: repository,
            builder: (context, _) {
              final transactions = repository.transactions;

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    sliver: SliverToBoxAdapter(
                      child: WalletBalanceCard(
                        balance: repository.balance,
                        onTabChargeBalance: () => _chargeBalance(context),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: defaultPadding / 2),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        "Wallet history",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  if (transactions.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding * 2),
                        child: Text(
                          "No wallet activity yet.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final transaction = transactions[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: defaultPadding),
                            child: WalletHistoryCard(
                              isReturn: transaction.isReturn,
                              date: formatDate(transaction.date).toUpperCase(),
                              amount: transaction.amount,
                              products: transaction.products,
                            ),
                          );
                        },
                        childCount: transactions.length,
                      ),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: defaultPadding),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

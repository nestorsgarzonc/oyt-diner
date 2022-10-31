import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/utils/currency_formatter.dart';
import 'package:restaurants/core/utils/formatters.dart';
import 'package:restaurants/features/orders/provider/orders_provider.dart';
import 'package:restaurants/ui/widgets/backgrounds/animated_background.dart';
import 'package:restaurants/ui/widgets/buttons/custom_elevated_button.dart';

class BillScreen extends ConsumerStatefulWidget {
  const BillScreen({required this.transactionId, super.key});

  final String transactionId;

  static const route = '/individual_pay_screen';

  @override
  ConsumerState<BillScreen> createState() => _BillScreen();
}

class _BillScreen extends ConsumerState<BillScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).getOrderById(widget.transactionId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(ordersProvider);
    return AnimatedBackground(
      child: orderState.order.on(
        onData: (data) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                children: [
                  Row(
                    children: [
                      Image.network(
                        data.restaurantLogo,
                        height: 30,
                        width: 110,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.restaurantName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(Formatters.dateFormatter(data.createdAt))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  const Text('Productos por usuario:', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  ...data.usersOrder
                      .map(
                        (e) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${e.firstName} ${e.lastName}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                ...e.orderProducts
                                    .map(
                                      (op) => Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(op.name),
                                              Text('\$ ${CurrencyFormatter.format(op.price)}')
                                            ],
                                          ),
                                          if (op.getToppingOptions.isNotEmpty)
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                const Text('Toppings:'),
                                                const SizedBox(height: 5),
                                                ...op.getToppingOptions.map(
                                                  (e) => Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Flexible(child: Text(' - ${e.name}')),
                                                      Text(
                                                        '\$ ${CurrencyFormatter.format(e.price)}',
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Iva:'),
                      Text('\$ ${CurrencyFormatter.format(data.totalPrice * 19 / 100)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Propina:'),
                      Text('\$ ${CurrencyFormatter.format(data.totalPrice * data.tip / 100)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '\$ ${CurrencyFormatter.format(data.totalPrice)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      onPressed: handleOnContinue,
                      child: const Text('Continuar'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
        onError: (error) => Center(child: Text('$error')),
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onInitial: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void handleOnContinue() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

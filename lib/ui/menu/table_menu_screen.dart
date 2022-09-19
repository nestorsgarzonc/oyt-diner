import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurants/core/constants/lotti_assets.dart';
import 'package:restaurants/features/auth/provider/auth_provider.dart';
import 'package:restaurants/features/table/provider/table_provider.dart';
import 'package:restaurants/ui/widgets/buttons/custom_elevated_button.dart';

class TableMenuScreen extends ConsumerWidget {
  const TableMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableProv = ref.watch(tableProvider);
    final authProv = ref.watch(authProvider);

    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mesa:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                Text(
                  tableProv.tableCode ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Lottie.asset(
                        LottieAssets.ordering,
                        width: 140,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Estado',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Ordenando...'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: [
                      authProv.user.on(
                        onData: (user) => ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            '${user.firstName} ${user.lastName} (Tu)',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        onError: (e) => Center(child: Text(e.message)),
                        onLoading: () => const Center(child: CircularProgressIndicator()),
                        onInitial: () => const Center(child: CircularProgressIndicator()),
                      ),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   primary: false,
                      //   itemCount: 1,
                      //   itemBuilder: (context, index) =>  ProductItemCard(),
                      // ),
                      ...List.generate(
                        3,
                        (index) => Column(
                          children: const [
                            ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text('Someone...'),
                            ),
                            // ListView.builder(
                            //   shrinkWrap: true,
                            //   primary: false,
                            //   itemCount: index + 1,
                            //   itemBuilder: (context, index) => const ProductItemCard(),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 5,
            left: 20,
            right: 20,
            child: CustomElevatedButton(
              onPressed: handleOnOrderNow,
              child: const Text('Ordenar ahora'),
            ),
          ),
        ],
      ),
    );
  }

  void handleOnOrderNow() {}
}

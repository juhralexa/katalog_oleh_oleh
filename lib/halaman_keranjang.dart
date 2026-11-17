
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import 'data.dart';
import 'keranjang_cubit.dart';

class HalamanKeranjang extends StatelessWidget {
  const HalamanKeranjang({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<KeranjangCubit, KeranjangState>(
      listenWhen: (sebelum, sesudah) => sesudah.pesananDibuat,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan dibuat (simulasi)'),
          ),
        );
      },
      child: BlocBuilder<KeranjangCubit, KeranjangState>(
        builder: (context, state) {
          final item = state.item;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Keranjang'),
            ),
            body: item.isEmpty
                ? const Center(
                    child: Text('Keranjang masih kosong'),
                  )
                : ListView.separated(
                    itemCount: item.length,
                    separatorBuilder: (context, i) =>
                        const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final it = item[i];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(it.produk.gambar),
                        ),
                        title: Text(it.produk.nama),
                        subtitle: Text(it.subtotal.rupiah),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => context
                                  .read<KeranjangCubit>()
                                  .kurangi(it.produk),
                            ),
                            Text('${it.jumlah}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => context
                                  .read<KeranjangCubit>()
                                  .tambah(it.produk),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            bottomNavigationBar: item.isEmpty
                ? null
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total ${state.total.rupiah}',
                              style: Theme.of(context)
                                  .textTheme.titleMedium,
                            ),
                          ),
                          FilledButton(
                            onPressed: () => context
                                .read<KeranjangCubit>()
                                .checkout(),
                            child: const Text('Checkout'),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

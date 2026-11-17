import 'package:flutter_test/flutter_test.dart';
import 'package:katalog_oleh_oleh/data.dart';
import 'package:katalog_oleh_oleh/keranjang_cubit.dart';

void main() {
  test('tambah, kurangi, dan checkout memperbarui state', () async {
    final cubit = KeranjangCubit();

    cubit.tambah(daftarProduk[0]); // Kopi Sidikalang 45.000
    cubit.tambah(daftarProduk[0]);
    cubit.tambah(daftarProduk[1]); // Bolu Meranti 80.000

    expect(cubit.state.jumlahItem, 3);
    expect(cubit.state.total, 45000 * 2 + 80000);

    cubit.kurangi(daftarProduk[0]);
    expect(cubit.state.jumlahDari(1), 1);

    cubit.checkout();
    expect(cubit.state.jumlahItem, 0);
    expect(cubit.state.pesananDibuat, isTrue);

    await cubit.close();
  });
}
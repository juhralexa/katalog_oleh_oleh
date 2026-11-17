import 'package:flutter_bloc/flutter_bloc.dart';

import 'data.dart';

class ItemKeranjang {
  const ItemKeranjang(this.produk, this.jumlah);

  final Produk produk;
  final int jumlah;

  int get subtotal => produk.harga * jumlah;
}

// State immutable: setiap perubahan menghasilkan objek state baru
class KeranjangState {
  const KeranjangState([this.isi = const {}, this.pesananDibuat = false]);

  final Map<int, int> isi; // id produk -> jumlah
  final bool pesananDibuat; // true hanya sesaat setelah checkout

  // '!' aman: id hanya masuk ke isi melalui objek Produk yang valid
  List<ItemKeranjang> get item => [
        for (final e in isi.entries) ItemKeranjang(cariProduk(e.key)!, e.value),
      ];

  int get jumlahItem => isi.values.fold(0, (a, b) => a + b);

  int get total => item.fold(0, (s, i) => s + i.subtotal);

  int jumlahDari(int idProduk) => isi[idProduk] ?? 0;
}

class KeranjangCubit extends Cubit<KeranjangState> {
  KeranjangCubit() : super(const KeranjangState());

  void tambah(Produk p) {
    final baru = Map<int, int>.of(state.isi)
      ..update(p.id, (n) => n + 1, ifAbsent: () => 1);
    emit(KeranjangState(baru));
  }

  void kurangi(Produk p) {
    final n = state.isi[p.id];
    if (n == null) return;
    final baru = Map<int, int>.of(state.isi);
    if (n <= 1) {
      baru.remove(p.id);
    } else {
      baru[p.id] = n - 1;
    }
    emit(KeranjangState(baru));
  }

  void kosongkan() => emit(const KeranjangState());

  // Checkout: keranjang kosong, bendera menyala untuk BlocListener
  void checkout() => emit(const KeranjangState({}, true));
}
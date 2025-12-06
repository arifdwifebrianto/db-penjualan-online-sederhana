-- [ADMIN] Tambah Produk Baru
CREATE PROCEDURE sp_tambah_produk(
    IN p_nama VARCHAR(100), IN p_harga DECIMAL(10,2), IN p_stok INT
)
BEGIN
    INSERT INTO produk (nama_produk, harga, stok) VALUES (p_nama, p_harga, p_stok);
END

-- [ADMIN] Tambah Stok Gudang (Supply Masuk)
CREATE PROCEDURE sp_tambah_stok_gudang(IN p_id_produk INT, IN p_jumlah INT)
BEGIN
    UPDATE produk SET stok = stok + p_jumlah WHERE id_produk = p_id_produk;
END

-- [USER] Buat Keranjang/Pesanan Baru
CREATE PROCEDURE sp_buat_pesanan(IN p_id_pembeli INT, OUT p_id_pesanan_baru INT)
BEGIN
    INSERT INTO pesanan (id_pembeli, status_pesanan) VALUES (p_id_pembeli, 'Pending');
    SET p_id_pesanan_baru = LAST_INSERT_ID(); 
END

-- [USER] Masukkan Barang ke Keranjang
CREATE PROCEDURE sp_tambah_item_pesanan(IN p_id_pesanan INT, IN p_id_produk INT, IN p_jumlah INT)
BEGIN
    INSERT INTO item_pesanan (id_pesanan, id_produk, jumlah) 
    VALUES (p_id_pesanan, p_id_produk, p_jumlah);
END

-- [KASIR] Bayar Pesanan
CREATE PROCEDURE sp_bayar_pesanan(IN p_id_pesanan INT)
BEGIN
    UPDATE pesanan 
    SET status_pesanan = 'Dibayar', tanggal_bayar = NOW()
    WHERE id_pesanan = p_id_pesanan;
END

-- [KASIR/USER] Batalkan Pesanan Manual
CREATE PROCEDURE sp_batalkan_pesanan(IN p_id_pesanan INT)
BEGIN
    UPDATE pesanan SET status_pesanan = 'Dibatalkan' WHERE id_pesanan = p_id_pesanan;
END

-- [LAPORAN] Harian
CREATE PROCEDURE sp_laporan_harian(IN p_tanggal DATE)
BEGIN
    SELECT id_pesanan, nama_pembeli, SUM(total_harga_per_item) as total_trx, status_pesanan
    FROM v_laporan_lengkap
    WHERE DATE(tanggal_pesanan) = p_tanggal AND status_pesanan != 'Dibatalkan'
    GROUP BY id_pesanan;
END

-- [LAPORAN] Bulanan
CREATE PROCEDURE sp_laporan_bulanan(IN p_bulan INT, IN p_tahun INT)
BEGIN
    SELECT nama_produk, SUM(jumlah) as terjual, SUM(total_harga_per_item) as omzet
    FROM v_laporan_lengkap
    WHERE MONTH(tanggal_pesanan) = p_bulan AND YEAR(tanggal_pesanan) = p_tahun AND status_pesanan = 'Dibayar'
    GROUP BY nama_produk ORDER BY terjual DESC;
END
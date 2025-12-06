CREATE VIEW v_laporan_lengkap AS
SELECT 
    p.id_pesanan,
    p.tanggal_pesanan,
    p.tanggal_bayar,
    cust.nama_pembeli,
    pr.nama_produk,
    ip.jumlah,
    ip.total_harga_per_item,
    p.status_pesanan
FROM pesanan p
JOIN pembeli cust ON p.id_pembeli = cust.id_pembeli
JOIN item_pesanan ip ON p.id_pesanan = ip.id_pesanan
JOIN produk pr ON ip.id_produk = pr.id_produk;
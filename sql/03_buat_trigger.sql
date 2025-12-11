-- A. Trigger: Sebelum Insert Item (Cek Stok & Hitung Harga)
DROP TRIGGER IF EXISTS cek_stok_dan_harga_before_insert;

CREATE TRIGGER cek_stok_dan_harga_before_insert
BEFORE INSERT ON item_pesanan
FOR EACH ROW
BEGIN
    DECLARE stok_tersedia INT;
    DECLARE harga_satuan DECIMAL(10,2);
    DECLARE nama_produk_asli VARCHAR(100); -- Variabel baru untuk menampung nama

    -- Ambil stok, harga, DAN nama produk saat ini
    SELECT stok, harga, nama_produk 
    INTO stok_tersedia, harga_satuan, nama_produk_asli
    FROM produk WHERE id_produk = NEW.id_produk;

    -- Validasi Stok
    IF stok_tersedia < NEW.jumlah THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Stok produk tidak mencukupi!';
    END IF;

    -- ISI OTOMATIS: Simpan nama produk ke kolom 'produk_yang_dibeli'
    SET NEW.produk_yang_dibeli = nama_produk_asli;

    -- Hitung total harga item otomatis
    SET NEW.total_harga_per_item = harga_satuan * NEW.jumlah;
END

-- B. Trigger: Setelah Insert Item (Potong Stok & Update Nota) --
CREATE TRIGGER update_stok_dan_nota_after_insert
AFTER INSERT ON item_pesanan
FOR EACH ROW
BEGIN
    -- 1. Kurangi stok di gudang
    UPDATE produk 
    SET stok = stok - NEW.jumlah
    WHERE id_produk = NEW.id_produk;

    -- 2. Update header pesanan (Total Item & Total Harga)
    UPDATE pesanan 
    SET total_item = total_item + NEW.jumlah,
        total_harga = total_harga + NEW.total_harga_per_item
    WHERE id_pesanan = NEW.id_pesanan;
END

-- C. Trigger: Jika Pesanan DIBATALKAN (Restock Barang)
CREATE TRIGGER restock_saat_pesanan_dibatalkan
AFTER UPDATE ON pesanan
FOR EACH ROW
BEGIN
    -- Hanya jalankan jika status berubah jadi 'Dibatalkan'
    IF NEW.status_pesanan = 'Dibatalkan' AND OLD.status_pesanan != 'Dibatalkan' THEN
        
        -- Kembalikan stok produk (Looping update via JOIN)
        UPDATE produk p
        INNER JOIN item_pesanan ip ON p.id_produk = ip.id_produk
        SET p.stok = p.stok + ip.jumlah
        WHERE ip.id_pesanan = NEW.id_pesanan;

    END IF;
END

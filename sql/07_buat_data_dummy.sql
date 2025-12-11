-- Pastikan Database sudah terpilih
USE kelompok4;

-- ==========================================
-- 1. INPUT DATA MASTER (PEMBELI & PRODUK)
-- ==========================================

-- A. Input Data Pembeli
INSERT INTO pembeli (nama_pembeli, no_telepon, alamat) VALUES 
('Muhammad Adha', '085789429383', 'Jl. Merdeka No. 1, Jakarta'),       -- ID 1
('Helen Patricia', '085366804488', 'Jl. Sudirman No. 45, Bandung'),    -- ID 2
('Muhammad Fachrian', '085159060313', 'Jl. Diponegoro No. 10, Surabaya'), -- ID 3
('M. Soni Juliansyah', '083139922736', 'Jl. Kaliurang KM 5, Yogyakarta'), -- ID 4
('Arif Dwi Febrianto', '082376624805', 'Jl. Malioboro KM 0, Yogyakarta'); -- ID 5

-- B. Input Data Produk (Via Procedure sp_tambah_produk)
CALL sp_tambah_produk('Laptop Apple Macbook M4', 20000000, 10);     -- ID 1
CALL sp_tambah_produk('Laptop Lenovo LOQ', 12000000, 10);           -- ID 2
CALL sp_tambah_produk('Laptop Asus Vivobook', 10000000, 10);        -- ID 3
CALL sp_tambah_produk('Laptop MSI Katana', 15000000, 10);           -- ID 4
CALL sp_tambah_produk('Mouse Logitech Wireless', 150000, 50);       -- ID 5
CALL sp_tambah_produk('Monitor Samsung 24 Inch', 2000000, 15);      -- ID 6
CALL sp_tambah_produk('Keyboard Mechanical RGB', 550000, 20);       -- ID 7
CALL sp_tambah_produk('Flashdisk Sandisk 32GB', 80000, 100);        -- ID 8
CALL sp_tambah_produk('Hard disk Sony 1TB', 1000000, 50);           -- ID 9
CALL sp_tambah_produk('SSD Adata Sony 2TB', 3000000, 50);           -- ID 10


-- ==========================================
-- 2. SIMULASI TRANSAKSI (TESTING ALUR)
-- ==========================================

-- SKENARIO 1: Transaksi Normal & Lunas 
-- (Muhammad Adha membeli Laptop & Mouse -> Bayar Lunas)
-- ---------------------------------------------------
CALL sp_buat_pesanan(1, @nota_adha); -- Buat Nota

-- Masukkan Item (Trigger cek stok & hitung harga berjalan)
CALL sp_tambah_item_pesanan(@nota_adha, 1, 1); -- 1 Macbook
CALL sp_tambah_item_pesanan(@nota_adha, 5, 1); -- 1 Mouse

-- Bayar (Status berubah jadi 'Dibayar')
CALL sp_bayar_pesanan(@nota_adha);


-- SKENARIO 2: Transaksi Pending / Belum Bayar
-- (Helen Patricia membeli 2 Monitor -> Belum Bayar)
-- ---------------------------------------------------
CALL sp_buat_pesanan(2, @nota_helen);

-- Masukkan Item (Stok berkurang, tapi status masih Pending)
CALL sp_tambah_item_pesanan(@nota_helen, 6, 2); -- 2 Monitor


-- SKENARIO 3: Transaksi Dibatalkan (Uji Trigger Restock)
-- (Fachrian membeli 5 Keyboard -> Batal -> Stok harus kembali)
-- ---------------------------------------------------
CALL sp_buat_pesanan(3, @nota_fachrian);

-- Beli 5 Keyboard (Stok awal 20 -> jadi 15)
CALL sp_tambah_item_pesanan(@nota_fachrian, 7, 5); 

-- Batalkan Pesanan (Stok harus kembali jadi 20)
CALL sp_batalkan_pesanan(@nota_fachrian);


-- SKENARIO 4: Menambah Stok Gudang (Supply Masuk)
-- (Admin menambah stok Flashdisk ID 8 karena menipis)
-- ---------------------------------------------------
-- Tambah stok sebanyak 50 pcs ke gudang
CALL sp_tambah_stok_gudang(8, 50);


-- SKENARIO 5: Uji Validasi Error (Stok Tidak Cukup)
-- (Soni mencoba memborong Laptop MSI melebihi stok)
-- ---------------------------------------------------
CALL sp_buat_pesanan(4, @nota_error);

-- PERHATIAN: Baris di bawah ini sengaja diberi komentar (--)
-- karena jika dijalankan akan menyebabkan ERROR STOP pada SQL.
-- Hilangkan tanda -- jika ingin melihat pesan error "Stok tidak mencukupi!".

-- CALL sp_tambah_item_pesanan(@nota_error, 4, 100); 


-- SKENARIO 6: Simulasi Event Auto-Cancel (Pesanan Kadaluarsa)
-- (Arif pesan tapi lupa bayar, sistem otomatis membatalkan setelah 24 jam)
-- ---------------------------------------------------
-- 1. Buat pesanan baru
CALL sp_buat_pesanan(5, @nota_kedaluwarsa);
CALL sp_tambah_item_pesanan(@nota_kedaluwarsa, 8, 2); 

-- 2. MANIPULASI WAKTU (Simulasi Backdate)
-- Kita ubah tanggal pesanan seolah-olah dibuat 2 hari lalu
UPDATE pesanan 
SET tanggal_pesanan = (NOW() - INTERVAL 2 DAY) 
WHERE id_pesanan = @nota_kedaluwarsa;

-- 3. JALANKAN LOGIKA EVENT (Manual Trigger untuk Test)
-- Ini adalah perintah yang ada di dalam EVENT 'ev_auto_cancel_pesanan_kedaluwarsa'
UPDATE pesanan
SET status_pesanan = 'Dibatalkan'
WHERE status_pesanan = 'Pending' 
AND tanggal_pesanan < (NOW() - INTERVAL 1 DAY);


-- ==========================================
-- 3. LAPORAN & MONITORING (REPORTING)
-- ==========================================

-- A. Cek View Laporan Lengkap
SELECT * FROM v_laporan_lengkap;

-- B. Cek Laporan Harian (Omzet Hari Ini)
-- Harusnya muncul transaksi Muhammad Adha
CALL sp_laporan_harian(CURDATE());

-- C. Cek Laporan Bulanan (Produk Terlaris)
CALL sp_laporan_bulanan(MONTH(CURDATE()), YEAR(CURDATE()));

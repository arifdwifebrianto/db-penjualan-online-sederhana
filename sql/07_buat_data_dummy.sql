-- Pastikan menggunakan database yang benar
USE kelompok4;

-- ==========================================
-- 1. INPUT DATA MASTER (PEMBELI & PRODUK)
-- ==========================================

-- Input Data Pembeli (Customer)
INSERT INTO pembeli (nama_pembeli, no_telepon, alamat) VALUES 
('Muhammad Adha', '085789429383', 'Jl. Merdeka No. 1, Jakarta'),
('Helen Patricia', '085366804488', 'Jl. Sudirman No. 45, Bandung'),
('Muhammad Fachrian', '085159060313', 'Jl. Diponegoro No. 10, Surabaya'),
('M. Soni Juliansyah', '083139922736', 'Jl. Kaliurang KM 5, Yogyakarta'),
('Arif Dwi Febrianto', '082376624805', 'Jl. Malioboro KM 0, Yogyakarta');

-- Input Data Produk menggunakan Stored Procedure [ADMIN]
-- Format: CALL sp_tambah_produk(Nama, Harga, Stok);
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
-- 2. SIMULASI TRANSAKSI (TESTING TRIGGER)
-- ==========================================

-- SKENARIO 1: Transaksi Normal & Lunas (Budi Santoso)
-- Budi membeli 1 Laptop dan 1 Mouse.
-- ---------------------------------------------------

-- A. Buat Keranjang Baru untuk Budi (ID Pembeli 1)
-- Kita simpan ID pesanan ke dalam variabel @nota_budi
CALL sp_buat_pesanan(1, @nota_budi);

-- B. Masukkan Barang ke Keranjang @nota_budi
-- Beli Laptop (ID Prod 1), Jumlah 1
CALL sp_tambah_item_pesanan(@nota_budi, 1, 1); 
-- Beli Mouse (ID Prod 2), Jumlah 1
CALL sp_tambah_item_pesanan(@nota_budi, 2, 1);

-- C. Bayar Pesanan (Status jadi 'Dibayar')
CALL sp_bayar_pesanan(@nota_budi);


-- SKENARIO 2: Transaksi Pending / Belum Bayar (Siti Aminah)
-- Siti membeli 2 Monitor, tapi belum bayar.
-- ---------------------------------------------------

CALL sp_buat_pesanan(2, @nota_siti);

-- Beli Monitor (ID Prod 3), Jumlah 2
CALL sp_tambah_item_pesanan(@nota_siti, 3, 2);
-- (Kita tidak panggil sp_bayar_pesanan, jadi status tetap 'Pending')


-- SKENARIO 3: Transaksi Dibatalkan & Test Restock (Andi Pratama)
-- Andi membeli 5 Keyboard, lalu membatalkan pesanan.
-- Stok Keyboard harus berkurang dulu, lalu kembali lagi setelah batal.
-- ---------------------------------------------------

CALL sp_buat_pesanan(3, @nota_andi);

-- Beli Keyboard (ID Prod 4), Jumlah 5
CALL sp_tambah_item_pesanan(@nota_andi, 4, 5);

-- Tiba-tiba Andi membatalkan
CALL sp_batalkan_pesanan(@nota_andi);
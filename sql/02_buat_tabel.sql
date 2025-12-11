-- Tabel Pembeli
CREATE TABLE pembeli (
    id_pembeli INT AUTO_INCREMENT PRIMARY KEY,
    nama_pembeli VARCHAR(100) NOT NULL,
    no_telepon VARCHAR(15),
    alamat TEXT
);

-- Tabel Produk
CREATE TABLE produk (
    id_produk INT AUTO_INCREMENT PRIMARY KEY,
    nama_produk VARCHAR(100) NOT NULL,
    harga DECIMAL(10, 2) NOT NULL CHECK (harga >= 0),
    stok INT NOT NULL DEFAULT 0 CHECK (stok >= 0) -- Stok tidak boleh minus
);

-- Tabel Pesanan (Header)
CREATE TABLE pesanan (
    id_pesanan INT AUTO_INCREMENT PRIMARY KEY,
    id_pembeli INT,
    tanggal_pesanan DATETIME DEFAULT CURRENT_TIMESTAMP,
    tanggal_bayar DATETIME NULL, -- Kolom baru untuk log pembayaran
    total_item INT DEFAULT 0,
    total_harga DECIMAL(10, 2) DEFAULT 0,
    status_pesanan ENUM('Pending', 'Dibayar', 'Dibatalkan') DEFAULT 'Pending',
    FOREIGN KEY (id_pembeli) REFERENCES pembeli(id_pembeli)
);

-- Tabel Item Pesanan (Detail)
CREATE TABLE item_pesanan (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pesanan INT,
    id_produk INT,
    produk_yang_dibeli VARCHAR(100), 
    
    jumlah INT NOT NULL CHECK (jumlah > 0),
    total_harga_per_item DECIMAL(10, 2),
    
    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan),
    FOREIGN KEY (id_produk) REFERENCES produk(id_produk)
);
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
    jumlah INT NOT NULL CHECK (jumlah > 0), -- Beli minimal 1
    total_harga_per_item DECIMAL(10, 2), -- Disimpan statis saat transaksi terjadi
    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan),
    FOREIGN KEY (id_produk) REFERENCES produk(id_produk)
CREATE TABLE Pembeli (
    id_pembeli INT NOT NULL AUTO_INCREMENT, 
    nama_pembeli VARCHAR(100) NOT NULL,
    nomor_telepon VARCHAR(15) NOT NULL,
    alamat TEXT,
    
    PRIMARY KEY (id_pembeli)
);

-- Tabel Produk
CREATE TABLE Produk (
    id_produk INT NOT NULL AUTO_INCREMENT, 
    nama_produk VARCHAR(100) NOT NULL,
    harga DECIMAL(10, 2) NOT NULL,         
    stok INT NOT NULL,                  
    
    PRIMARY KEY (id_produk),
    
    CONSTRAINT CHK_Harga_Positif CHECK (harga >= 0),
    CONSTRAINT CHK_Stok_Positif CHECK (stok >= 0)
);

-- Tabel Pesanan (Nota belanja)
CREATE TABLE Pesanan (
    id_pesanan INT NOT NULL AUTO_INCREMENT,
    id_pembeli INT NOT NULL,
    tanggal_pesanan DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_item INT NOT NULL,
    total_harga DECIMAL(10, 2) NOT NULL,
    status_pesanan ENUM('pending', 'dibayar', 'dibatalkan') DEFAULT 'pending',
 
    PRIMARY KEY (id_pesanan),
    FOREIGN KEY (id_pembeli) REFERENCES Pembeli(id_pembeli) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT CHK_Total_Item_Positif CHECK (total_item >= 0),
    CONSTRAINT CHK_Total_Harga_Positif CHECK (total_harga >= 0)
);

-- Tabel Item_Pesanan (Daftar Barang di nota)
CREATE TABLE Item_Pesanan (
    id_item INT AUTO_INCREMENT,
    id_pesanan INT NOT NULL,
    id_produk INT NOT NULL,
    jumlah INT NOT NULL,
    total_harga_per_item DECIMAL(10, 2) NOT NULL,
    
    PRIMARY KEY (id_item),
    
    FOREIGN KEY (id_pesanan) REFERENCES Pesanan(id_pesanan) ON DELETE CASCADE ON UPDATE CASCADE,
    
    FOREIGN KEY (id_produk) REFERENCES Produk(id_produk) ON UPDATE CASCADE,

    CONSTRAINT CHK_Jumlah_Positif CHECK (jumlah > 0),
    
    UNIQUE (id_pesanan, id_produk) 
);


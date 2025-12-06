-- Tabel Pembeli
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
    
    FOREIGN KEY (id_produk) REFERENCES Produk(id_produk) ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT CHK_Jumlah_Positif CHECK (jumlah > 0),
    
    UNIQUE (id_pesanan, id_produk) 
);


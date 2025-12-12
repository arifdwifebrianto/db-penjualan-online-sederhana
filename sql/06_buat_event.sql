CREATE EVENT ev_auto_cancel_pesanan_kedaluwarsa
ON SCHEDULE EVERY 1 HOUR -- Cek setiap 1 jam
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Update pesanan jadi 'Dibatalkan' jika Pending > 24 jam
    -- Trigger akan otomatis berjalan untuk mengembalikan stok
    UPDATE pesanan
    SET status_pesanan = 'Dibatalkan'
    WHERE status_pesanan = 'Pending' 
    AND tanggal_pesanan < (NOW() - INTERVAL 1 DAY);
END

/*
-- Buat Demonstrasi
-- Hapus event lama dulu
DROP EVENT IF EXISTS ev_auto_cancel_pesanan_kedaluwarsa;

-- Buat event baru
CREATE EVENT ev_auto_cancel_pesanan_kedaluwarsa
ON SCHEDULE EVERY 30 SECOND -- (A) Robot mengecek tiap 30 detik
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE pesanan
    SET status_pesanan = 'Dibatalkan'
    WHERE status_pesanan = 'Pending' 
    AND tanggal_pesanan < (NOW() - INTERVAL 1 MINUTE); -- (B) Kadaluarsa setelah 1 menit
END
*/

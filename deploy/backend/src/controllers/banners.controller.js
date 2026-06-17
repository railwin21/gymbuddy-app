import { getDBPool } from '../config/db.js';
import { success, error } from '../utils/response.js';
import cache from '../utils/cache.js';

export const getAllBanners = async (req, res) => {
    try {
        const cacheKey = 'banners_list';
        const cached = cache.get(cacheKey);
        if (cached) return res.json({ success: true, data: cached });

        const db = await getDBPool();
        const { is_active } = req.query;
        let query = 'SELECT * FROM banners WHERE 1=1';
        let params = [];
        if (is_active !== undefined) { query += ' AND is_active = ?'; params.push(is_active === 'true' ? 1 : 0); }
        query += ' ORDER BY urutan ASC, created_at DESC';
        const rows = await db.query(query, params);
        
        cache.set(cacheKey, rows, 600);
        res.json({ success: true, data: rows });
    } catch (err) { return error(res, 'Gagal mengambil banner', 500); }
};

export const createBanner = async (req, res) => {
    try {
        const { judul, deskripsi, gambar, link, urutan } = req.body;
        if (!gambar) return error(res, 'Gambar banner wajib diisi', 400);
        const db = await getDBPool();
        const result = await db.query(
            'INSERT INTO banners (judul, deskripsi, gambar, link, urutan) VALUES (?, ?, ?, ?, ?)',
            [judul || '', deskripsi || '', gambar, link || null, urutan || 0]
        );
        cache.del('banners_list');
        return success(res, { id: Number(result.insertId) }, 'Banner berhasil dibuat', 201);
    } catch (err) { return error(res, 'Gagal membuat banner', 500); }
};

export const updateBanner = async (req, res) => {
    try {
        const db = await getDBPool();
        const allowed = ['judul','deskripsi','gambar','link','urutan','is_active'];
        const fields = []; const values = [];
        for (const f of allowed) {
            if (req.body[f] !== undefined) { fields.push(`${f} = ?`); values.push(req.body[f]); }
        }
        if (fields.length === 0) return error(res, 'Tidak ada field yang diupdate', 400);
        values.push(req.params.id);
        await db.query(`UPDATE banners SET ${fields.join(', ')} WHERE id = ?`, values);
        cache.del('banners_list');
        return success(res, null, 'Banner berhasil diperbarui');
    } catch (err) { return error(res, 'Gagal memperbarui banner', 500); }
};

export const deleteBanner = async (req, res) => {
    try {
        const db = await getDBPool();
        await db.query('DELETE FROM banners WHERE id = ?', [req.params.id]);
        cache.del('banners_list');
        return success(res, null, 'Banner berhasil dihapus');
    } catch (err) { return error(res, 'Gagal menghapus banner', 500); }
};

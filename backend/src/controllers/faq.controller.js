import { getDBPool } from '../config/db.js';
import { success, error } from '../utils/response.js';
import cache from '../utils/cache.js';

export const getAllFaq = async (req, res) => {
    try {
        const cacheKey = 'faq_list';
        const { kategori, is_active } = req.query;
        
        // Hanya pakai cache jika tidak ada filter
        if (!kategori && is_active === undefined) {
            const cached = cache.get(cacheKey);
            if (cached) return res.json({ success: true, data: cached });
        }

        const db = await getDBPool();
        let query = 'SELECT * FROM faq WHERE 1=1';
        let params = [];
        if (kategori) { query += ' AND kategori = ?'; params.push(kategori); }
        if (is_active !== undefined) { query += ' AND is_active = ?'; params.push(is_active === 'true' ? 1 : 0); }
        query += ' ORDER BY urutan ASC, created_at DESC';
        const rows = await db.query(query, params);
        
        cache.set(cacheKey, rows, 600);
        res.json({ success: true, data: rows });
    } catch (err) { return error(res, 'Gagal mengambil FAQ', 500); }
};

export const createFaq = async (req, res) => {
    try {
        const { pertanyaan, jawaban, kategori, urutan } = req.body;
        if (!pertanyaan || !jawaban) return error(res, 'Pertanyaan dan jawaban wajib diisi', 400);
        const db = await getDBPool();
        const result = await db.query(
            'INSERT INTO faq (pertanyaan, jawaban, kategori, urutan) VALUES (?, ?, ?, ?)',
            [pertanyaan, jawaban, kategori || 'umum', urutan || 0]
        );
        cache.del('faq_list');
        return success(res, { id: Number(result.insertId) }, 'FAQ berhasil dibuat', 201);
    } catch (err) { return error(res, 'Gagal membuat FAQ', 500); }
};

export const updateFaq = async (req, res) => {
    try {
        const { pertanyaan, jawaban, kategori, urutan, is_active } = req.body;
        const db = await getDBPool();
        const fields = []; const values = [];
        if (pertanyaan !== undefined) { fields.push('pertanyaan = ?'); values.push(pertanyaan); }
        if (jawaban !== undefined) { fields.push('jawaban = ?'); values.push(jawaban); }
        if (kategori !== undefined) { fields.push('kategori = ?'); values.push(kategori); }
        if (urutan !== undefined) { fields.push('urutan = ?'); values.push(urutan); }
        if (is_active !== undefined) { fields.push('is_active = ?'); values.push(is_active ? 1 : 0); }
        if (fields.length === 0) return error(res, 'Tidak ada field yang diupdate', 400);
        values.push(req.params.id);
        await db.query(`UPDATE faq SET ${fields.join(', ')} WHERE id = ?`, values);
        cache.del('faq_list');
        return success(res, null, 'FAQ berhasil diperbarui');
    } catch (err) { return error(res, 'Gagal memperbarui FAQ', 500); }
};

export const deleteFaq = async (req, res) => {
    try {
        const db = await getDBPool();
        await db.query('DELETE FROM faq WHERE id = ?', [req.params.id]);
        cache.del('faq_list');
        return success(res, null, 'FAQ berhasil dihapus');
    } catch (err) { return error(res, 'Gagal menghapus FAQ', 500); }
};

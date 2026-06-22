import {getDBPool} from '../config/db.js';
import cache from '../utils/cache.js';

export const getAllTrainers = async (req, res) => {
    try {
        const db = await getDBPool();
        const { nama, page, limit } = req.query;

        const currentPage = parseInt(page) || 1;
        const currentLimit = parseInt(limit) || 20;
        const offset = (currentPage - 1) * currentLimit;

        let query = "SELECT id, nama, email, propinsi, kota, foto, created_at FROM user WHERE role = 'trainer'";
        let countQuery = "SELECT COUNT(*) as total FROM user WHERE role = 'trainer'";
        let params = [];

        if (nama) {
            query += ' AND nama LIKE ?';
            countQuery += ' AND nama LIKE ?';
            params.push(`%${nama}%`);
        }

        query += ' ORDER BY nama ASC';

        const rows = await db.query(query + ' LIMIT ? OFFSET ?', [...params, currentLimit, offset]);
        const countResult = await db.query(countQuery, params);
        const total = Number(countResult[0]?.total || 0);

        res.setHeader('X-Total-Count', total);
        res.setHeader('Access-Control-Expose-Headers', 'X-Total-Count');

        res.status(200).json({
            data: rows,
            total: total
        });

    } catch (error) {
        console.error("Error getAllTrainers:", error);
        res.status(500).json({ message: 'Gagal mengambil data trainer' });
    }
};

export const getTrainerById = async (req, res) => {
    try {
        const { id } = req.params;
        const cacheKey = `trainer_${id}`;
        const cachedData = cache.get(cacheKey);
        if (cachedData) return res.json({ data: cachedData });

        const db = await getDBPool();
        const rows = await db.query(
            "SELECT id, nama, email, propinsi, kota, created_at FROM user WHERE id = ? AND role = 'trainer'",
            [id]
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: 'Trainer tidak ditemukan' });
        }

        cache.set(cacheKey, rows[0]);
        res.json({ data: rows[0] });
    } catch (error) {
        res.status(500).json({ message: 'Gagal mengambil data trainer' });
    }
};

export const getTrainerName = async (req, res) => {
    try {
        const { nama } = req.params;
        const cacheKey = `trainer_name_${nama}`;
        const cachedData = cache.get(cacheKey);
        if (cachedData) return res.json(cachedData);

        const db = await getDBPool();
        const rows = await db.query(
            "SELECT id, nama, email, propinsi, kota FROM user WHERE nama = ? AND role = 'trainer'",
            [nama]
        );
        if (rows.length === 0) {
            return res.status(404).json({ message: 'Trainer tidak ditemukan' });
        }

        cache.set(cacheKey, rows[0]);
        res.json(rows[0]);
    } catch (error) {
        res.status(500).json({ message: 'Gagal mencari trainer' });
    }
};

export const updateTrainer = async (req, res) => {
    try {
        const { id } = req.params;
        const { nama, email, propinsi, kota } = req.body;
        const loggedInUser = req.user;

        if (loggedInUser.role !== 'admin' && (loggedInUser.role !== 'trainer' || loggedInUser.id !== parseInt(id))) {
            return res.status(403).json({ message: 'Tidak memiliki izin' });
        }

        const db = await getDBPool();
        const [existing] = await db.query("SELECT * FROM user WHERE id = ? AND role = 'trainer'", [id]);
        if (!existing) return res.status(404).json({ message: 'Trainer tidak ditemukan' });

        await db.query(
            "UPDATE user SET nama = ?, email = ?, propinsi = ?, kota = ? WHERE id = ?",
            [nama || existing.nama, email || existing.email, propinsi || existing.propinsi, kota || existing.kota, id]
        );

        cache.del('all_trainers');
        cache.del(`trainer_${id}`);
        res.json({ message: 'Profil trainer berhasil diperbarui' });
    } catch (error) {
        res.status(500).json({ message: 'Gagal memperbarui data trainer' });
    }
};

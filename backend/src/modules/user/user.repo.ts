import { eq, ilike, and, desc, asc, sql } from 'drizzle-orm';
import { db } from '../../db/client';
import { users } from '../../db/schema';

export async function findAll(opts: {
    page: number;
    limit: number;
    search?: string;
    role?: string;
    kota?: string;
    sort: string;
    order: string;
}) {
    const conditions = [];
    if (opts.search) {
        conditions.push(ilike(users.nama, `%${opts.search}%`));
    }
    if (opts.role) {
        conditions.push(eq(users.role, opts.role as any));
    }
    if (opts.kota) {
        conditions.push(ilike(users.kota, `%${opts.kota}%`));
    }

    const where = conditions.length > 0 ? and(...conditions) : undefined;

    const sortCol = opts.sort === 'nama' ? users.nama : users.createdAt;
    const orderFn = opts.order === 'asc' ? asc : desc;

    const rows = await db.select({
        id: users.id,
        nama: users.nama,
        email: users.email,
        role: users.role,
        jenis_kelamin: users.jenis_kelamin,
        no_telp: users.no_telp,
        tanggal_lahir: users.tanggal_lahir,
        foto: users.foto,
        bio: users.bio,
        propinsi: users.propinsi,
        kota: users.kota,
        spesialisasi: users.spesialisasi,
        createdAt: users.createdAt,
        updatedAt: users.updatedAt,
    })
    .from(users)
    .where(where)
    .orderBy(orderFn(sortCol))
    .limit(opts.limit)
    .offset((opts.page - 1) * opts.limit);

    const countResult = await db.select({ count: sql<number>`count(*)` })
    .from(users)
    .where(where);
    const total = Number(countResult[0].count);

    return { rows, total };
}

export async function findById(id: number) {
    const rows = await db.select().from(users).where(eq(users.id, id)).limit(1);
    return rows[0] ?? null;
}

export async function findByEmail(email: string) {
    const rows = await db.select().from(users).where(eq(users.email, email)).limit(1);
    return rows[0] ?? null;
}

export async function updateUser(id: number, data: Record<string, unknown>) {
    const rows = await db.update(users)
    .set({ ...data, updatedAt: new Date() })
    .where(eq(users.id, id))
    .returning();
    return rows[0] ?? null;
}

export async function deleteUser(id: number) {
    await db.delete(users).where(eq(users.id, id));
    return true;
}

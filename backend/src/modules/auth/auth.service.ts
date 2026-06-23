import bcrypt from 'bcrypt';
import { findUserByEmail, findUserById, createUser } from './auth.repo';
import { signToken } from '../../utils/jwt';

export class AuthError extends Error {
    constructor(
        public statusCode: number,
        public code: string,
        message: string,
    ) {
        super(message);
    }
}

export async function registerCustomer(data: {
    nama: string;
    email: string;
    password: string;
    jenis_kelamin?: string;
    no_telp?: string;
    tanggal_lahir?: string;
    propinsi?: string;
    kota?: string;
}) {
    const existing = await findUserByEmail(data.email);
    if (existing) {
        throw new AuthError(409, 'CONFLICT', 'Email sudah digunakan');
    }

    const hashed = await bcrypt.hash(data.password, 10);
    const user = await createUser({
        nama: data.nama,
        email: data.email,
        password: hashed,
        role: 'customer',
        jenis_kelamin: data.jenis_kelamin,
        no_telp: data.no_telp,
        tanggal_lahir: data.tanggal_lahir,
        propinsi: data.propinsi,
        kota: data.kota,
    });

    const token = signToken({ id: user.id, role: user.role });
    return { user: sanitizeUser(user), token };
}

export async function registerTrainer(data: {
    nama: string;
    email: string;
    password: string;
    spesialisasi: string;
    bio?: string;
    no_telp?: string;
    propinsi?: string;
    kota?: string;
}) {
    const existing = await findUserByEmail(data.email);
    if (existing) {
        throw new AuthError(409, 'CONFLICT', 'Email sudah digunakan');
    }

    const hashed = await bcrypt.hash(data.password, 10);
    const user = await createUser({
        nama: data.nama,
        email: data.email,
        password: hashed,
        role: 'trainer',
        spesialisasi: data.spesialisasi,
        bio: data.bio,
        no_telp: data.no_telp,
        propinsi: data.propinsi,
        kota: data.kota,
    });

    const token = signToken({ id: user.id, role: user.role });
    return { user: sanitizeUser(user), token };
}

export async function registerAdmin(data: { nama: string; email: string; password: string }) {
    const existing = await findUserByEmail(data.email);
    if (existing) {
        throw new AuthError(409, 'CONFLICT', 'Email sudah digunakan');
    }

    const hashed = await bcrypt.hash(data.password, 10);
    const user = await createUser({
        nama: data.nama,
        email: data.email,
        password: hashed,
        role: 'admin',
    });

    const token = signToken({ id: user.id, role: user.role });
    return { user: sanitizeUser(user), token };
}

export async function login(email: string, password: string) {
    const user = await findUserByEmail(email);
    if (!user) {
        throw new AuthError(401, 'UNAUTHORIZED', 'Email atau password salah');
    }

    const valid = await bcrypt.compare(password, user.password);
    if (!valid) {
        throw new AuthError(401, 'UNAUTHORIZED', 'Email atau password salah');
    }

    const token = signToken({ id: user.id, role: user.role });
    return { user: sanitizeUser(user), token };
}

export async function getMe(userId: number) {
    const user = await findUserById(userId);
    if (!user) {
        throw new AuthError(404, 'NOT_FOUND', 'User tidak ditemukan');
    }
    return sanitizeUser(user);
}

function sanitizeUser(user: any) {
    const { password, ...rest } = user;
    return rest;
}

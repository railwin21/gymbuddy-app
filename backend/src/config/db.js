import * as mariadb from 'mariadb';
import dotenv from 'dotenv';

dotenv.config();

// Support both local .env (DB_HOST, etc.) and Railway (MYSQLHOST, etc.)
const config = {
    host: process.env.MYSQLHOST || process.env.DB_HOST || 'localhost',
    user: process.env.MYSQLUSER || process.env.DB_USER || 'root',
    password: process.env.MYSQLPASSWORD || process.env.DB_PASSWORD || '',
    database: process.env.MYSQLDATABASE || process.env.DB_NAME || 'gymbuddy_database_1',
    port: parseInt(process.env.MYSQLPORT || process.env.DB_PORT || '3306'),
    connectionLimit: 10,
    ssl: process.env.DB_SSL === 'true' ? true : false
};

console.log('[DB] Connecting to MySQL:', config.host + ':' + config.port + '/' + config.database);

const pool = mariadb.createPool(config);

const dbCheck = async () => {
    try {
        const connection = await pool.getConnection();
        await connection.query('SELECT 1');
        connection.release();
        console.log('Database connected successfully');
    } catch (error) {
        console.error('Database connection failed:', error);
        process.exit(1);
    }
}

export const connectDB = () => {
    console.log('[Config] connectDB called');
    return dbCheck();
};

export const getDBPool = () => {
    console.log('[Config] getDBPool called');
    return pool;
};

export default pool;

export const errorMiddleware = (err, req, res, next) => {
    console.error(new Date().toISOString(), err.stack);

    const status = err.status || 500;
    const message = status === 500 ? 'Terjadi kesalahan server internal' : err.message;

    res.status(status).json({
        success: false,
        message: message
    });
};

export default errorMiddleware;

export const success = (res, data, message, status = 200) => {
    const sanitizedData = JSON.parse(
        JSON.stringify(data, (key, value) =>
            typeof value === 'bigint' ? Number(value) : value
        )
    );
    return res.status(status).json({success: true, data: sanitizedData, message});
};

export const error = (res, message, status = 400) => {
    return res.status(status).json({ success: false, message });
};

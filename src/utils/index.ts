import * as bcrypt from 'bcryptjs';

export const checkPassword = async (password: string, dbPassword: string) => {
    return await bcrypt.compare(password, dbPassword);
}
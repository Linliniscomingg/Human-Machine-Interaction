
import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { User } from './schemas/user.schema';
import { Model } from 'mongoose';
import { CreateUserDto, UpdateUserDto } from './dto/user.dto';
import { QueryAllDto } from 'src/common/dto/queryAllDto';


@Injectable()
export class UsersService {
    constructor(
        @InjectModel(User.name) private userModel: Model<User>,
    ) { }

    // for testing and exposing to other service purposes, not implement by any route in /users
    async create(createUserDto: CreateUserDto): Promise<User> {
        const existingUser = await this.userModel.findOne({ username: createUserDto.username }).exec();
        if (existingUser) {
            throw new ConflictException('Username already exists');
        }
        const createdUser = new this.userModel(createUserDto);
        return createdUser.save();
    }

    async findAll(userQueryDto: QueryAllDto): Promise<User[]> {
        const { page = 1, limit = 10, sortField, sortOrder = 'asc' } = userQueryDto;
        const skip = (page - 1) * limit;
        const sort = sortField ? { [sortField]: sortOrder === 'asc' ? 1 : -1 } as { [key: string]: 1 | -1 } : {};
    
        return this.userModel.find().skip(skip).limit(limit).sort(sort).exec();
    }

    async findById(id: string): Promise<User> {
        const user = await this.userModel.findById(id).exec();
        if (!user) {
            throw new NotFoundException("user with this id not found");
        }
        return user
    }

    async findOne(username: string): Promise<User> {
        const user = await this.userModel.findOne({ username }).select('+password').exec();
        if (!user) {
            throw new NotFoundException("user with this username not found");
        }
        return user;
    }

    async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
        const newUser = await this.userModel.findByIdAndUpdate(id, updateUserDto,
            {
                new: true,
                runValidators: true,
            }
        ).exec();

        if (!newUser) {
            throw new NotFoundException("user with this id not found");
        }
        return newUser;
    }

    async delete(id: string) {
        const user = await this.userModel.findByIdAndDelete(id).exec();
        if (!user) {
            throw new NotFoundException("user with this id not found");
        }
    }
}

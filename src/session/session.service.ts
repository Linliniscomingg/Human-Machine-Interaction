import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Session } from './schemas/session.schema';
import { Model } from 'mongoose';
import { QueryAllDto } from 'src/common/dto/queryAllDto';
import { CreateSessionDto, UpdateSessionDto } from './dto/session.dto';

@Injectable()
export class SessionService {
    constructor(@InjectModel(Session.name) private sessionModel: Model<Session>) { }

    async findAll(sessionQueryDto: QueryAllDto): Promise<Session[]> {
        const { page = 1, limit = 10, sortField, sortOrder = 'asc' } = sessionQueryDto;
        const skip = (page - 1) * limit;
        const sort = sortField ? { [sortField]: sortOrder === 'asc' ? 1 : -1 } as { [key: string]: 1 | -1 } : {};

        return this.sessionModel.find().skip(skip).limit(limit).sort(sort).exec();
    }

    async findById(id: string): Promise<Session> {
        const session = await this.sessionModel.findById(id).exec();
        if (!session) {
            throw new NotFoundException('Session not found');
        }
        return session;
    }

    // TODO: should check if user id exists
    async findByUserId(userId: string): Promise<Session[]> {
        try {
            return this.sessionModel.find({ userId }).exec();
        } catch (error) {
            throw new NotFoundException('Session not found with this user id');
        }
    }

    async findByLesson(lessonId: string): Promise<Session[]> {
        try {
            return this.sessionModel.find({ lessonId }).exec();
        } catch (error) {
            throw new NotFoundException('Session not found with this lesson id');
        }
    }

    async findByLessonAndUser(lessonId: string, userId: string): Promise<Session> {
        try {
            return this.sessionModel.findOne({ lessonId, userId }).exec();
        } catch (error) {
            throw new NotFoundException('Session not found with this lesson id and user id');
        }
    }

    async create(createSessionDto: CreateSessionDto): Promise<Session> {
        const createdSession = new this.sessionModel(createSessionDto);
        return createdSession.save();
    }

    async update(id: string, updateSessionDto: UpdateSessionDto): Promise<Session> {
        const newSession = await this.sessionModel.findByIdAndUpdate(id, updateSessionDto, { new: true }).exec();
        if (!newSession) {
            throw new NotFoundException('Session not found');
        }
        return newSession;
    }

    async delete(id: string) {
        const deletedSession = await this.sessionModel.findByIdAndDelete(id).exec();
        if (!deletedSession) {
            throw new NotFoundException('Session not found');
        }
    }
}

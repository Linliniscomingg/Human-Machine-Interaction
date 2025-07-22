import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Lesson } from './schemas/lesson.schema';
import { Model } from 'mongoose';

@Injectable()
export class LessonService {
    constructor(
        @InjectModel(Lesson.name) private lessonModel: Model<Lesson>,
    ) { }

    async findAll(lessQueryDto: any): Promise<Lesson[]> {
        const { page = 1, limit = 10, sortField, sortOrder = 'asc' } = lessQueryDto;
        const skip = (page - 1) * limit;
        const sort = sortField ? { [sortField]: sortOrder === 'asc' ? 1 : -1 } as { [key: string]: 1 | -1 } : {};

        return this.lessonModel.find().skip(skip).limit(limit).sort(sort).exec();
    }

    async findById(id: string): Promise<Lesson> {
        const lesson = await this.lessonModel.findById(id).exec();
        if (!lesson) {
            throw new NotFoundException("lesson with this id not found");
        }
        return lesson
    }

    async update(id: string, updateLessonDto: any): Promise<Lesson> {
        const newLesson = await this.lessonModel.findByIdAndUpdate(
            id,
            updateLessonDto,
            {
                new: true,
                runValidators: true
            }
        ).exec();
        if (!newLesson) {
            throw new NotFoundException("lesson with this id not found");
        }
        return newLesson;

    }

    async create(createLessonDto: any): Promise<Lesson> {
        const createdLesson = new this.lessonModel(createLessonDto);
        return createdLesson.save();
    }

    async delete(id: string) {
        const deletedLesson = await this.lessonModel.findByIdAndDelete(id).exec();
        if (!deletedLesson) {
            throw new NotFoundException("lesson with this id not found");
        }
    }
}

import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Exercise } from './schemas/exercise.schema';
import { Model } from 'mongoose';
import { QueryAllDto } from 'src/common/dto/queryAllDto';
import { GetByDifficultAndTagDto } from './dto/exercise.dto';

@Injectable()
export class ExerciseService {
    constructor(
        @InjectModel(Exercise.name) private exerciseModel: Model<Exercise>,
    ) { }

    async findAll(exerciseQueryDto: QueryAllDto): Promise<Exercise[]> {
        const { page = 1, limit = 10, sortField, sortOrder = 'asc' } = exerciseQueryDto;
        const skip = (page - 1) * limit;
        const sort = sortField ? { [sortField]: sortOrder === 'asc' ? 1 : -1 } as { [key: string]: 1 | -1 } : {};

        return this.exerciseModel.find().skip(skip).limit(limit).sort(sort).exec();

    }

    async getByTagAndDifficult(getByDifficultAndTagDto: GetByDifficultAndTagDto): Promise<Exercise[]> {
        return this.exerciseModel.find({
            tags: { $in: [getByDifficultAndTagDto.tag] },
            difficulty: getByDifficultAndTagDto.difficult
        }).exec();
    }

    async findById(id: string): Promise<Exercise> {
        const exercise = await this.exerciseModel.findById(id).exec();
        if (!exercise) {
            throw new NotFoundException('Exercise not found');
        }
        return exercise;
    }

    async create(createExerciseDto: any): Promise<Exercise> {
        const createdExercise = new this.exerciseModel(createExerciseDto);
        return createdExercise.save();
    }

    async update(id: string, updateExerciseDto: any): Promise<Exercise> {
        const newExercise = await this.exerciseModel.findByIdAndUpdate(id, updateExerciseDto, { new: true }).exec();
        if (!newExercise) {
            throw new Error('Exercise not found');
        }
        return newExercise;
    }

    async delete(id: string) {
        const deletedExercise = await this.exerciseModel.findByIdAndDelete(id).exec();
        if (!deletedExercise) {
            throw new Error('Exercise not found');
        }
    }
}

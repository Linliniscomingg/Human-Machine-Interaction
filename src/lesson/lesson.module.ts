import { Module } from '@nestjs/common';
import { LessonController } from './lesson.controller';
import { LessonService } from './lesson.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Lesson, LessonSchema } from './schemas/lesson.schema';
import { Exercise, ExerciseSchema } from 'src/exercise/schemas/exercise.schema';

@Module({
  controllers: [LessonController],
  providers: [LessonService],
  imports:[
    MongooseModule.forFeature([
      { name: Lesson.name, schema: LessonSchema },
      { name: Exercise.name, schema: ExerciseSchema }
    ])
  ]
})
export class LessonModule {}

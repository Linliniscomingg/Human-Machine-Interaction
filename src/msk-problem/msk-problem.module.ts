import { Module } from '@nestjs/common';
import { MskProblemController } from './msk-problem.controller';
import { MskProblemService } from './msk-problem.service';
import { MongooseModule } from '@nestjs/mongoose';
import { MskProblem, MskProblemSchema } from './schemas/msk-problem.schema';

@Module({
  controllers: [MskProblemController],
  providers: [MskProblemService],
  imports: [
    MongooseModule.forFeature([{name:MskProblem.name, schema: MskProblemSchema}])
  ]
})
export class MskProblemModule {}

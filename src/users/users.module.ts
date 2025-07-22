import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { User, UserSchema } from './schemas/user.schema'; 
import { MskProblem, MskProblemSchema } from 'src/msk-problem/schemas/msk-problem.schema';

@Module({
  providers: [UsersService],
  controllers: [UsersController],
  imports: [
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: MskProblem.name, schema: MskProblemSchema }
    ]), 
  ],
  exports: [UsersService], 
})
export class UsersModule {}

import { Module } from '@nestjs/common';
import { SessionController } from './session.controller';
import { SessionService } from './session.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Session, SessionSchema } from './schemas/session.schema';
import { Lesson } from 'src/lesson/schemas/lesson.schema';
import { ExerciseSchema } from 'src/exercise/schemas/exercise.schema';
import { User, UserSchema } from 'src/users/schemas/user.schema';

@Module({
  controllers: [SessionController],
  providers: [SessionService],
  imports: [
    MongooseModule.forFeature([
      { name: Session.name, schema: SessionSchema },
      { name: Lesson.name, schema: ExerciseSchema },
      { name: User.name, schema: UserSchema }
    ])
  ]
})
export class SessionModule { }

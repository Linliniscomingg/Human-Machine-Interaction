import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { MongooseModule } from '@nestjs/mongoose';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MskProblemModule } from './msk-problem/msk-problem.module';
import { ExerciseModule } from './exercise/exercise.module';
import { LessonModule } from './lesson/lesson.module';
import { SessionModule } from './session/session.module';
import databaseConfig from './config/database.config';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load:[databaseConfig]
    }),

    MongooseModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        uri: configService.get<string>('database.uri'),
        retryAttempts: 3,
        retryDelay: 1000,
        useNewUrlParser: true,
        useUnifiedTopology: true,
        autoIndex: true,
      }),
      inject: [ConfigService],
    }),
    AuthModule,
    UsersModule,
    MskProblemModule,
    ExerciseModule,
    LessonModule,
    SessionModule 
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

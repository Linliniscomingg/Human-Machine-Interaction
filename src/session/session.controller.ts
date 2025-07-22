import { Body, Controller, Delete, Get, Param, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiResponse, ApiTags } from '@nestjs/swagger';
import { SessionService } from './session.service';
import { QueryAllDto } from 'src/common/dto/queryAllDto';
import { ParseObjectIdPipe } from 'src/common/pipes/parse-object-id.pipe';
import { CreateSessionDto, UpdateSessionDto } from './dto/session.dto';

@ApiBearerAuth()
@ApiTags('Session')
@Controller('session')
export class SessionController {
    constructor(private readonly sessionService: SessionService) {}

    @Get()
    @ApiResponse({ status: 200, description: 'get all session document' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    async getAllSessions(@Query() sessionQueryDto: QueryAllDto) {
        return await this.sessionService.findAll(sessionQueryDto);
    }

    @Get(':id')
    @ApiResponse({ status: 200, description: 'get session by specific id' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    getSessionById(@Param('id', ParseObjectIdPipe) id: string) {
        return this.sessionService.findById(id);
    }

    @Get('user/:userId')
    @ApiResponse({ status: 200, description: 'get all session by specific user id' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    getSessionByUserId(@Param('userId', ParseObjectIdPipe) userId: string) {
        return this.sessionService.findByUserId(userId);
    }

    @Get('lesson/:lessonId')
    @ApiResponse({ status: 200, description: 'get all session by specific lesson id' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    getSessionByLessonId(@Param('lessonId', ParseObjectIdPipe) lessonId: string) {
        return this.sessionService.findByLesson(lessonId);
    }

    @Get('lesson/:lessonId/user/:userId')
    @ApiResponse({ status: 200, description: 'get session by specific lesson id and user id' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    getSessionByLessonAndUserId(@Param('lessonId', ParseObjectIdPipe) lessonId: string, @Param('userId', ParseObjectIdPipe) userId: string) {
        return this.sessionService.findByLessonAndUser(lessonId, userId);
    }

    // TODO: Authorization for this route should be added in the future
    @Post()
    @ApiResponse({ status: 200, description: 'create a session' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    createSession(@Body() createSessionDto: CreateSessionDto) {
        return this.sessionService.create(createSessionDto);
    }

    // TODO: Authorization for this route should be added in the future
    @Patch(':id')
    @ApiResponse({ status: 200, description: 'update a session' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    updateSessionById(@Param('id', ParseObjectIdPipe) id: string, @Body() updateSessionDto: UpdateSessionDto) {
        return this.sessionService.update(id, updateSessionDto);
    }

    // TODO: Authorization for this route should be added in the future
    @Delete(':id')
    @ApiResponse({ status: 200, description: 'delete a session' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    deleteSessionById(@Param('id', ParseObjectIdPipe) id: string) {
        return this.sessionService.delete(id);
    }
}

import { Body, Controller, Delete, Get, Param, Patch, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiResponse, ApiTags } from '@nestjs/swagger';
import { LessonService } from './lesson.service';
import { QueryAllDto } from 'src/common/dto/queryAllDto';
import { CreateLessonDto, UpdateLessonDto } from './dto/lesson.dto';
import { ParseObjectIdPipe } from 'src/common/pipes/parse-object-id.pipe';

@ApiBearerAuth()
@ApiTags('Lesson')
@Controller('lesson')
export class LessonController {
    constructor(private readonly lessonService:LessonService) {}

    @Get()
    @ApiResponse({ status: 200, description: 'get all lesson document' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    async getAllLessons(@Query() lessQueryDto:QueryAllDto) {
        return await this.lessonService.findAll(lessQueryDto);
    }

    @Get(':id')
    @ApiResponse({ status: 200, description: 'get lesson by specific id' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    getLessonById(@Param('id', ParseObjectIdPipe) id:string) {
        return this.lessonService.findById(id);
    }

    // TODO: Authorization for this route should be added in the future
    @Patch(':id')
    @ApiResponse({ status: 200, description: 'update a lesson' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    updateLessonById(@Param('id', ParseObjectIdPipe) id:string, @Body() updateLessonDto:UpdateLessonDto) {
        return this.lessonService.update(id, updateLessonDto);
    }

    // TODO: Authorization for this route should be added in the future
    @Post()
    @ApiResponse({ status: 200, description: 'create a lesson' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    createLesson(@Body() createLessonDto:CreateLessonDto) {
        return this.lessonService.create(createLessonDto);
    }

    // TODO: Authorization for this route should be added in the future
    @Delete(':id')
    @ApiResponse({ status: 200, description: 'delete a lesson' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    deleteLessonById(@Param('id', ParseObjectIdPipe) id:string) {
        return this.lessonService.delete(id);
    }

}

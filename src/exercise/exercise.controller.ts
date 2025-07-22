import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UsePipes, ValidationPipe } from '@nestjs/common';
import { ApiBearerAuth, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { ExerciseService } from './exercise.service';
import { ParseObjectIdPipe } from 'src/common/pipes/parse-object-id.pipe';
import { QueryAllDto } from 'src/common/dto/queryAllDto';
import { CreateExerciseDto, GetByDifficultAndTagDto, UpdateExerciseDto } from './dto/exercise.dto';

@ApiBearerAuth()
@ApiTags('Exercise')
@Controller('exercise')
export class ExerciseController {
    constructor(private readonly exerciseService: ExerciseService) { }

    @Get('tag-and-difficult')
    @ApiQuery({ name: 'tag', type: String })
    @ApiQuery({ name: 'difficult', type: String })
    @ApiResponse({ status: 200, description: 'get exercise by tag and difficult' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    getByTagAndDifficult(@Query() getByDifficultAndTagDto: GetByDifficultAndTagDto) {
        return this.exerciseService.getByTagAndDifficult(getByDifficultAndTagDto);
    
    }
    @Get()
    @ApiResponse({ status: 200, description: 'get all exercise document' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    getAllExercise(@Query() exerciseQueryDto: QueryAllDto) {
        return this.exerciseService.findAll(exerciseQueryDto);
    }

    @Get(':id')
    @ApiResponse({ status: 200, description: 'get exercise by specific id' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    getExerciseById(@Param('id', ParseObjectIdPipe) id: string) {

        return this.exerciseService.findById(id);
    }

    // TODO: Authorization for this route should be added in the future
    @Post()
    @ApiResponse({ status: 200, description: 'create a exercise' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    createExercise(@Body() createExerciseDto: CreateExerciseDto) {
        return this.exerciseService.create(createExerciseDto);
    }

    // TODO: Authorization for this route should be added in the future
    @Patch(':id')
    @ApiResponse({ status: 200, description: 'update a exercise' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    updateExerciseById(@Param('id', ParseObjectIdPipe) id: string, @Body() updateExerciseDto: UpdateExerciseDto) {
        return this.exerciseService.update(id, updateExerciseDto);
    }

    // TODO: Authorization for this route should be added in the future
    @Delete(':id')
    @ApiResponse({ status: 200, description: 'delete a exercise' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    deleteExerciseById(@Param('id', ParseObjectIdPipe) id: string) {
        return this.exerciseService.delete(id);
    }

}

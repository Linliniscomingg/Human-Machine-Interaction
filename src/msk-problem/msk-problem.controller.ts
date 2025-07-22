import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, Patch, Post, Query } from '@nestjs/common';
import { MskProblemService } from './msk-problem.service';
import { ParseObjectIdPipe } from 'src/common/pipes/parse-object-id.pipe';
import { CreateMskProblemDto, UpdateMskProblemDto } from './dto/msk-problem.dto';
import { ApiBearerAuth, ApiResponse } from '@nestjs/swagger';
import { QueryAllDto } from 'src/common/dto/queryAllDto';

@ApiBearerAuth()
@Controller('msk-problem')
export class MskProblemController {
    constructor(private readonly mskProblemService:MskProblemService) {}

    @Get()
    @ApiResponse({ status: 200, description: 'get all mskProblem document' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    @HttpCode(HttpStatus.OK)
    getAllMskProblems(@Query() mskProblemQueryDto: QueryAllDto) {
        return this.mskProblemService.findAll(mskProblemQueryDto);
    }

    @Get(':id')
    @ApiResponse({ status: 200, description: 'get mskProblem with specific id' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    @HttpCode(HttpStatus.OK)
    getMskProblemById(@Param('id',ParseObjectIdPipe) id: string) {
        return this.mskProblemService.findById(id);
    }

    // TODO: Authorization for this route should be added in the future
    @Post()
    @ApiResponse({ status: 200, description: 'create a new mskProblem' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    createMskProblem(@Body() createMskProblemDto: CreateMskProblemDto) {
        return this.mskProblemService.create(createMskProblemDto);
    }

    // TODO: Authorization for this route should be added in the future
    @Patch(':id')
    @ApiResponse({ status: 200, description: 'update a mskProblem' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    updateMskProblem(@Param('id',ParseObjectIdPipe) id: string, @Body() updateMskProblemDto: UpdateMskProblemDto) {
        return this.mskProblemService.update(id, updateMskProblemDto);
    }
    
    // TODO: Authorization for this route should be added in the future
    @Delete(':id')
    @ApiResponse({ status: 200, description: 'delete a mskProblem' })
    @ApiResponse({ status: 401, description: 'Unauthorized' })
    deleteMskProblem(@Param('id',ParseObjectIdPipe) id: string) {
        return this.mskProblemService.delete(id);
    }
}

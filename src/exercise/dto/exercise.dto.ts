import { IsArray, IsMongoId, IsOptional, IsString} from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class CreateExerciseDto {
    @ApiProperty()
    @IsOptional()
    name: string

    @ApiProperty()
    @IsOptional()
    description: string;

    @ApiProperty()
    @IsOptional()
    videoUrl: string;

    @ApiProperty()
    @IsOptional()
    imageUrl: string;

    @ApiProperty()
    @IsOptional()
    @IsArray()
    guideSteps: [string];

    @ApiProperty()
    @IsOptional()
    @IsArray()
    tags: [string];

    @ApiProperty()
    @IsOptional()
    @IsMongoId()
    createdBy: string;

    @ApiProperty()
    @IsOptional()
    duration: number;   

    @ApiProperty()
    @IsOptional()   
    numberOfReps: number;   

    @ApiProperty()
    @IsOptional()
    difficulty: string; 
}

export class GetByDifficultAndTagDto{
    @ApiProperty()
    @IsOptional()
    tag: string;

    @ApiProperty()
    @IsOptional()
    difficult: string;
}

export class UpdateExerciseDto extends CreateExerciseDto { }
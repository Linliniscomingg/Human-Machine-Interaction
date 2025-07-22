import { ApiProperty } from "@nestjs/swagger";
import { IsArray, IsMongoId, IsNotEmpty, IsOptional } from "class-validator";

export class CreateLessonDto{
    @ApiProperty()
    @IsOptional()
    name: string;

    @ApiProperty()
    @IsOptional()
    description: string;

    @ApiProperty()
    @IsOptional()
    difficulty: string;

    @ApiProperty()
    @IsOptional()
    imgUrl: string;

    @ApiProperty()
    @IsOptional()
    videoUrl: string;

    @ApiProperty()
    @IsOptional()
    bodyPart: string;

    @ApiProperty()
    @IsOptional()
    duration: number;

    @ApiProperty()
    @IsOptional()
    @IsArray()
    @IsMongoId({ each: true })
    exercises: string[];
}


export class UpdateLessonDto extends CreateLessonDto{}
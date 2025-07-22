import { IsBoolean, IsInt, IsMongoId, IsNotEmpty, IsOptional } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class CreateSessionDto {
    @ApiProperty()
    @IsOptional()
    name: string;

    @ApiProperty()
    @IsOptional()
    @IsMongoId()
    lessonId: string;

    @ApiProperty()
    @IsOptional()
    @IsMongoId()
    userId: string;

    @ApiProperty()
    @IsOptional()
    @IsInt()
    excerciseFinish: number = 0;

    @ApiProperty()
    @IsOptional()
    @IsBoolean()
    isFinished: boolean = false;
}

export class UpdateSessionDto extends CreateSessionDto { }


import { IsArray, IsIn, IsInt, IsMongoId, IsNotEmpty, IsOptional, IsString, Min, ValidateNested } from "class-validator";
import { IProfile } from "../interfaces/users.interface";
import { Type } from "class-transformer";
import { ApiProperty } from "@nestjs/swagger";

export class CreateUserDto {
    @ApiProperty()
    @IsNotEmpty()
    username: string;

    @ApiProperty()
    @IsNotEmpty()
    password: string;
}

export class UpdateUserDto {
    @ApiProperty({
        description: 'User profile information',
        type: () => UserProfileDto,
        required: false,
    })
    @ValidateNested()
    @IsOptional()
    @Type(() => UserProfileDto)
    userProfile: IProfile;

    @ApiProperty({
        description: 'List of mental skill problem IDs (Following MongoDB ObjectID format)',
        example: ['507f1f77bcf86cd799439011', '507f1f77bcf86cd799439012'],
        type: String,
        isArray: true,
        required: false,
    })
    @IsArray()
    @IsOptional()
    @IsMongoId({ each: true })
    mskProblems: string[];
}

export class UserProfileDto implements IProfile {
    @ApiProperty()
    @IsOptional()
    firstName: string;

    @ApiProperty()
    @IsOptional()
    lastName: string;

    @ApiProperty()
    @IsOptional()
    phoneNumber: string;

    @ApiProperty()
    @IsOptional()
    weight: number;

    @ApiProperty()
    @IsOptional()
    height: number;

    @ApiProperty()
    @IsOptional()
    dateOfBirth: Date;

    @ApiProperty()
    @IsOptional()
    gender: "male" | "female";

    @ApiProperty()
    @IsOptional()
    address: string;

    @ApiProperty()
    @IsOptional()
    avatar: string
}

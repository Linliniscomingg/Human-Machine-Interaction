
import {
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Post,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { Public } from 'src/common/decorators/publicAPI.decorator';
import { LoginDto } from './dto/auth.dto';
import { ApiResponse, ApiTags } from '@nestjs/swagger';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) { }

  @HttpCode(HttpStatus.OK)
  @Public()
  @Post('login')
  @ApiResponse({ status: 200, description: 'access_token: some token' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  logIn(@Body() loginDto: LoginDto) {
    return this.authService.logIn(loginDto);
  }

  @Public()
  @Post('signup')
  @ApiResponse({ status: 200, description: 'access_token: some token' })
  @ApiResponse({ status: 409, description: 'message: Username already exists' })
  signUp(@Body() signUpDto: LoginDto) {
    return this.authService.signUp(signUpDto);
  }
}

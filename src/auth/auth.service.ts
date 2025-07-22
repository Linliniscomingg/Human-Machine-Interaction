
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { checkPassword } from 'src/utils';
import { LoginDto, SignUpDto } from './dto/auth.dto';

@Injectable()
export class AuthService {
  constructor(private usersService: UsersService, private jwtService: JwtService) {}

  async logIn(loginDto:LoginDto): Promise<any> {
    const user = await this.usersService.findOne(loginDto.username);
    if (!await checkPassword(loginDto.password, user.password)) {
      throw new UnauthorizedException();
    }
    const payload = { sub:user.username, username: user.username };
    return {
      access_token: await this.jwtService.signAsync(payload),
    };
  }

  async signUp(signUpDto:SignUpDto): Promise<any> {
    const user = await this.usersService.create(signUpDto);
     const payload = { sub:user.username, username: user.username };
     return {
       access_token: await this.jwtService.signAsync(payload),
     };
  }
}
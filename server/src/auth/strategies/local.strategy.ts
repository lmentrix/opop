import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-local';
import { AuthService } from '../services/auth.service';
import { User } from '@/user/entities/user.entity';

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly authService: AuthService) {
    super({
      usernameField: 'emailOrUsername',
      passwordField: 'password',
    });
  }

  async validate(emailOrUsername: string, password: string): Promise<User> {
    try {
      const result = await this.authService.login(
        { emailOrUsername, password },
      );
      // Return a mock user object for local strategy validation
      // The actual login logic is handled in the controller
      return {} as User;
    } catch (error) {
      throw new UnauthorizedException('Invalid credentials');
    }
  }
}
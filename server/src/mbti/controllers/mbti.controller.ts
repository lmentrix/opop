import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { MBTIService } from '../services/mbti.service';

@ApiTags('MBTI')
@Controller('mbti')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth('JWT-auth')
export class MBTIController {
  constructor(private readonly mbtiService: MBTIService) {}

  @Get()
  async getMBTI() {
    return { message: 'MBTI controller placeholder' };
  }
}
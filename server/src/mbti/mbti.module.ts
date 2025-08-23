import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { MBTIController } from './controllers/mbti.controller';
import { MBTIService } from './services/mbti.service';
import { MBTIProfile } from './entities/mbti-profile.entity';
import { Assessment } from './entities/assessment.entity';
import { CompatibilityScore } from './entities/compatibility-score.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([MBTIProfile, Assessment, CompatibilityScore]),
  ],
  controllers: [MBTIController],
  providers: [MBTIService],
  exports: [MBTIService],
})
export class MBTIModule {}
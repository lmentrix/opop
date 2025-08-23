import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MBTIProfile } from '../entities/mbti-profile.entity';

@Injectable()
export class MBTIService {
  constructor(
    @InjectRepository(MBTIProfile)
    private readonly mbtiProfileRepository: Repository<MBTIProfile>,
  ) {}

  async getProfileByUserId(userId: string): Promise<MBTIProfile> {
    return this.mbtiProfileRepository.findOne({
      where: { userId },
      relations: ['assessmentHistory', 'compatibilityScoresAsUser1', 'compatibilityScoresAsUser2'],
    });
  }
}
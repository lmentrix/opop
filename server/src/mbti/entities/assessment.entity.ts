import { Entity, Column, ManyToOne, JoinColumn } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@/common/entities/base.entity';
import { MBTIType } from '@/common/enums/mbti-type.enum';
import { MBTIProfile } from './mbti-profile.entity';

@Entity('assessments')
export class Assessment extends BaseEntity {
  @ApiProperty({ description: 'MBTI Profile ID' })
  @Column()
  mbtiProfileId: string;

  @ApiProperty({ 
    description: 'Assessment result type',
    enum: MBTIType 
  })
  @Column({
    type: 'enum',
    enum: MBTIType,
  })
  resultType: MBTIType;

  @ApiProperty({ description: 'Assessment confidence score (0-100)' })
  @Column({ type: 'decimal', precision: 5, scale: 2 })
  confidence: number;

  @ApiProperty({ description: 'Assessment version or source' })
  @Column({ default: '1.0' })
  version: string;

  @ApiProperty({ description: 'Assessment duration in seconds' })
  @Column({ nullable: true })
  duration?: number;

  @ApiProperty({ description: 'Raw assessment responses' })
  @Column({ type: 'jsonb' })
  responses: Record<string, any>;

  @ApiProperty({ description: 'Calculated scores for each dimension' })
  @Column({ type: 'jsonb' })
  dimensionScores: {
    extraversion: number;
    sensing: number;
    thinking: number;
    judging: number;
  };

  @ApiProperty({ description: 'Assessment metadata' })
  @Column({ type: 'jsonb', nullable: true })
  metadata?: {
    ipAddress?: string;
    userAgent?: string;
    completionTime?: Date;
    questionsAnswered?: number;
    totalQuestions?: number;
  };

  // Relations
  @ManyToOne(() => MBTIProfile, (profile) => profile.assessmentHistory, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'mbtiProfileId' })
  mbtiProfile: MBTIProfile;
}
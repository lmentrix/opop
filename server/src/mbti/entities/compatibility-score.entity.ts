import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@/common/entities/base.entity';
import { MBTIProfile } from './mbti-profile.entity';

@Entity('compatibility_scores')
@Index(['user1ProfileId', 'user2ProfileId'], { unique: true })
export class CompatibilityScore extends BaseEntity {
  @ApiProperty({ description: 'First user MBTI profile ID' })
  @Column()
  user1ProfileId: string;

  @ApiProperty({ description: 'Second user MBTI profile ID' })
  @Column()
  user2ProfileId: string;

  @ApiProperty({ description: 'Overall compatibility score (0-100)' })
  @Column({ type: 'decimal', precision: 5, scale: 2 })
  overallScore: number;

  @ApiProperty({ description: 'Communication compatibility' })
  @Column({ type: 'decimal', precision: 5, scale: 2 })
  communicationScore: number;

  @ApiProperty({ description: 'Work style compatibility' })
  @Column({ type: 'decimal', precision: 5, scale: 2 })
  workStyleScore: number;

  @ApiProperty({ description: 'Values compatibility' })
  @Column({ type: 'decimal', precision: 5, scale: 2 })
  valuesScore: number;

  @ApiProperty({ description: 'Conflict resolution compatibility' })
  @Column({ type: 'decimal', precision: 5, scale: 2 })
  conflictResolutionScore: number;

  @ApiProperty({ description: 'Detailed compatibility analysis' })
  @Column({ type: 'jsonb', nullable: true })
  analysis?: {
    strengths?: string[];
    challenges?: string[];
    suggestions?: string[];
    compatibilityType?: 'excellent' | 'good' | 'moderate' | 'challenging';
  };

  @ApiProperty({ description: 'Score calculation metadata' })
  @Column({ type: 'jsonb', nullable: true })
  metadata?: {
    calculatedAt: Date;
    algorithm: string;
    version: string;
  };

  // Relations
  @ManyToOne(() => MBTIProfile, (profile) => profile.compatibilityScoresAsUser1, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'user1ProfileId' })
  user1Profile: MBTIProfile;

  @ManyToOne(() => MBTIProfile, (profile) => profile.compatibilityScoresAsUser2, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'user2ProfileId' })
  user2Profile: MBTIProfile;
}
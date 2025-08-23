import { Entity, Column, ManyToOne, JoinColumn, OneToMany, Index } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@/common/entities/base.entity';
import { MBTIType, CognitiveFunction } from '@/common/enums/mbti-type.enum';
import { User } from '@/user/entities/user.entity';
import { Assessment } from './assessment.entity';
import { CompatibilityScore } from './compatibility-score.entity';

@Entity('mbti_profiles')
@Index(['userId'], { unique: true })
export class MBTIProfile extends BaseEntity {
  @ApiProperty({ description: 'User ID' })
  @Column()
  userId: string;

  @ApiProperty({ 
    description: 'Primary MBTI type',
    enum: MBTIType 
  })
  @Column({
    type: 'enum',
    enum: MBTIType,
  })
  primaryType: MBTIType;

  @ApiProperty({ 
    description: 'Cognitive function stack',
    type: [String]
  })
  @Column({
    type: 'simple-array',
    transformer: {
      to: (value: CognitiveFunction[]) => value?.join(','),
      from: (value: string) => value ? value.split(',') as CognitiveFunction[] : [],
    },
  })
  cognitiveStack: CognitiveFunction[];

  @ApiProperty({ description: 'Confidence level in assessment (0-100)' })
  @Column({ type: 'decimal', precision: 5, scale: 2, default: 0 })
  confidence: number;

  @ApiProperty({ description: 'Last assessment date' })
  @Column({ type: 'timestamp with time zone' })
  lastAssessment: Date;

  @ApiProperty({ description: 'Total number of assessments taken' })
  @Column({ default: 1 })
  assessmentCount: number;

  @ApiProperty({ description: 'Detailed personality insights' })
  @Column({ type: 'jsonb', nullable: true })
  insights?: {
    strengths?: string[];
    weaknesses?: string[];
    workStyle?: string;
    communicationStyle?: string;
    stressResponse?: string;
    learningStyle?: string;
  };

  @ApiProperty({ description: 'MBTI type history' })
  @Column({ type: 'jsonb', default: [] })
  typeHistory: {
    type: MBTIType;
    confidence: number;
    assessmentDate: Date;
  }[];

  // Relations
  @ManyToOne(() => User, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'userId' })
  user: User;

  @OneToMany(() => Assessment, (assessment) => assessment.mbtiProfile)
  assessmentHistory: Assessment[];

  @OneToMany(() => CompatibilityScore, (score) => score.user1Profile)
  compatibilityScoresAsUser1: CompatibilityScore[];

  @OneToMany(() => CompatibilityScore, (score) => score.user2Profile)
  compatibilityScoresAsUser2: CompatibilityScore[];
}
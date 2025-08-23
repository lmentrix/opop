import { Entity, Column, OneToOne, JoinColumn, OneToMany } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@/common/entities/base.entity';
import { User } from './user.entity';
import { Achievement } from './achievement.entity';

@Entity('user_profiles')
export class UserProfile extends BaseEntity {
  @ApiProperty({ description: 'User ID' })
  @Column()
  userId: string;

  @ApiProperty({ description: 'Display name' })
  @Column({ length: 100 })
  displayName: string;

  @ApiProperty({ description: 'Full name' })
  @Column({ length: 200, nullable: true })
  fullName?: string;

  @ApiProperty({ description: 'Avatar URL or emoji' })
  @Column({ nullable: true })
  avatar?: string;

  @ApiProperty({ description: 'User biography' })
  @Column({ type: 'text', nullable: true })
  bio?: string;

  @ApiProperty({ description: 'Location' })
  @Column({ nullable: true })
  location?: string;

  @ApiProperty({ description: 'Date when user joined (formatted)' })
  @Column({ nullable: true })
  joinDate?: string;

  @ApiProperty({ description: 'Personality description' })
  @Column({ type: 'text', nullable: true })
  personalityDescription?: string;

  @ApiProperty({ description: 'User strengths', type: [String] })
  @Column({ type: 'simple-array', nullable: true })
  strengths?: string[];

  @ApiProperty({ description: 'User weaknesses', type: [String] })
  @Column({ type: 'simple-array', nullable: true })
  weaknesses?: string[];

  @ApiProperty({ description: 'Assessment count' })
  @Column({ default: 0 })
  assessmentCount: number;

  @ApiProperty({ description: 'Conversation count' })
  @Column({ default: 0 })
  conversationCount: number;

  @ApiProperty({ description: 'Achievement count' })
  @Column({ default: 0 })
  achievementCount: number;

  @ApiProperty({ 
    description: 'User preferences', 
    type: 'object',
    additionalProperties: true
  })
  @Column({ type: 'jsonb', default: {} })
  preferences: Record<string, any>;

  @ApiProperty({ description: 'Profile visibility settings' })
  @Column({ type: 'jsonb', default: {} })
  privacySettings: {
    profileVisibility?: 'public' | 'private' | 'friends';
    showOnlineStatus?: boolean;
    allowDirectMessages?: boolean;
  };

  // Relations
  @OneToOne(() => User, (user) => user.profile, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'userId' })
  user: User;

  @OneToMany(() => Achievement, (achievement) => achievement.userProfile)
  achievements: Achievement[];
}
import { Entity, Column, ManyToOne, JoinColumn } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@/common/entities/base.entity';
import { UserProfile } from './user-profile.entity';

@Entity('achievements')
export class Achievement extends BaseEntity {
  @ApiProperty({ description: 'User profile ID' })
  @Column()
  userProfileId: string;

  @ApiProperty({ description: 'Achievement name' })
  @Column({ length: 100 })
  name: string;

  @ApiProperty({ description: 'Achievement description' })
  @Column({ type: 'text' })
  description: string;

  @ApiProperty({ description: 'Achievement icon' })
  @Column()
  icon: string;

  @ApiProperty({ description: 'Achievement color theme' })
  @Column()
  color: string;

  @ApiProperty({ description: 'Date when achievement was unlocked' })
  @Column({ type: 'timestamp with time zone' })
  unlockedAt: Date;

  @ApiProperty({ description: 'Achievement category' })
  @Column({ nullable: true })
  category?: string;

  @ApiProperty({ description: 'Achievement points value' })
  @Column({ default: 0 })
  points: number;

  @ApiProperty({ description: 'Achievement rarity level' })
  @Column({ 
    type: 'enum',
    enum: ['common', 'rare', 'epic', 'legendary'],
    default: 'common'
  })
  rarity: 'common' | 'rare' | 'epic' | 'legendary';

  // Relations
  @ManyToOne(() => UserProfile, (profile) => profile.achievements, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'userProfileId' })
  userProfile: UserProfile;
}
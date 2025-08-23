import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@/common/entities/base.entity';
import { User } from './user.entity';

@Entity('refresh_tokens')
@Index(['token'], { unique: true })
@Index(['userId', 'isRevoked'])
export class RefreshToken extends BaseEntity {
  @ApiProperty({ description: 'Refresh token value' })
  @Column({ unique: true })
  token: string;

  @ApiProperty({ description: 'User ID' })
  @Column()
  userId: string;

  @ApiProperty({ description: 'Token expiration date' })
  @Column({ type: 'timestamp with time zone' })
  expiresAt: Date;

  @ApiProperty({ description: 'Whether token is revoked' })
  @Column({ default: false })
  isRevoked: boolean;

  @ApiProperty({ description: 'IP address where token was created' })
  @Column({ nullable: true })
  ipAddress?: string;

  @ApiProperty({ description: 'User agent where token was created' })
  @Column({ nullable: true })
  userAgent?: string;

  @ApiProperty({ description: 'Token revocation date' })
  @Column({ type: 'timestamp with time zone', nullable: true })
  revokedAt?: Date;

  @ApiProperty({ description: 'Reason for token revocation' })
  @Column({ nullable: true })
  revocationReason?: string;

  // Relations
  @ManyToOne(() => User, (user) => user.refreshTokens, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'userId' })
  user: User;
}
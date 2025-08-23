import { Entity, Column, OneToMany, OneToOne, Index } from 'typeorm';
import { Exclude } from 'class-transformer';
import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@/common/entities/base.entity';
import { UserStatus, UserRole, OnlineStatus } from '@/common/enums/user-status.enum';
import { MBTIType } from '@/common/enums/mbti-type.enum';
import { RefreshToken } from './refresh-token.entity';
import { UserProfile } from './user-profile.entity';
import { Message } from '@/chat/entities/message.entity';
import { ChatRoomParticipant } from '@/chat/entities/chat-room-participant.entity';

@Entity('users')
@Index(['email'], { unique: true })
@Index(['username'], { unique: true })
export class User extends BaseEntity {
  @ApiProperty({ description: 'User email address' })
  @Column({ unique: true })
  email: string;

  @ApiProperty({ description: 'Username' })
  @Column({ unique: true, length: 50 })
  username: string;

  @Exclude()
  @Column()
  passwordHash: string;

  @ApiProperty({ 
    description: 'MBTI personality type',
    enum: MBTIType,
    required: false 
  })
  @Column({
    type: 'enum',
    enum: MBTIType,
    nullable: true,
  })
  mbtiType?: MBTIType;

  @ApiProperty({ 
    description: 'Account verification status',
    default: false 
  })
  @Column({ default: false })
  isVerified: boolean;

  @ApiProperty({ 
    description: 'User account status',
    enum: UserStatus,
    default: UserStatus.ACTIVE 
  })
  @Column({
    type: 'enum',
    enum: UserStatus,
    default: UserStatus.ACTIVE,
  })
  status: UserStatus;

  @ApiProperty({ 
    description: 'User role',
    enum: UserRole,
    default: UserRole.USER 
  })
  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.USER,
  })
  role: UserRole;

  @ApiProperty({ 
    description: 'Online status',
    enum: OnlineStatus,
    default: OnlineStatus.OFFLINE 
  })
  @Column({
    type: 'enum',
    enum: OnlineStatus,
    default: OnlineStatus.OFFLINE,
  })
  onlineStatus: OnlineStatus;

  @ApiProperty({ 
    description: 'Last activity timestamp',
    required: false 
  })
  @Column({ 
    type: 'timestamp with time zone', 
    nullable: true 
  })
  lastActiveAt?: Date;

  @ApiProperty({ 
    description: 'Email verification token',
    required: false 
  })
  @Column({ nullable: true })
  @Exclude()
  emailVerificationToken?: string;

  @ApiProperty({ 
    description: 'Password reset token',
    required: false 
  })
  @Column({ nullable: true })
  @Exclude()
  passwordResetToken?: string;

  @ApiProperty({ 
    description: 'Password reset token expiration',
    required: false 
  })
  @Column({ 
    type: 'timestamp with time zone', 
    nullable: true 
  })
  @Exclude()
  passwordResetExpires?: Date;

  // Relations
  @OneToMany(() => RefreshToken, (refreshToken) => refreshToken.user, {
    cascade: true,
  })
  @Exclude()
  refreshTokens: RefreshToken[];

  @OneToOne(() => UserProfile, (profile) => profile.user, {
    cascade: true,
    eager: true,
  })
  profile: UserProfile;

  @OneToMany(() => Message, (message) => message.sender)
  messages: Message[];

  @OneToMany(() => ChatRoomParticipant, (participant) => participant.user)
  chatParticipations: ChatRoomParticipant[];
}
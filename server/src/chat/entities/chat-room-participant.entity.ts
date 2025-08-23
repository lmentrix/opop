import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@/common/entities/base.entity';
import { User } from '@/user/entities/user.entity';
import { ChatRoom } from './chat-room.entity';

export enum ParticipantRole {
  MEMBER = 'member',
  MODERATOR = 'moderator',
  ADMIN = 'admin',
}

export enum ParticipantStatus {
  ACTIVE = 'active',
  LEFT = 'left',
  KICKED = 'kicked',
  BANNED = 'banned',
}

@Entity('chat_room_participants')
@Index(['chatRoomId', 'userId'], { unique: true })
@Index(['userId', 'status'])
export class ChatRoomParticipant extends BaseEntity {
  @ApiProperty({ description: 'Chat room ID' })
  @Column()
  chatRoomId: string;

  @ApiProperty({ description: 'User ID' })
  @Column()
  userId: string;

  @ApiProperty({ 
    description: 'Participant role',
    enum: ParticipantRole 
  })
  @Column({
    type: 'enum',
    enum: ParticipantRole,
    default: ParticipantRole.MEMBER,
  })
  role: ParticipantRole;

  @ApiProperty({ 
    description: 'Participant status',
    enum: ParticipantStatus 
  })
  @Column({
    type: 'enum',
    enum: ParticipantStatus,
    default: ParticipantStatus.ACTIVE,
  })
  status: ParticipantStatus;

  @ApiProperty({ description: 'Date when user joined the chat room' })
  @Column({ type: 'timestamp with time zone' })
  joinedAt: Date;

  @ApiProperty({ description: 'Date when user left the chat room' })
  @Column({ 
    type: 'timestamp with time zone', 
    nullable: true 
  })
  leftAt?: Date;

  @ApiProperty({ description: 'Last time user read messages' })
  @Column({ 
    type: 'timestamp with time zone', 
    nullable: true 
  })
  lastReadAt?: Date;

  @ApiProperty({ description: 'Custom nickname in this chat room' })
  @Column({ length: 100, nullable: true })
  nickname?: string;

  @ApiProperty({ description: 'User permissions in this chat room' })
  @Column({ type: 'jsonb', default: {} })
  permissions: {
    canSendMessages?: boolean;
    canSendMedia?: boolean;
    canMentionAll?: boolean;
    canInviteUsers?: boolean;
    canKickUsers?: boolean;
    canBanUsers?: boolean;
    canDeleteMessages?: boolean;
  };

  @ApiProperty({ description: 'Notification settings for this chat room' })
  @Column({ type: 'jsonb', default: {} })
  notificationSettings: {
    muteUntil?: Date;
    pushNotifications?: boolean;
    emailNotifications?: boolean;
    mentionNotifications?: boolean;
  };

  // Relations
  @ManyToOne(() => User, (user) => user.chatParticipations, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'userId' })
  user: User;

  @ManyToOne(() => ChatRoom, (chatRoom) => chatRoom.participants, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'chatRoomId' })
  chatRoom: ChatRoom;
}
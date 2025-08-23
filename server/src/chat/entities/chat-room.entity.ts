import { Entity, Column, OneToMany, Index } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@/common/entities/base.entity';
import { ChatRoomType } from '@/common/enums/message-type.enum';
import { Message } from './message.entity';
import { ChatRoomParticipant } from './chat-room-participant.entity';

@Entity('chat_rooms')
@Index(['type', 'isActive'])
export class ChatRoom extends BaseEntity {
  @ApiProperty({ 
    description: 'Chat room type',
    enum: ChatRoomType 
  })
  @Column({
    type: 'enum',
    enum: ChatRoomType,
  })
  type: ChatRoomType;

  @ApiProperty({ description: 'Chat room name' })
  @Column({ length: 100, nullable: true })
  name?: string;

  @ApiProperty({ description: 'Chat room description' })
  @Column({ type: 'text', nullable: true })
  description?: string;

  @ApiProperty({ description: 'Chat room avatar/image' })
  @Column({ nullable: true })
  avatar?: string;

  @ApiProperty({ description: 'Whether the chat room is active' })
  @Column({ default: true })
  isActive: boolean;

  @ApiProperty({ description: 'Maximum number of participants' })
  @Column({ nullable: true })
  maxParticipants?: number;

  @ApiProperty({ description: 'MBTI context for personality matching' })
  @Column({ type: 'jsonb', nullable: true })
  mbtiContext?: {
    targetTypes?: string[];
    compatibilityThreshold?: number;
    suggestedTopics?: string[];
    personalityFocus?: string;
  };

  @ApiProperty({ description: 'Chat room settings' })
  @Column({ type: 'jsonb', default: {} })
  settings: {
    allowFileSharing?: boolean;
    allowVoiceMessages?: boolean;
    moderationLevel?: 'none' | 'basic' | 'strict';
    autoDeleteMessages?: boolean;
    autoDeleteAfterDays?: number;
  };

  @ApiProperty({ description: 'Last activity timestamp' })
  @Column({ 
    type: 'timestamp with time zone', 
    nullable: true 
  })
  lastActivityAt?: Date;

  @ApiProperty({ description: 'Room creator user ID' })
  @Column({ nullable: true })
  createdBy?: string;

  // Relations
  @OneToMany(() => Message, (message) => message.chatRoom)
  messages: Message[];

  @OneToMany(() => ChatRoomParticipant, (participant) => participant.chatRoom)
  participants: ChatRoomParticipant[];
}
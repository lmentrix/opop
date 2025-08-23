import { Entity, Column, ManyToOne, JoinColumn, OneToMany, Index } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@/common/entities/base.entity';
import { MessageType } from '@/common/enums/message-type.enum';
import { User } from '@/user/entities/user.entity';
import { ChatRoom } from './chat-room.entity';
import { MessageRead } from './message-read.entity';

@Entity('messages')
@Index(['chatRoomId', 'createdAt'])
@Index(['senderId'])
export class Message extends BaseEntity {
  @ApiProperty({ description: 'Chat room ID' })
  @Column()
  chatRoomId: string;

  @ApiProperty({ description: 'Sender user ID' })
  @Column()
  senderId: string;

  @ApiProperty({ description: 'Message content (encrypted)' })
  @Column({ type: 'text' })
  content: string;

  @ApiProperty({ 
    description: 'Message type',
    enum: MessageType 
  })
  @Column({
    type: 'enum',
    enum: MessageType,
    default: MessageType.TEXT,
  })
  type: MessageType;

  @ApiProperty({ description: 'Message metadata' })
  @Column({ type: 'jsonb', nullable: true })
  metadata?: {
    fileUrl?: string;
    fileName?: string;
    fileSize?: number;
    mimeType?: string;
    thumbnailUrl?: string;
    aiContext?: {
      prompt?: string;
      model?: string;
      confidence?: number;
    };
    editedAt?: Date;
    originalContent?: string;
    replyTo?: string;
    mentions?: string[];
    reactions?: {
      emoji: string;
      userIds: string[];
      count: number;
    }[];
  };

  @ApiProperty({ description: 'Whether message is edited' })
  @Column({ default: false })
  isEdited: boolean;

  @ApiProperty({ description: 'Whether message is deleted' })
  @Column({ default: false })
  isDeleted: boolean;

  @ApiProperty({ description: 'Message edited timestamp' })
  @Column({ 
    type: 'timestamp with time zone', 
    nullable: true 
  })
  editedAt?: Date;

  @ApiProperty({ description: 'Message thread ID for replies' })
  @Column({ nullable: true })
  threadId?: string;

  @ApiProperty({ description: 'Parent message ID for replies' })
  @Column({ nullable: true })
  replyToMessageId?: string;

  // Relations
  @ManyToOne(() => User, (user) => user.messages, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'senderId' })
  sender: User;

  @ManyToOne(() => ChatRoom, (chatRoom) => chatRoom.messages, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'chatRoomId' })
  chatRoom: ChatRoom;

  @OneToMany(() => MessageRead, (messageRead) => messageRead.message)
  readBy: MessageRead[];

  @ManyToOne(() => Message, { nullable: true })
  @JoinColumn({ name: 'replyToMessageId' })
  replyToMessage?: Message;
}
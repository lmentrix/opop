import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@/common/entities/base.entity';
import { User } from '@/user/entities/user.entity';
import { Message } from './message.entity';

@Entity('message_reads')
@Index(['messageId', 'userId'], { unique: true })
@Index(['userId', 'readAt'])
export class MessageRead extends BaseEntity {
  @ApiProperty({ description: 'Message ID' })
  @Column()
  messageId: string;

  @ApiProperty({ description: 'User ID who read the message' })
  @Column()
  userId: string;

  @ApiProperty({ description: 'Timestamp when message was read' })
  @Column({ type: 'timestamp with time zone' })
  readAt: Date;

  @ApiProperty({ description: 'Additional read metadata' })
  @Column({ type: 'jsonb', nullable: true })
  metadata?: {
    device?: string;
    ipAddress?: string;
    readDuration?: number; // Time spent reading in seconds
  };

  // Relations
  @ManyToOne(() => Message, (message) => message.readBy, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'messageId' })
  message: Message;

  @ManyToOne(() => User, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'userId' })
  user: User;
}
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ChatRoom } from '../entities/chat-room.entity';
import { Message } from '../entities/message.entity';

@Injectable()
export class ChatService {
  constructor(
    @InjectRepository(ChatRoom)
    private readonly chatRoomRepository: Repository<ChatRoom>,
    @InjectRepository(Message)
    private readonly messageRepository: Repository<Message>,
  ) {}

  async getChatRoomsByUserId(userId: string): Promise<ChatRoom[]> {
    return this.chatRoomRepository.find({
      where: {
        participants: {
          userId,
          status: 'active' as any,
        },
      },
      relations: ['participants', 'messages'],
    });
  }
}
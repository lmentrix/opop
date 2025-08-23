import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { ChatController } from './controllers/chat.controller';
import { ChatService } from './services/chat.service';
import { ChatGateway } from './gateways/chat.gateway';
import { ChatRoom } from './entities/chat-room.entity';
import { Message } from './entities/message.entity';
import { ChatRoomParticipant } from './entities/chat-room-participant.entity';
import { MessageRead } from './entities/message-read.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([ChatRoom, Message, ChatRoomParticipant, MessageRead]),
  ],
  controllers: [ChatController],
  providers: [ChatService, ChatGateway],
  exports: [ChatService],
})
export class ChatModule {}
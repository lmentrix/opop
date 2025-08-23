import {
  WebSocketGateway,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger, UseGuards } from '@nestjs/common';
import { ChatService } from '../services/chat.service';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class ChatGateway {
  @WebSocketServer()
  server: Server;

  private logger = new Logger('ChatGateway');

  constructor(private readonly chatService: ChatService) {}

  @SubscribeMessage('message')
  async handleMessage(
    @MessageBody() data: any,
    @ConnectedSocket() client: Socket,
  ) {
    this.logger.log(`Message received from ${client.id}: ${JSON.stringify(data)}`);
    
    // Broadcast message to all clients (placeholder implementation)
    this.server.emit('message', {
      id: Date.now().toString(),
      ...data,
      timestamp: new Date().toISOString(),
    });
    
    return { status: 'Message sent' };
  }

  @SubscribeMessage('join-room')
  async handleJoinRoom(
    @MessageBody() data: { roomId: string },
    @ConnectedSocket() client: Socket,
  ) {
    const { roomId } = data;
    client.join(roomId);
    this.logger.log(`Client ${client.id} joined room ${roomId}`);
    
    return { status: `Joined room ${roomId}` };
  }

  @SubscribeMessage('leave-room')
  async handleLeaveRoom(
    @MessageBody() data: { roomId: string },
    @ConnectedSocket() client: Socket,
  ) {
    const { roomId } = data;
    client.leave(roomId);
    this.logger.log(`Client ${client.id} left room ${roomId}`);
    
    return { status: `Left room ${roomId}` };
  }
}
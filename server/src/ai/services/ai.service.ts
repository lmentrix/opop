import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class AIService {
  constructor(private readonly configService: ConfigService) {}

  async generateSuggestion(context: string, mbtiType?: string): Promise<string> {
    // Placeholder for OpenAI integration
    return `AI suggestion based on context: ${context} and MBTI: ${mbtiType}`;
  }
}
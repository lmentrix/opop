import { Injectable } from '@nestjs/common';

@Injectable()
export class AnalyticsService {
  async getUserAnalytics(userId: string) {
    return { message: 'Analytics service placeholder', userId };
  }
}
import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { ApiResponse } from '@/common/interfaces/api-response.interface';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(HttpExceptionFilter.name);

  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const status = exception.getStatus();

    const exceptionResponse = exception.getResponse();
    const error =
      typeof exceptionResponse === 'string'
        ? { message: exceptionResponse }
        : (exceptionResponse as any);

    const errorResponse: ApiResponse = {
      success: false,
      error: error.message || exception.message,
      timestamp: new Date().toISOString(),
      path: request.url,
    };

    // Add validation errors if present
    if (error.message && Array.isArray(error.message)) {
      errorResponse.error = error.message.join(', ');
    }

    // Log error details
    this.logger.error(
      `HTTP ${status} Error: ${errorResponse.error}`,
      {
        path: request.url,
        method: request.method,
        ip: request.ip,
        userAgent: request.get('User-Agent'),
        stack: exception.stack,
      },
    );

    response.status(status).json(errorResponse);
  }
}
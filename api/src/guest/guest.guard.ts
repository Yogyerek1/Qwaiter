import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { GuestService } from './guest.service';
import { Request, Response } from 'express';

@Injectable()
export class GuestGuard implements CanActivate {
  constructor(private readonly guestService: GuestService) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<Request>();
    const response = context.switchToHttp().getResponse<Response>();

    const token = request.cookies?.access_token;

    if (!token) {
      const newToken = this.guestService.generateGuestToken();

      response.cookie('access_token', newToken, {
        httpOnly: true,
        sameSite: 'lax',
        secure: process.env.NODE_ENV === 'production',
        maxAge: 1000 * 60 * 60 * 24,
      });
    }

    return true;
  }
}

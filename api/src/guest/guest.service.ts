import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { randomUUID } from 'crypto';

@Injectable()
export class GuestService {
  constructor(private readonly jwtService: JwtService) {}

  generateGuestToken() {
    const payload = {
      sub: randomUUID(),
      type: 'guest',
    };

    return this.jwtService.sign(payload);
  }
}

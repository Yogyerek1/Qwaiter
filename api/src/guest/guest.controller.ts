import { Controller, Get, Param, UseGuards } from '@nestjs/common';
import { GuestService } from './guest.service';
import { GuestGuard } from './guest.guard';

@Controller('guest')
export class GuestController {
  constructor(private guestService: GuestService) {}

  @UseGuards(GuestGuard)
  @Get('table/:token')
  async getTable(@Param('token') token: string) {
    return this.guestService.getTable(token);
  }
}

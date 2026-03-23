import { Injectable, NotFoundException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';
import { Table } from '../entities/table.entity';

@Injectable()
export class GuestService {
  constructor(
    private readonly jwtService: JwtService,

    @InjectRepository(Table)
    private tableRepository: Repository<Table>,
  ) {}

  generateGuestToken() {
    const payload = {
      sub: randomUUID(),
      type: 'guest',
    };

    return this.jwtService.sign(payload);
  }

  async getTable(token: string) {
    const table = await this.tableRepository.findOne({
      where: { QRCodeToken: token },
      relations: [
        'restaurant',
        'restaurant.categories',
        'restaurant.categories.items',
      ],
    });

    if (!table) {
      throw new NotFoundException('Table not found! (Invalid QR Code)');
    }

    return {
      table: {
        tableID: table.tableID,
        tableName: table.tableName,
        authCode: table.authCode,
        restaurantID: table.restaurant.restaurantID,
      },
      restaurant: {
        restaurantID: table.restaurant.restaurantID,
        restaurantName: table.restaurant.restaurantName,
      },
      menu: table.restaurant.categories,
    };
  }
}

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Restaurant } from '../entities/restaurant.entity';
import { User } from '../entities/user.entity';
import { Table } from '../entities/table.entity';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { Staff } from '../entities/staff.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, Restaurant, Staff, Table])],
  controllers: [UserController],
  providers: [UserService],
})
export class UserModule {}

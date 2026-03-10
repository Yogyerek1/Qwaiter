import {
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Repository } from 'typeorm';
import { Restaurant } from '../entities/restaurant.entity';
import { User } from '../entities/user.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { UpdateRestaurantDto } from './dto/updateRestaurant.dto';
import { Table } from '../entities/table.entity';
import { updateTableDto } from './dto/updateTable.dto';
import { CreateWorkerDto } from './dto/createWorker.dto';
import { Staff } from '../entities/staff.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(Restaurant)
    private restaurantRepository: Repository<Restaurant>,

    @InjectRepository(User)
    private userRepository: Repository<User>,

    @InjectRepository(Table)
    private tableRepository: Repository<Table>,

    @InjectRepository(Staff)
    private staffRepository: Repository<Staff>,
  ) {}

  async createRestaurant(
    ownerID: string,
    restaurantName: string,
    address: string,
  ) {
    const restaurant = this.restaurantRepository.create({
      ownerID,
      restaurantName,
      address,
    });

    await this.restaurantRepository.save(restaurant);
    return {
      message: 'Restaurant was created successfully!',
      restaurant: restaurant,
    };
  }

  async deleteRestaurant(ownerID: string, restaurantID: string) {
    const restaurant = await this.restaurantRepository.findOne({
      where: { restaurantID },
    });

    if (!restaurant) throw new NotFoundException('Restaurant not found!');

    if (ownerID !== restaurant.ownerID)
      throw new ForbiddenException(
        "You can't delete someone else's restaurant!",
      );

    await this.restaurantRepository.delete({
      restaurantID: restaurant.restaurantID,
    });
    return { message: 'Restaurant was successfully deleted!' };
  }

  async getRestaurantsByOwner(ownerID: string) {
    const restaurants = await this.restaurantRepository.find({
      where: { ownerID: ownerID },
    });

    if (!restaurants)
      throw new NotFoundException("You don't have restaurants!");

    return restaurants;
  }

  async updateRestaurant(
    ownerID: string,
    restaurantID: string,
    dto: UpdateRestaurantDto,
  ) {
    const restaurant = await this.restaurantRepository.findOne({
      where: { restaurantID },
    });

    if (!restaurant) throw new NotFoundException('Restaurant not found!');
    if (ownerID !== restaurant.ownerID)
      throw new ForbiddenException(
        "You can't update someone else's restaurant!",
      );

    if (dto.restaurantName) restaurant.restaurantName = dto.restaurantName;
    if (dto.address) restaurant.address = dto.address;

    await this.restaurantRepository.save(restaurant);
    return {
      message: 'Restaurant was successfully updated',
      restaurant,
    };
  }

  async createTable(
    ownerID: string,
    restaurantID: string,
    tableName: string,
    authCode: string,
  ) {
    const restaurant = await this.restaurantRepository.findOne({
      where: { restaurantID },
    });

    if (!restaurant) throw new NotFoundException('Restaurant not found!');
    if (restaurant.ownerID !== ownerID)
      throw new ForbiddenException(
        "You can't create a table for someone else's restaurant!",
      );

    const table = this.tableRepository.create({
      restaurantID: restaurant.restaurantID,
      tableName,
      authCode,
    });

    await this.tableRepository.save(table);

    return {
      message: 'Table was created successfully!',
      table,
    };
  }

  async deleteTable(ownerID: string, restaurantID: string, tableID: string) {
    const restaurant = await this.restaurantRepository.findOne({
      where: { restaurantID },
    });

    if (!restaurant) throw new NotFoundException('Restaurant not found!');

    if (ownerID !== restaurant.ownerID)
      throw new ForbiddenException(
        "You can't delete someone else's restaurant's table!",
      );

    const table = await this.tableRepository.findOne({
      where: { tableID, restaurantID: restaurant.restaurantID },
    });

    if (!table)
      throw new NotFoundException('Table not found in this restaurant!');

    await this.tableRepository.delete({ tableID: table.tableID });

    return { message: 'Table was successfully deleted!' };
  }

  async getTablesByRestaurant(ownerID: string, restaurantID: string) {
    const restaurant = await this.restaurantRepository.findOne({
      where: { restaurantID, ownerID },
      relations: ['tables'],
    });

    if (!restaurant)
      throw new NotFoundException(
        "Restaurant not found or you don't own this restaurant!",
      );

    return restaurant.tables;
  }

  async updateTable(ownerID: string, dto: updateTableDto) {
    const restaurantID = dto.restaurantID;
    const tableID = dto.tableID;

    const restaurant = await this.restaurantRepository.findOne({
      where: { restaurantID },
    });

    if (!restaurant) throw new NotFoundException('Restaurant not found!');

    if (ownerID !== restaurant.ownerID)
      throw new ForbiddenException(
        "You can't update a table of someone else's restaurant!",
      );

    const table = await this.tableRepository.findOne({
      where: { tableID, restaurantID: restaurant.restaurantID },
    });

    if (!table)
      throw new NotFoundException('Table not found in this restaurant!');

    if (dto.tableName !== undefined) table.tableName = dto.tableName;
    if (dto.authCode !== undefined) table.authCode = dto.authCode;

    await this.tableRepository.save(table);

    return {
      message: 'Table was successfully updated!',
      table,
    };
  }
  async createWorker(ownerID: string, dto: CreateWorkerDto) {
    const restaurant = await this.restaurantRepository.findOne({
      where: { restaurantID: dto.restaurantID },
      relations: ['staffMembers'],
    });

    if (!restaurant) throw new NotFoundException('Restaurant not found!');
    if (ownerID !== restaurant.ownerID)
      throw new ForbiddenException(
        "You can't create worker to someone else's restaurant!",
      );

    const existingWorker = restaurant.staffMembers.find(
      (staff) => staff.username == dto.username,
    );

    if (existingWorker)
      throw new ConflictException('Username already taken in this restaurant!');

    const hashedPassword = await bcrypt.hash(dto.password, 10);

    const staff = this.staffRepository.create({
      name: dto.name,
      username: dto.username,
      password: hashedPassword,
      role: dto.role,
      restaurant: restaurant,
    });

    await this.staffRepository.save(staff);
    return {
      message: 'Worker created successfully',
      worker: {
        name: staff.name,
        username: staff.username,
        role: staff.role,
      },
    };
  }
}

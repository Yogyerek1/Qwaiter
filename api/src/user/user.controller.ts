import {
  Controller,
  Post,
  UseGuards,
  Request,
  Body,
  Delete,
  Get,
  Param,
} from '@nestjs/common';
import { UserService } from './user.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateRestaurantDto } from './dto/createRestaurant.dto';
import { DeleteRestaurantDto } from './dto/deleteRestaurant.dto';
import { UpdateRestaurantDto } from './dto/updateRestaurant.dto';

@Controller('user')
export class UserController {
  constructor(private userService: UserService) {}

  @UseGuards(JwtAuthGuard)
  @Post('create/restaurant')
  createRestaurant(@Request() req: any, @Body() body: CreateRestaurantDto) {
    const ownerID = req.user.id;
    return this.userService.createRestaurant(
      ownerID,
      body.restaurantName,
      body.address,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Delete('delete/restaurant')
  deleteRestaurant(@Request() req: any, @Body() body: DeleteRestaurantDto) {
    const ownerID = req.user.id;
    return this.userService.deleteRestaurant(ownerID, body.restaurantID);
  }

  @UseGuards(JwtAuthGuard)
  @Get('restaurant/:id')
  getRestaurant(@Request() req: any, @Param('id') restaurantID: string) {
    return this.userService.getRestaurantByID(req.user.id, restaurantID);
  }

  @UseGuards(JwtAuthGuard)
  @Get('restaurants')
  getRestaurantByOwner(@Request() req: any) {
    return this.userService.getRestaurantsByOwner(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Post('update/restaurant/:id')
  updateRestaurant(
    @Request() req: any,
    @Param('id') restaurantID: string,
    @Body() body: UpdateRestaurantDto,
  ) {
    return this.userService.updateRestaurant(req.user.id, restaurantID, body);
  }
}

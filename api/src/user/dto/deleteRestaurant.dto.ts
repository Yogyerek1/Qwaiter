import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class DeleteRestaurantDto {
  @ApiProperty({ example: '' })
  @IsString()
  restaurantID: string;
}

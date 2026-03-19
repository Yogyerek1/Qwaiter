import { ApiProperty } from '@nestjs/swagger';
import { IsUUID } from 'class-validator';

export class GetMenuItemDto {
  @ApiProperty({ example: '' })
  @IsUUID()
  restaurantID: string;

  @ApiProperty({ example: '' })
  @IsUUID()
  menuItemID: string;
}

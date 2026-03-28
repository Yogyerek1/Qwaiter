import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsArray,
  IsNotEmpty,
  IsUUID,
  Min,
  ValidateNested,
} from 'class-validator';

class OrderItemDto {
  @ApiProperty({ example: '' })
  @IsUUID()
  menuItemID: string;

  @ApiProperty({ example: 1 })
  @Min(1)
  quantity: number;
}

export class CreateOrderDto {
  @ApiProperty({ example: '' })
  @IsUUID()
  @IsNotEmpty()
  tableID: string;

  @ApiProperty({ example: '' })
  @IsNotEmpty()
  authCode: string;

  @ApiProperty({ type: [OrderItemDto] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => OrderItemDto)
  items: OrderItemDto[];
}

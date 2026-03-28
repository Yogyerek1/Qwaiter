/* eslint-disable @typescript-eslint/no-unsafe-call */
import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength } from 'class-validator';

export class createTableDto {
  @ApiProperty({ example: '' })
  @IsString()
  restaurantID: string;

  @ApiProperty({ example: '' })
  @IsString()
  @MinLength(3)
  tableName: string;

  @ApiProperty({ example: '' })
  @IsString()
  @MinLength(2)
  authCode: string;
}

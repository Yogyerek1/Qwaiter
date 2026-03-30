import { ApiProperty } from '@nestjs/swagger';
import { IsUUID } from 'class-validator';

export class deleteWorkerDto {
  @ApiProperty({ example: '' })
  @IsUUID()
  restaurantID: string;

  @ApiProperty({ example: '' })
  @IsUUID()
  workerID: string;
}

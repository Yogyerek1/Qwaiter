import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class WorkerLoginDto {
  @ApiProperty({ example: '' })
  @IsString()
  username: string;

  @ApiProperty({ example: '' })
  @IsString()
  password: string;
}

import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsString } from 'class-validator';
import { StaffRole } from '../../entities/staff.entity';

export class CreateWorkerDto {
  @ApiProperty({ example: '' })
  @IsString()
  restaurantID: string;

  @ApiProperty({ example: '' })
  @IsString()
  name: string;

  @ApiProperty({ example: '' })
  @IsString()
  username: string;

  @ApiProperty({ example: '' })
  @IsString()
  password: string;

  @ApiProperty({ enum: StaffRole, example: StaffRole.WAITER })
  @IsEnum(StaffRole)
  role: StaffRole;
}

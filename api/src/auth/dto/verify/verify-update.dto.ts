import { ApiProperty } from '@nestjs/swagger';
import { Length } from 'class-validator';

export class verifyUpdateDto {
  @ApiProperty({ example: '' })
  @Length(6)
  code: string;
}

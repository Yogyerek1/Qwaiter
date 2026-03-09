/* eslint-disable @typescript-eslint/no-unsafe-call */
import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, Length } from 'class-validator';

export class VerifyCodeDto {
  @ApiProperty({ example: '@gmail.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: '' })
  @IsString()
  @Length(6)
  code: string;
}

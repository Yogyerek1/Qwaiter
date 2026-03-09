/* eslint-disable @typescript-eslint/no-unsafe-call */
import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, Length, MinLength } from 'class-validator';

export class ResetPasswordDto {
  @ApiProperty({ example: '@gmail.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: '' })
  @IsString()
  @Length(6)
  code: string;

  @ApiProperty({ example: '' })
  @IsString()
  @MinLength(6)
  newPassword: string;
}

/* eslint-disable @typescript-eslint/no-unsafe-call */
import { IsEmail, IsString, Length, MinLength } from 'class-validator';

export class ResetPasswordDto {
  @IsEmail()
  email: string;

  @IsString()
  @Length(6)
  code: string;

  @IsString()
  @MinLength(6)
  newPassword: string;
}

/* eslint-disable @typescript-eslint/no-unsafe-call */
import { IsEmail, IsString, Length } from 'class-validator';

export class VerifyCodeDto {
  @IsEmail()
  email: string;

  @IsString()
  @Length(6)
  code: string;
}

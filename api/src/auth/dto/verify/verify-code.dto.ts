/* eslint-disable @typescript-eslint/no-unsafe-call */
import { IsEmail, IsString, Length } from 'class-validator';

export class VerifyCodeDTO {
  @IsEmail()
  email: string;

  @IsString()
  @Length(6)
  code: string;
}

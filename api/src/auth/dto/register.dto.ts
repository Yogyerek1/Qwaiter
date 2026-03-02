import { IsEmail, IsString, MinLength } from 'class-validator';

export class RegisterDto {
  @IsEmail({}, { message: 'Invalid email!' })
  email: string;

  @IsString()
  @MinLength(6, { message: 'Username must be more than 6 characters!' })
  username: string;

  @IsString()
  @MinLength(8, { message: 'The password needs to be 8 character!' })
  password: string;
}

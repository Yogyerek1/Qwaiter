import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Restaurant } from './restaurant.entity';

@Entity()
export class Table {
  @PrimaryGeneratedColumn('uuid')
  tableID: string;

  @Column({ nullable: true })
  restaurantID: string;

  @Column()
  tableName: string;

  @Column({ unique: true })
  qrCodeToken: string;

  @Column({ length: 5 })
  authCode: string;

  @ManyToOne(() => Restaurant, (restaurant) => restaurant.tables, {
    nullable: true,
  })
  @JoinColumn({ name: 'restaurantID' })
  restaurant: Restaurant;
}

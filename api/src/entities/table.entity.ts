import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  JoinColumn,
} from 'typeorm';
import { Restaurant } from './restaurant.entity';
import { Order } from './order.entity';

@Entity()
export class Table {
  @PrimaryGeneratedColumn('uuid')
  tableID: string;

  @Column({ nullable: true })
  restaurantID: string;

  @Column()
  tableName: string;

  @Column({ unique: true })
  @PrimaryGeneratedColumn('uuid')
  QRCodeToken: string;

  @Column()
  authCode: string;

  @ManyToOne(() => Restaurant, (restaurant) => restaurant.tables, {
    nullable: true,
  })
  @JoinColumn({ name: 'restaurantID' })
  restaurant: Restaurant;

  @OneToMany(() => Order, (order) => order.table)
  orders: Order[];
}

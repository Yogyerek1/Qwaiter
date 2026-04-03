import {
  Entity,
  PrimaryGeneratedColumn,
  ManyToOne,
  OneToMany,
  Column,
  CreateDateColumn,
  JoinColumn,
} from 'typeorm';
import { Table } from './table.entity';
import { Restaurant } from './restaurant.entity';
import { OrderItem } from './order-item.entity';

export enum OrderStatus {
  PENDING = 'pending',
  PREPARING = 'preparing',
  SERVED = 'served',
  PAID = 'paid',
}

@Entity()
export class Order {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ nullable: true })
  tableID: string;

  @Column({ nullable: true })
  restaurantID: string;

  @Column({
    type: 'enum',
    enum: OrderStatus,
    default: OrderStatus.PENDING,
  })
  status: OrderStatus;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  totalAmount: number;

  @CreateDateColumn()
  createdAt: Date;

  @ManyToOne(() => Table, (table) => table.orders, {
    nullable: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'tableID' })
  table: Table;

  @ManyToOne(() => Restaurant, (restaurant) => restaurant.orders, {
    nullable: true,
  })
  @JoinColumn({ name: 'restaurantID' })
  restaurant: Restaurant;

  @OneToMany(() => OrderItem, (item) => item.order, { cascade: true })
  items: OrderItem[];
}

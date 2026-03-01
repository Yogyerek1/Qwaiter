import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';
import { Table } from './table.entity';
import { Order } from './order.entity';
import { MenuItem } from './menuitem.entity';
import { Category } from './category.entity';

@Entity()
export class Restaurant {
  @PrimaryGeneratedColumn('uuid')
  restaurantID: string;

  @Column({ nullable: true })
  ownerID: string;

  @Column({ length: 100 })
  restaurantName: string;

  @Column({ length: 150 })
  address: string;

  @ManyToOne(() => User, (user) => user.restaurants, { nullable: true })
  @JoinColumn({ name: 'ownerID' })
  owner: User;

  @OneToMany(() => Table, (table) => table.restaurant)
  tables: Table[];

  @OneToMany(() => Order, (order) => order.restaurant)
  orders: Order[];

  @OneToMany(() => MenuItem, (menuItem) => menuItem.restaurant)
  menuItems: MenuItem[];

  @OneToMany(() => Category, (category) => category.restaurant)
  categories: Category[];
}

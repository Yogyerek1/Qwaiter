import {
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  Column,
  JoinColumn,
} from 'typeorm';
import { Restaurant } from './restaurant.entity';
import { MenuItem } from './menuitem.entity';

@Entity()
export class Category {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ nullable: true })
  restaurantID: string;

  @Column()
  name: string;

  @Column({ default: 0 })
  displayOrder: number;

  @ManyToOne(() => Restaurant, (restaurant) => restaurant.categories, {
    nullable: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'restaurantID' })
  restaurant: Restaurant;

  @OneToMany(() => MenuItem, (item) => item.category)
  items: MenuItem[];
}

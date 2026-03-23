import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  Table,
} from 'typeorm';

@Entity()
export class Guest {
  @PrimaryGeneratedColumn('uuid')
  guestID: string;

  @Column({ nullable: true })
  tableID: string;

  @ManyToOne(() => Table, { nullable: true, onDelete: 'CASCADE' })
  @JoinColumn({ name: 'tableID' })
  table: Table;

  @CreateDateColumn()
  createdAt: Date;

  @Column({ type: 'timestamp', nullable: true })
  lastActiveAt: Date;
}

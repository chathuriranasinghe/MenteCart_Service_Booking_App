import mongoose from 'mongoose';

import { envConfig } from '../config/env.config';
import { CartModel } from '../modules/cart/cart.model';
import { ServiceModel } from '../modules/services/service.model';

// Generate a date string N days from today: YYYY-MM-DD
function futureDate(daysFromNow: number): string {
  const d = new Date();
  d.setDate(d.getDate() + daysFromNow);
  return d.toISOString().slice(0, 10);
}

// Times must exactly match the strings Flutter sends from _allTimes
const services = [
  {
    title: 'Home Cleaning',
    description:
      'Professional deep home cleaning including dusting, mopping, kitchen and bathroom cleaning.',
    price: 699,
    duration: 60,
    category: 'Cleaning',
    image:
      'https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=600',
    capacityPerSlot: 5,
    availableSlots: [
      { date: futureDate(1), time: '09:00 AM', remainingCapacity: 5 },
      { date: futureDate(1), time: '11:00 AM', remainingCapacity: 5 },
      { date: futureDate(1), time: '02:00 PM', remainingCapacity: 5 },
      { date: futureDate(2), time: '09:00 AM', remainingCapacity: 5 },
      { date: futureDate(2), time: '11:00 AM', remainingCapacity: 5 },
      { date: futureDate(3), time: '10:00 AM', remainingCapacity: 5 },
      { date: futureDate(3), time: '03:00 PM', remainingCapacity: 5 },
      { date: futureDate(5), time: '09:00 AM', remainingCapacity: 5 },
      { date: futureDate(5), time: '01:00 PM', remainingCapacity: 5 },
      { date: futureDate(7), time: '11:00 AM', remainingCapacity: 5 },
    ],
  },
  {
    title: 'Plumbing Repair',
    description:
      'Repair leaks, blocked pipes, bathroom fittings and kitchen plumbing issues.',
    price: 499,
    duration: 45,
    category: 'Plumbing',
    image:
      'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?q=80&w=600',
    capacityPerSlot: 3,
    availableSlots: [
      { date: futureDate(1), time: '10:00 AM', remainingCapacity: 3 },
      { date: futureDate(1), time: '03:00 PM', remainingCapacity: 3 },
      { date: futureDate(2), time: '10:00 AM', remainingCapacity: 3 },
      { date: futureDate(4), time: '09:00 AM', remainingCapacity: 3 },
      { date: futureDate(4), time: '02:00 PM', remainingCapacity: 3 },
      { date: futureDate(6), time: '11:00 AM', remainingCapacity: 3 },
    ],
  },
  {
    title: 'Tutoring',
    description:
      'One-to-one tutoring sessions for school students with experienced tutors.',
    price: 399,
    duration: 60,
    category: 'Tutoring',
    image:
      'https://images.unsplash.com/photo-1588072432836-e10032774350?q=80&w=600',
    capacityPerSlot: 4,
    availableSlots: [
      { date: futureDate(1), time: '04:00 PM', remainingCapacity: 4 },
      { date: futureDate(1), time: '05:00 PM', remainingCapacity: 4 },
      { date: futureDate(2), time: '04:00 PM', remainingCapacity: 4 },
      { date: futureDate(3), time: '06:00 PM', remainingCapacity: 4 },
      { date: futureDate(5), time: '05:00 PM', remainingCapacity: 4 },
      { date: futureDate(7), time: '04:00 PM', remainingCapacity: 4 },
    ],
  },
  {
    title: 'Beauty Appointment',
    description:
      'At-home beauty appointment including basic salon and grooming services.',
    price: 799,
    duration: 90,
    category: 'Beauty',
    image:
      'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=600',
    capacityPerSlot: 2,
    availableSlots: [
      { date: futureDate(1), time: '10:00 AM', remainingCapacity: 2 },
      { date: futureDate(2), time: '02:00 PM', remainingCapacity: 2 },
      { date: futureDate(3), time: '10:00 AM', remainingCapacity: 2 },
      { date: futureDate(4), time: '01:00 PM', remainingCapacity: 2 },
      { date: futureDate(6), time: '11:00 AM', remainingCapacity: 2 },
    ],
  },
];

const seedServices = async (): Promise<void> => {
  try {
    await mongoose.connect(envConfig.mongoUri);

    await ServiceModel.deleteMany({});
    await ServiceModel.insertMany(services);
    await CartModel.deleteMany({});

    console.log('Services seeded and carts cleared successfully');

    await mongoose.disconnect();
    process.exit(0);
  } catch (error) {
    console.error('Service seed failed:', error);
    await mongoose.disconnect();
    process.exit(1);
  }
};

seedServices();
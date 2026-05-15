import mongoose from 'mongoose';

import { envConfig } from '../config/env.config';
import { ServiceModel } from '../modules/services/service.model';

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
      {
        date: '2025-05-20',
        time: '09:00',
        remainingCapacity: 5,
      },
      {
        date: '2025-05-20',
        time: '11:00',
        remainingCapacity: 4,
      },
      {
        date: '2025-05-21',
        time: '14:00',
        remainingCapacity: 3,
      },
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
      {
        date: '2025-05-20',
        time: '10:00',
        remainingCapacity: 3,
      },
      {
        date: '2025-05-21',
        time: '15:00',
        remainingCapacity: 2,
      },
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
      {
        date: '2025-05-22',
        time: '16:00',
        remainingCapacity: 4,
      },
      {
        date: '2025-05-23',
        time: '18:00',
        remainingCapacity: 3,
      },
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
      {
        date: '2025-05-23',
        time: '10:00',
        remainingCapacity: 2,
      },
      {
        date: '2025-05-23',
        time: '14:00',
        remainingCapacity: 1,
      },
    ],
  },
];

const seedServices = async (): Promise<void> => {
  try {
    await mongoose.connect(envConfig.mongoUri);

    await ServiceModel.deleteMany({});
    await ServiceModel.insertMany(services);

    console.log('Services seeded successfully');

    await mongoose.disconnect();
    process.exit(0);
  } catch (error) {
    console.error('Service seed failed:', error);
    await mongoose.disconnect();
    process.exit(1);
  }
};

seedServices();
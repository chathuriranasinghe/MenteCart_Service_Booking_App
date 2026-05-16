import { AppError } from '../../core/errors/app-error';
import {
  PaginatedServicesResponseDto,
  ServiceQueryDto,
  ServiceResponseDto,
} from './service.dto';
import { ServiceDocument } from './service.model';
import { ServiceRepository } from './service.repository';

export class ServiceService {
  constructor(private readonly serviceRepository: ServiceRepository) {}

  async getServices(
    query: ServiceQueryDto,
  ): Promise<PaginatedServicesResponseDto> {
    const { services, total } = await this.serviceRepository.findAll(query);

    const hasMore = query.page * query.limit < total;

    return {
      services: services.map((service) => this.mapServiceResponse(service)),
      pagination: {
        page: query.page,
        limit: query.limit,
        total,
        hasMore,
      },
    };
  }

  async getServiceById(serviceId: string): Promise<ServiceResponseDto> {
    const service = await this.serviceRepository.findById(serviceId);

    if (!service) {
      throw new AppError('Service not found', 404, 'SERVICE_NOT_FOUND');
    }

    return this.mapServiceResponse(service, true);
  }

  private mapServiceResponse(
    service: ServiceDocument,
    includeSlots = false,
  ): ServiceResponseDto {
    return {
      id: service._id.toString(),
      title: service.title,
      description: service.description,
      price: service.price,
      duration: service.duration,
      category: service.category,
      image: service.image,
      capacityPerSlot: service.capacityPerSlot,
      isActive: service.isActive,
      availableSlots: includeSlots ? service.availableSlots : undefined,
      createdAt: service.createdAt,
      updatedAt: service.updatedAt,
    };
  }
}
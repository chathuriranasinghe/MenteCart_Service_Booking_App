# MenteCart — Service Booking App

A full-stack service booking application where users browse a catalogue of services, add them to a cart with date/time slots, and complete bookings with payment method selection.

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter (Dart 3.x), BLoC pattern |
| Backend | Node.js, Express, TypeScript |
| Database | MongoDB (Mongoose) |
| Auth | JWT (access tokens, bcrypt password hashing) |
| Logging | pino + pino-http with request IDs |
| Containers | Docker + Docker Compose |

## Project Structure

```
MenteCart/
├── mentecart-backend/   # Node.js + Express + TypeScript API
├── mentecart_mobile_app/ # Flutter mobile client
└── docker-compose.yml   # Backend + MongoDB containers
```

## Prerequisites

- Node.js >= 18
- MongoDB running locally on port 27017 (or provide a remote URI)
- Flutter SDK >= 3.x / Dart >= 3.x
- Docker >= 24 + Docker Compose v2 (for containerised setup)

## Docker Setup (recommended)

Runs the backend + MongoDB together. No local Node.js or MongoDB installation needed.

```bash
# 1. Copy and fill in your secrets
cp mentecart-backend/.env.example mentecart-backend/.env
# Edit mentecart-backend/.env — set JWT_SECRET, PAYHERE_MERCHANT_ID, PAYHERE_MERCHANT_SECRET
# MONGO_URI is overridden automatically by docker-compose to use the mongo container

# 2. Build and start
docker compose up --build -d

# 3. Seed services (first run only)
docker compose exec backend node -e "
  require('./dist/database/seed-services.js')
"

# 4. View logs
docker compose logs -f backend

# 5. Stop
docker compose down
```

The API will be available at `http://localhost:5000`.

> MongoDB data is persisted in the `mongo_data` Docker volume. Run `docker compose down -v` to also remove the volume.

## Backend Setup

```bash
cd mentecart-backend
cp .env.example .env
# Edit .env and set your JWT_SECRET and MONGO_URI
npm install
npm run dev
```

The API will be available at `http://localhost:5000`.

### Environment Variables

| Variable | Description | Example |
|---|---|---|
| `PORT` | Server port | `5000` |
| `MONGO_URI` | MongoDB connection string | `mongodb://127.0.0.1:27017/mentecart` |
| `JWT_SECRET` | Secret key for signing JWTs | `your_secret_here` |
| `JWT_EXPIRES_IN` | JWT expiry duration | `7d` |
| `NODE_ENV` | Environment | `development` |

> **Never commit real secrets.** Copy `.env.example` to `.env` and fill in your values. Share secrets via [one-time-secret.de](https://one-time-secret.de/en).

### Seed Services

```bash
npm run seed
```

## Flutter Setup

```bash
cd mentecart_mobile_app
flutter pub get
```

### Running on Android Emulator (default)

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000/api/v1
```

### Running on Physical Device (USB)

```bash
adb reverse tcp:5000 tcp:5000
flutter run --dart-define=API_BASE_URL=http://localhost:5000/api/v1
```

### Running on Physical Device (Wi-Fi)

```bash
flutter run --dart-define=API_BASE_URL=http://<YOUR_PC_LAN_IP>:5000/api/v1
```

## API Endpoints

| Method | Path | Auth | Description |
|---|---|---|---|
| POST | `/api/v1/auth/signup` | No | Register, returns JWT |
| POST | `/api/v1/auth/login` | No | Login, returns JWT |
| GET | `/api/v1/auth/me` | Yes | Current user |
| GET | `/api/v1/services` | No | List services (paginated, filterable) |
| GET | `/api/v1/services/:id` | No | Service detail + slots |
| GET | `/api/v1/cart` | Yes | Current user's cart |
| POST | `/api/v1/cart/items` | Yes | Add item to cart |
| PATCH | `/api/v1/cart/items/:itemId` | Yes | Update item slot/qty |
| DELETE | `/api/v1/cart/items/:itemId` | Yes | Remove item |
| POST | `/api/v1/bookings/checkout` | Yes | Convert cart → booking |
| GET | `/api/v1/bookings` | Yes | List user's bookings |
| GET | `/api/v1/bookings/:id` | Yes | Booking detail |
| POST | `/api/v1/bookings/:id/cancel` | Yes | Cancel booking |

## Business Rules Implemented

- Cart expires after 15 minutes (TTL index + checkout validation)
- Max 3 bookings per user per day
- Atomic slot capacity decrement via `findOneAndUpdate` with `$gte` filter — prevents overbooking under concurrent load
- Capacity released back to slot pool on cancellation
- Status transitions guarded (cannot go from `cancelled` back to `pending`)
- Full status audit log (`statusHistory`) on every booking
- `cash` / `pay_on_arrival` bookings go straight to `confirmed`; `card` bookings start as `pending`

## Known Limitations

- PayHere sandbox payment integration implemented
- Docker setup included
- Refresh token rotation is not implemented; access tokens expire per `JWT_EXPIRES_IN`
- The "Forgot Password" screen is a UI stub — no email reset flow is wired
- Social login (Google / Apple) buttons are UI stubs
- Profile edit and address management are UI stubs

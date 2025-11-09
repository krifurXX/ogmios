# UFC Tier 3 Example: Complete Project Documentation

**Language:** [🇸🇪 Svenska](../sv/exempel-ufc-tier3.md) | 🇬🇧 English

---

## About This Example

This is a **Tier 3 UFC context file** - complete deep-dive documentation.

**Size:** Unlimited (50KB+)
**Purpose:** All information about the project
**When:** Loaded only on explicit request or complex implementation

---

## Complete API Documentation

### Products API - Detailed Specification

#### GET /api/products
**Description:** Fetch all products with filtering and pagination

**Query Parameters:**
```typescript
interface ProductQueryParams {
  category?: string;           // Filter by category
  farmer_id?: string;          // Filter by farmer
  min_price?: number;          // Minimum price filter
  max_price?: number;          // Maximum price filter
  in_stock?: boolean;          // Only in-stock items
  page?: number;               // Page number (default: 1)
  limit?: number;              // Items per page (default: 20, max: 100)
  sort?: 'price_asc' | 'price_desc' | 'name' | 'created_at';
  search?: string;             // Search in name and description
}
```

**Response:**
```typescript
interface ProductListResponse {
  products: Product[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
    hasNext: boolean;
    hasPrev: boolean;
  };
  filters: AppliedFilters;
}

interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  currency: 'SEK';
  farmer: {
    id: string;
    name: string;
    farm_name: string;
    location: string;
  };
  category: string;
  stock: number;
  unit: 'kg' | 'pcs' | 'liter';
  images: {
    url: string;
    alt: string;
    thumbnail: string;
  }[];
  created_at: string;
  updated_at: string;
}
```

**Example Request:**
```bash
GET /api/products?category=vegetables&in_stock=true&sort=price_asc&limit=10
```

**Example Response:**
```json
{
  "products": [
    {
      "id": "prod_abc123",
      "name": "Organic Tomatoes",
      "description": "Fresh organic tomatoes from local greenhouse",
      "price": 45.00,
      "currency": "SEK",
      "farmer": {
        "id": "farmer_xyz",
        "name": "Anders Andersson",
        "farm_name": "Green Valley Farm",
        "location": "<CITY>"
      },
      "category": "vegetables",
      "stock": 50,
      "unit": "kg",
      "images": [
        {
          "url": "https://cdn.example.com/tomatoes.jpg",
          "alt": "Red organic tomatoes",
          "thumbnail": "https://cdn.example.com/tomatoes-thumb.jpg"
        }
      ],
      "created_at": "2025-11-01T10:00:00Z",
      "updated_at": "2025-11-09T14:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 45,
    "totalPages": 5,
    "hasNext": true,
    "hasPrev": false
  }
}
```

**Error Responses:**
```typescript
// 400 Bad Request - Invalid parameters
{
  "error": "VALIDATION_ERROR",
  "message": "Invalid query parameters",
  "details": {
    "min_price": "Must be a positive number",
    "limit": "Must be between 1 and 100"
  }
}

// 500 Internal Server Error
{
  "error": "INTERNAL_ERROR",
  "message": "An unexpected error occurred",
  "requestId": "req_12345"
}
```

---

## Database Schema - Complete

### Products Table
```sql
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
  currency VARCHAR(3) DEFAULT 'SEK',
  farmer_id UUID NOT NULL REFERENCES farmers(id) ON DELETE CASCADE,
  category VARCHAR(50) NOT NULL,
  stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
  unit VARCHAR(20) NOT NULL CHECK (unit IN ('kg', 'pcs', 'liter')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  deleted_at TIMESTAMP WITH TIME ZONE,

  -- Indexes for performance
  CONSTRAINT products_name_farmer_unique UNIQUE (name, farmer_id)
);

CREATE INDEX idx_products_farmer ON products(farmer_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_created_at ON products(created_at DESC);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_name_search ON products USING gin(to_tsvector('english', name || ' ' || description));
```

### Orders Table
```sql
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  total DECIMAL(10, 2) NOT NULL CHECK (total > 0),
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled')),
  payment_status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
  stripe_payment_intent_id VARCHAR(255),
  shipping_address JSONB NOT NULL,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);
```

---

## Environment Variables - Complete List

### Development (.env.development)
```bash
# Database
DATABASE_URL=postgresql://localhost:5432/ecommerce_dev
REDIS_URL=redis://localhost:6379

# Authentication
JWT_SECRET=<GENERATE_SECURE_SECRET_HERE>
JWT_EXPIRY=15m
REFRESH_TOKEN_EXPIRY=7d

# Stripe
STRIPE_SECRET_KEY=sk_test_<YOUR_TEST_KEY>
STRIPE_PUBLISHABLE_KEY=pk_test_<YOUR_TEST_KEY>
STRIPE_WEBHOOK_SECRET=whsec_<YOUR_WEBHOOK_SECRET>

# Email (SendGrid)
SENDGRID_API_KEY=<YOUR_SENDGRID_KEY>
FROM_EMAIL=noreply@example.com

# Frontend URL
FRONTEND_URL=http://localhost:3000

# Server
PORT=3001
NODE_ENV=development

# File Upload
MAX_FILE_SIZE=5242880  # 5MB in bytes
ALLOWED_FILE_TYPES=image/jpeg,image/png,image/webp

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000  # 15 minutes
RATE_LIMIT_MAX_REQUESTS=100
```

### Production (.env.production)
```bash
# Database (Supabase)
DATABASE_URL=postgresql://user:pass@db.project.supabase.co:5432/postgres
REDIS_URL=<REDIS_CLOUD_URL>

# Same JWT secrets as dev (but different values!)
JWT_SECRET=<PRODUCTION_SECRET>
JWT_EXPIRY=15m
REFRESH_TOKEN_EXPIRY=7d

# Stripe Production Keys
STRIPE_SECRET_KEY=sk_live_<YOUR_LIVE_KEY>
STRIPE_PUBLISHABLE_KEY=pk_live_<YOUR_LIVE_KEY>
STRIPE_WEBHOOK_SECRET=whsec_<YOUR_LIVE_WEBHOOK>

# Production URLs
FRONTEND_URL=https://example.com
API_URL=https://api.example.com

# Server
PORT=3000
NODE_ENV=production

# Logging
LOG_LEVEL=info
SENTRY_DSN=<YOUR_SENTRY_DSN>
```

---

## Testing Strategy - Complete

### Unit Tests (Jest + Supertest)

**Product Service Tests:**
```typescript
// tests/services/productService.test.ts
import { ProductService } from '../../src/services/productService';
import { db } from '../../src/db/postgres';

describe('ProductService', () => {
  let productService: ProductService;

  beforeAll(async () => {
    await db.connect();
    productService = new ProductService(db);
  });

  afterAll(async () => {
    await db.disconnect();
  });

  describe('getProducts', () => {
    it('should return paginated products', async () => {
      const result = await productService.getProducts({
        page: 1,
        limit: 10
      });

      expect(result.products).toBeInstanceOf(Array);
      expect(result.pagination.page).toBe(1);
      expect(result.pagination.limit).toBe(10);
    });

    it('should filter by category', async () => {
      const result = await productService.getProducts({
        category: 'vegetables'
      });

      result.products.forEach(product => {
        expect(product.category).toBe('vegetables');
      });
    });

    it('should filter by price range', async () => {
      const result = await productService.getProducts({
        min_price: 20,
        max_price: 100
      });

      result.products.forEach(product => {
        expect(product.price).toBeGreaterThanOrEqual(20);
        expect(product.price).toBeLessThanOrEqual(100);
      });
    });
  });
});
```

### Integration Tests

**Order API Tests:**
```typescript
// tests/integration/orders.test.ts
import request from 'supertest';
import { app } from '../../src/app';
import { createTestUser, getAuthToken } from '../helpers';

describe('POST /api/orders', () => {
  let authToken: string;

  beforeAll(async () => {
    const user = await createTestUser();
    authToken = await getAuthToken(user);
  });

  it('should create order with valid data', async () => {
    const response = await request(app)
      .post('/api/orders')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        items: [
          { product_id: 'prod_123', quantity: 2 },
          { product_id: 'prod_456', quantity: 1 }
        ],
        shipping_address: {
          street: 'Test Street 1',
          city: 'Stockholm',
          postal_code: '12345',
          country: 'SE'
        }
      });

    expect(response.status).toBe(201);
    expect(response.body.order).toHaveProperty('id');
    expect(response.body.order.status).toBe('pending');
  });

  it('should reject order without authentication', async () => {
    const response = await request(app)
      .post('/api/orders')
      .send({ items: [] });

    expect(response.status).toBe(401);
  });
});
```

---

## Deployment Checklist

### Pre-Deployment
- [ ] Run all tests (`npm test`)
- [ ] Check test coverage (>80%)
- [ ] Run linter (`npm run lint`)
- [ ] Build production bundle (`npm run build`)
- [ ] Test production build locally
- [ ] Update CHANGELOG.md
- [ ] Tag release in git

### Database Migration
- [ ] Create migration script
- [ ] Test migration on staging
- [ ] Backup production database
- [ ] Run migration
- [ ] Verify data integrity

### Production Deploy
- [ ] Set all environment variables
- [ ] Deploy backend to Railway/Render
- [ ] Deploy frontend to Vercel
- [ ] Verify health check endpoints
- [ ] Test critical user flows
- [ ] Monitor error logs (first 24h)
- [ ] Monitor performance metrics

### Post-Deployment
- [ ] Verify Stripe webhooks working
- [ ] Test email sending
- [ ] Check database connections
- [ ] Verify Redis caching
- [ ] Update documentation
- [ ] Notify stakeholders

---

**UFC Layer:** Tier 3 (Deep Dive)
**Size:** ~50KB+
**Loaded when:** Explicit request, complex debugging, implementation of new features
**Related files:**
- Tier 1: `example-ufc-tier1.md`
- Tier 2: `example-ufc-tier2.md`

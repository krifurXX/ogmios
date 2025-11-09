# UFC Tier 2 Example: Project Architecture

**Language:** [🇸🇪 Svenska](../sv/exempel-ufc-tier2.md) | 🇬🇧 English

---

## About This Example

This is a **Tier 2 UFC context file** - architecture and design.

**Size:** 10-50KB
**Purpose:** Provide detailed architecture and design decisions
**When:** Loaded when deeper understanding is needed

---

## System Architecture

### Frontend (React)
```
src/
├── components/
│   ├── ProductCard.tsx
│   ├── Cart.tsx
│   └── Checkout.tsx
├── pages/
│   ├── Home.tsx
│   ├── ProductList.tsx
│   └── Admin.tsx
├── hooks/
│   └── useCart.ts
└── utils/
    └── api.ts
```

### Backend (Node.js + Express)
```
server/
├── routes/
│   ├── products.js
│   ├── orders.js
│   └── auth.js
├── models/
│   ├── Product.js
│   ├── Order.js
│   └── User.js
├── middleware/
│   └── auth.js
└── db/
    └── postgres.js
```

### Database (PostgreSQL)
```sql
-- Main tables
products (id, name, price, farmer_id, stock)
orders (id, user_id, total, status, created_at)
order_items (id, order_id, product_id, quantity, price)
users (id, email, name, role, created_at)
farmers (id, user_id, farm_name, location)
```

---

## API Design

### REST Endpoints

**Products:**
- `GET /api/products` - List all products
- `GET /api/products/:id` - Get single product
- `POST /api/products` - Create new product (admin)
- `PUT /api/products/:id` - Update product (admin)

**Orders:**
- `POST /api/orders` - Create order
- `GET /api/orders/:id` - Get order
- `GET /api/users/me/orders` - User's orders

**Authentication:**
- `POST /api/auth/register` - Register
- `POST /api/auth/login` - Login
- `POST /api/auth/logout` - Logout

---

## Technical Decisions

### State Management
**Decision:** React Context + useReducer
**Why:** Simpler than Redux for this project size
**Alternatives:** Considered Zustand, but wanted to avoid extra dependencies

### Payments
**Decision:** Stripe integration
**Why:** Great documentation, secure, Swedish support
**Implementation:** Stripe Checkout Session for security

### Data Validation
**Decision:** Zod for schema validation
**Why:** Type-safe, great TypeScript integration
**Usage:** Both frontend and backend

---

## Security

### Authentication
- JWT tokens with HttpOnly cookies
- Refresh token rotation
- bcrypt for password hashing (12 rounds)

### Authorization
- Role-based access control (RBAC)
- Middleware for protected routes
- Admin panel only for admin users

### Input Validation
- Zod schemas for all input
- SQL injection prevention via parameterized queries
- XSS prevention via React's built-in escaping

---

## Deployment

### Development
```bash
# Frontend
cd client && npm run dev

# Backend
cd server && npm run dev

# Database
docker-compose up postgres
```

### Production
- **Frontend:** Vercel
- **Backend:** Railway / Render
- **Database:** Supabase (managed PostgreSQL)
- **CDN:** Cloudflare for static assets

---

## Performance Optimization

### Frontend
- Code splitting with React.lazy()
- Image optimization with Next.js Image
- Lazy loading for product lists
- React Query for API caching

### Backend
- Redis for session caching
- Database indexing on frequently used fields
- Connection pooling for PostgreSQL

---

## Next Level

**For complete documentation:**
- `context/projects/my-web-project-tier3.md` (All endpoints, schemas, deployment)

**Related files:**
- `context/technical/api-documentation.md`
- `context/technical/database-schema.md`
- `context/decisions/architecture-decisions.md`

---

**UFC Layer:** Tier 2 (Architecture)
**Size:** ~15KB
**Loaded when:** Architecture questions, design discussions, implementation planning

# UFC Tier 2 Exempel: Projektarkitektur

**Språk:** 🇸🇪 Svenska | [🇬🇧 English](../en/example-ufc-tier2.md)

---

## Om Detta Exempel

Detta är en **Tier 2 UFC context-fil** - arkitektur och design.

**Storlek:** 10-50KB
**Syfte:** Ge detaljerad arkitektur och designbeslut
**När:** Laddas när djupare förståelse behövs

---

## Systemarkitektur

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

### Databas (PostgreSQL)
```sql
-- Huvudtabeller
products (id, name, price, farmer_id, stock)
orders (id, user_id, total, status, created_at)
order_items (id, order_id, product_id, quantity, price)
users (id, email, name, role, created_at)
farmers (id, user_id, farm_name, location)
```

---

## API Design

### REST Endpoints

**Produkter:**
- `GET /api/products` - Lista alla produkter
- `GET /api/products/:id` - Hämta enskild produkt
- `POST /api/products` - Skapa ny produkt (admin)
- `PUT /api/products/:id` - Uppdatera produkt (admin)

**Beställningar:**
- `POST /api/orders` - Skapa beställning
- `GET /api/orders/:id` - Hämta beställning
- `GET /api/users/me/orders` - Användarens beställningar

**Autentisering:**
- `POST /api/auth/register` - Registrera
- `POST /api/auth/login` - Logga in
- `POST /api/auth/logout` - Logga ut

---

## Tekniska Beslut

### State Management
**Beslut:** React Context + useReducer
**Varför:** Enklare än Redux för detta projekts storlek
**Alternativ:** Övervägde Zustand, men ville undvika extra dependencies

### Betalningar
**Beslut:** Stripe integration
**Varför:** Bra dokumentation, säker, svensk support
**Implementation:** Stripe Checkout Session för säkerhet

### Datavalidering
**Beslut:** Zod för schema validation
**Varför:** Type-safe, bra TypeScript integration
**Användning:** Både frontend och backend

---

## Säkerhet

### Autentisering
- JWT tokens med HttpOnly cookies
- Refresh token rotation
- bcrypt för lösenordshashing (12 rounds)

### Authorization
- Role-based access control (RBAC)
- Middleware för skyddade routes
- Admin-panel endast för admin-användare

### Input Validation
- Zod schemas för all input
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
- **CDN:** Cloudflare för statiska assets

---

## Prestandaoptimering

### Frontend
- Code splitting med React.lazy()
- Image optimization med Next.js Image
- Lazy loading för produktlistor
- React Query för API caching

### Backend
- Redis för session caching
- Database indexering på ofta använda fält
- Connection pooling för PostgreSQL

---

## Nästa Nivå

**För komplett dokumentation:**
- `context/projects/mitt-webbprojekt-tier3.md` (Alla endpoints, schemas, deployment)

**Relaterade filer:**
- `context/technical/api-documentation.md`
- `context/technical/database-schema.md`
- `context/decisions/architecture-decisions.md`

---

**UFC Layer:** Tier 2 (Architecture)
**Storlek:** ~15KB
**Laddas när:** Arkitekturfrågor, design discussions, implementation planning

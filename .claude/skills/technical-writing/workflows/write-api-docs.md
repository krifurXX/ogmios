# Write API Documentation Workflow

## Overview
Create comprehensive API documentation for RESTful services and SDKs.

## When to Use
- API development or updates
- SDK documentation
- Integration guides
- Developer portals

## Workflow Steps

### 1. API Inventory
Document all endpoints:
- HTTP methods (GET, POST, PUT, DELETE)
- URL patterns
- Authentication requirements
- Request/response formats

### 2. Structure Documentation

**Overview Section:**
- API purpose and capabilities
- Base URL
- Authentication methods
- Rate limiting

**Endpoint Documentation:**
For each endpoint:
```markdown
### GET /api/users/{id}

**Description:** Retrieve user by ID

**Parameters:**
- `id` (path, required): User ID

**Headers:**
- `Authorization`: Bearer token

**Response:**
Status: 200 OK
```json
{
  "id": "123",
  "name": "John Doe",
  "email": "john@example.com"
}
```

**Errors:**
- 401: Unauthorized
- 404: User not found
```

### 3. Write For Each Endpoint

**Description:**
- What the endpoint does
- When to use it
- Any important notes

**Parameters:**
- Path parameters
- Query parameters
- Request body schema
- Data types and validation

**Authentication:**
- Required auth method
- Scope/permissions needed

**Request Example:**
```bash
curl -X GET \
  https://api.example.com/users/123 \
  -H 'Authorization: Bearer TOKEN'
```

**Response:**
- Success response with example
- Status codes
- Response schema

**Errors:**
- Possible error codes
- Error response format
- How to handle errors

### 4. Add Code Examples
Provide examples in multiple languages:
- cURL (standard)
- JavaScript/TypeScript
- Python
- Language SDK if available

### 5. Create Quick Reference
Summary table of all endpoints:
```markdown
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /users | List users |
| POST | /users | Create user |
| GET | /users/{id} | Get user |
```

### 6. Testing Guide
- How to get API keys
- Testing in sandbox environment
- Postman collection link
- Rate limit information

## Quality Standards
- All endpoints documented
- Working code examples
- Error cases covered
- Authentication explained
- Up-to-date with current API

## Voice Announcement
```
🎯 COMPLETED: [SKILL:technical-writing] API documentation complete
🗣️ CUSTOM COMPLETED: API docs ready
```

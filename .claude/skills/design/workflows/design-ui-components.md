# Design UI Components Workflow

## Overview
Create consistent, reusable UI components for design systems.

## Workflow Steps

### 1. Component Inventory
Identify needed components:
- Atoms: Buttons, inputs, icons
- Molecules: Form fields, search bars
- Organisms: Navigation, cards, modals

### 2. Design Variants
For each component, design:
- Default state
- Hover state
- Active/pressed state
- Disabled state
- Error state
- Loading state

### 3. Apply Design Tokens
- Colors (primary, secondary, neutral)
- Typography (font families, sizes, weights)
- Spacing (4px, 8px, 16px, 24px, 32px)
- Border radius (0, 4px, 8px, 16px)
- Shadows (elevation levels)

### 4. Accessibility Considerations
- Color contrast (WCAG AA: 4.5:1 for text)
- Touch target size (min 44x44px)
- Keyboard navigation
- Screen reader support
- Focus indicators

### 5. Documentation
For each component document:
- Usage guidelines
- Variants available
- Props/parameters
- Accessibility notes
- Code examples (if applicable)

### 6. Create Component Library
- Organize in design tool (Figma, Sketch)
- Naming conventions
- Auto-layout where possible
- Make reusable components

## Example: Button Component

**Variants:**
- Primary, Secondary, Tertiary
- Small, Medium, Large
- Default, Hover, Pressed, Disabled

**States:**
```
Primary Button
  - Default: bg-primary, text-white
  - Hover: bg-primary-dark
  - Pressed: bg-primary-darker
  - Disabled: bg-gray-300, text-gray-500
```

## Voice Announcement
```
🎯 COMPLETED: [SKILL:design] UI components designed
🗣️ CUSTOM COMPLETED: Components ready
```

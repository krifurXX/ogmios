# UX/UI Design Principles

## Core UX Principles

### 1. User-Centered Design
Design based on user needs, not business assumptions.

**Process:**
- Research user needs
- Create user personas
- Map user journeys
- Test with real users
- Iterate based on feedback

### 2. Simplicity
The best interface is invisible.

**Practices:**
- Remove unnecessary elements
- One primary action per screen
- Progressive disclosure
- Clear visual hierarchy
- Minimize cognitive load

### 3. Consistency
Familiar patterns reduce learning curve.

**Apply to:**
- Visual design (colors, typography)
- Interaction patterns (navigation, buttons)
- Language and tone
- Layout and spacing

### 4. Accessibility
Design for everyone, including users with disabilities.

**Requirements:**
- WCAG 2.1 AA compliance
- Color contrast ratios
- Keyboard navigation
- Screen reader support
- Alt text for images

### 5. Feedback
System should respond to user actions.

**Types:**
- Visual (button states, loading indicators)
- Auditory (sounds, voice)
- Haptic (vibration on mobile)
- Text (confirmation messages, errors)

### 6. Error Prevention
Better to prevent errors than handle them.

**Strategies:**
- Constraints (disable invalid options)
- Defaults (pre-fill when possible)
- Confirmation dialogs (destructive actions)
- Validation (inline, real-time)
- Clear instructions

## UI Design Principles

### Visual Hierarchy
Guide user attention through:
- Size (larger = more important)
- Color (contrast for emphasis)
- Position (top-left most prominent)
- Spacing (whitespace creates grouping)
- Typography (weight, style)

### Typography
- Max 2-3 font families
- Clear hierarchy (H1 > H2 > Body)
- Readable sizes (min 16px for body)
- Appropriate line height (1.5 for body)
- Limited line length (50-75 characters)

### Color
- Primary color (brand, main actions)
- Secondary colors (supporting actions)
- Neutral colors (text, backgrounds)
- Semantic colors (success, warning, error)
- Test for color blindness

### Spacing
- Consistent spacing scale (4px, 8px, 16px, 24px, 32px)
- Whitespace for breathing room
- Proximity groups related items
- Alignment creates order

### Imagery
- High quality photos
- Consistent style
- Meaningful illustrations
- Icons for recognition (not decoration)
- Optimize for performance

## Interaction Design Principles

### Affordances
UI elements should suggest how to use them:
- Buttons look clickable (3D, shadows)
- Links are blue and underlined
- Inputs have borders
- Disabled elements are grayed

### Micro-interactions
Small moments of delight:
- Button press animation
- Loading transitions
- Success confirmations
- Hover effects

### Navigation
- Clear current location
- Easy return to home
- Breadcrumbs for depth
- Search for large sites
- Max 7 items in menu

## Mobile-Specific Principles

### Touch Targets
- Minimum 44x44px (iOS), 48x48px (Android)
- Adequate spacing between targets
- Thumb-friendly zones

### Progressive Disclosure
- Show only essential on small screens
- Collapse advanced options
- Use expandable sections

### Performance
- Fast load times critical
- Optimize images
- Minimize requests
- Cache when possible

## Accessibility Guidelines

### WCAG 2.1 Quick Reference

**Perceivable:**
- Text alternatives for images
- Captions for video
- Adaptable layouts
- Color contrast 4.5:1 (text), 3:1 (UI)

**Operable:**
- Keyboard accessible
- No time limits (or adjustable)
- No seizure triggers
- Clear navigation

**Understandable:**
- Readable text
- Predictable behavior
- Input assistance
- Error suggestions

**Robust:**
- Compatible with assistive tech
- Valid HTML/ARIA

## Design Process

1. **Discover**: Research, understand users
2. **Define**: Problem statement, requirements
3. **Ideate**: Brainstorm, sketch variations
4. **Prototype**: Create testable designs
5. **Test**: Validate with users
6. **Iterate**: Refine based on feedback
7. **Deliver**: Hand off to development

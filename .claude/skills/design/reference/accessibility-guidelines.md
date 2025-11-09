# Accessibility Guidelines

## WCAG 2.1 Level AA Compliance

### Color Contrast
**Text:**
- Normal text: 4.5:1 minimum
- Large text (18pt+): 3:1 minimum

**UI Components:**
- Interactive elements: 3:1 minimum
- Graphical objects: 3:1 minimum

**Tools:**
- Chrome DevTools (Lighthouse)
- Contrast Checker plugins
- WebAIM Contrast Checker

### Keyboard Navigation
**Requirements:**
- All interactive elements accessible via keyboard
- Visible focus indicators
- Logical tab order
- Skip navigation links
- No keyboard traps

**Tab Order:**
```
- Header navigation
- Main content
- Sidebar
- Footer
```

### Screen Reader Support
**Best Practices:**
- Semantic HTML (h1-h6, nav, main, aside)
- ARIA labels where needed
- Alt text for images
- Form labels properly associated
- Error messages announced

**ARIA Usage:**
```html
<!-- Button with icon -->
<button aria-label="Close dialog">
  <span aria-hidden="true">×</span>
</button>

<!-- Loading state -->
<div aria-live="polite" aria-busy="true">
  Loading...
</div>
```

### Focus Management
- Visible focus indicators
- Logical focus order
- Modal focus trapping
- Focus return after modal close

## Color Accessibility

### Don't Rely on Color Alone
❌ Red/green for error/success only
✅ Icons + color + text

### Color Blind Safe Palettes
- Test with color blind simulators
- Use patterns in addition to color
- High contrast modes support

### Dark Mode Considerations
- Maintain contrast ratios
- Adjust colors for readability
- Test in both modes

## Touch and Motor Accessibility

### Touch Target Sizes
- Minimum 44x44px (iOS)
- Minimum 48x48dp (Android)
- 8px spacing between targets

### Click/Tap Areas
- Large enough for motor disabilities
- Padding around text links
- Avoid tiny interactive elements

## Content Accessibility

### Heading Hierarchy
- One h1 per page
- Don't skip levels (h2 → h4)
- Descriptive heading text

### Link Text
❌ "Click here"
✅ "Download the 2024 report"

### Form Labels
```html
<!-- Properly associated -->
<label for="email">Email:</label>
<input id="email" type="email" required>

<!-- Error message -->
<span id="email-error" role="alert">
  Please enter a valid email
</span>
```

### Alternative Text
**Images:**
```html
<!-- Informative -->
<img src="chart.png" alt="Sales increased 50% in Q4">

<!-- Decorative -->
<img src="divider.png" alt="">
```

## Testing Checklist

### Automated Testing
- [ ] Run Lighthouse audit
- [ ] Use axe DevTools
- [ ] Check WAVE browser extension
- [ ] Validate HTML

### Manual Testing
- [ ] Keyboard navigation works
- [ ] Screen reader announces correctly
- [ ] Contrast ratios pass
- [ ] Touch targets adequate size
- [ ] Zoom to 200% still usable

### User Testing
- [ ] Test with screen reader users
- [ ] Test with keyboard-only users
- [ ] Test with color blind simulators
- [ ] Test on mobile devices

## Common Accessibility Issues

### Missing Alt Text
Fix: Add descriptive alt text or alt="" for decorative

### Low Contrast
Fix: Adjust colors to meet 4.5:1 ratio

### No Keyboard Access
Fix: Ensure all interactive elements are focusable

### Missing Form Labels
Fix: Add <label> or aria-label

### Poor Focus Indicators
Fix: Add visible focus outline/ring

### Inaccessible Modals
Fix: Trap focus, add close button, ESC key support

## Resources

**Guidelines:**
- WCAG 2.1: https://www.w3.org/WAI/WCAG21/quickref/
- WAI-ARIA: https://www.w3.org/WAI/ARIA/apg/

**Tools:**
- axe DevTools
- WAVE
- Lighthouse
- Screen readers (NVDA, JAWS, VoiceOver)

**Learning:**
- A11y Project: https://www.a11yproject.com/
- WebAIM: https://webaim.org/

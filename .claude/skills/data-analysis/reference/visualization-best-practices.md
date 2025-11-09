# Data Visualization Best Practices

## Chart Selection

### Time Series Data
✅ Line chart
❌ Bar chart (unless discrete time points)

### Comparisons
✅ Bar chart (horizontal for long labels)
❌ Pie chart for many categories

### Distributions
✅ Histogram or box plot
❌ Bar chart of individual values

### Relationships
✅ Scatter plot with trend line
❌ Table of correlation coefficients only

## Design Principles

### 1. Clarity
- One main message per chart
- Remove unnecessary elements
- Clear labels and title
- Appropriate font sizes

### 2. Accessibility
- Color blind safe palettes
- Sufficient contrast
- Text alternatives
- Pattern fills in addition to color

### 3. Honesty
- Start y-axis at zero (for bars)
- Consistent scales
- Show uncertainty
- Don't mislead with truncation

### 4. Context
- Annotations for key events
- Reference lines (average, target)
- Time range in title
- Data source citation

## Color Usage

### Categorical Data
Use distinct hues:
- Qualitative color schemes
- Maximum 7-8 categories
- Consider color blind users

### Sequential Data
Use single hue gradient:
- Light to dark
- Consistent direction
- Clear scale

### Diverging Data
Two hues meeting at middle:
- Red-Blue for pos/neg
- Center at meaningful value (zero, average)

## Common Mistakes

❌ 3D charts (distortion)
❌ Too many pie slices
❌ Dual axes (confusing)
❌ Truncated axes (misleading)
❌ Rainbow color scales (not sequential)
❌ Chart junk (unnecessary decoration)

✅ 2D charts
✅ Bar chart for many categories
✅ Separate charts or faceting
✅ Full range or clearly marked break
✅ Sequential color scales
✅ Minimal, clean design

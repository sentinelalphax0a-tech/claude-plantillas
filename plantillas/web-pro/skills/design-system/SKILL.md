---
name: design-system
description: >
  Sistema de diseño y estética visual. Usa SIEMPRE que se cree o modifique
  cualquier componente UI, página, layout, o elemento visual. Garantiza que
  el resultado no parezca genérico ni hecho por IA. Cubre tipografía,
  color, espaciado, animaciones, micro-interacciones y patrones visuales.
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Design System Skill — Anti-IA, Pro-Calidad

## REGLA #1: Si parece hecho por IA, está mal

### Señales de "hecho por IA" (EVITAR SIEMPRE)
- Grid de 3 cards idénticas con iconos circulares arriba
- Hero con h1 + subtitle + 2 botones centrados sobre gradiente
- Gradientes lineales azul→morado o azul→rosa
- Secciones alternas blanco/gris con el mismo padding
- Cards con border-radius uniforme y sombra idéntica
- Textos genéricos: "Welcome", "Get Started", "Our Services"
- Imágenes de stock (personas sonriendo con laptops)
- Layout perfectamente simétrico sin ninguna tensión visual

### Qué hacer en su lugar
- **Asimetría controlada**: columnas de anchos diferentes, elementos
  desalineados intencionalmente, overlapping elements
- **Tipografía como protagonista**: títulos grandes (clamp(2rem, 5vw, 4.5rem)),
  pesos mixtos, letter-spacing negativo en headings grandes
- **Espaciado variable**: no todo padding-8. Usar escalas como
  4, 8, 12, 16, 24, 32, 48, 64, 96 (saltos irregulares)
- **Color con restricción**: 1 color de acento usado con moderación.
  80% neutros, 15% primario, 5% acento
- **Movimiento sutil**: entradas staggered (no todo a la vez),
  parallax suave, hover que revela información
- **Texturas y profundidad**: grain overlays, glassmorphism selectivo,
  sombras con color (no rgba(0,0,0,0.1) sino rgba(primaryColor, 0.15))

## Tipografía

### Setup de fonts (SIEMPRE locales, nunca Google Fonts CDN)
```css
/* globals.css — Ejemplo con Satoshi + Cabinet Grotesk */
@font-face {
  font-family: 'Satoshi';
  src: url('/fonts/Satoshi-Variable.woff2') format('woff2');
  font-weight: 300 900;
  font-display: swap;
}

@font-face {
  font-family: 'Cabinet Grotesk';
  src: url('/fonts/CabinetGrotesk-Variable.woff2') format('woff2');
  font-weight: 100 900;
  font-display: swap;
}
```

### Escala tipográfica con clamp()
```css
:root {
  --text-xs: clamp(0.75rem, 0.7rem + 0.25vw, 0.875rem);
  --text-sm: clamp(0.875rem, 0.8rem + 0.35vw, 1rem);
  --text-base: clamp(1rem, 0.9rem + 0.5vw, 1.125rem);
  --text-lg: clamp(1.125rem, 1rem + 0.65vw, 1.25rem);
  --text-xl: clamp(1.25rem, 1rem + 1.25vw, 1.75rem);
  --text-2xl: clamp(1.5rem, 1rem + 2.5vw, 2.5rem);
  --text-3xl: clamp(2rem, 1rem + 5vw, 3.5rem);
  --text-hero: clamp(2.5rem, 1rem + 7.5vw, 5rem);
}
```

### Reglas tipográficas
- Headings: font-weight 700-900, letter-spacing -0.02em a -0.04em
- Body: font-weight 400, line-height 1.6-1.7
- Captions/labels: font-weight 500, uppercase con letter-spacing 0.05em
- Nunca más de 65-70 caracteres por línea (max-w-prose)
- Contraste mínimo: 4.5:1 para texto normal, 3:1 para texto grande

## Animaciones y Micro-interacciones

### Principios de movimiento
- Duración: 150-300ms para UI, 300-600ms para transiciones de página
- Easing: nunca linear. Usar cubic-bezier(0.16, 1, 0.3, 1) (ease-out expo)
- Stagger: 50-100ms entre elementos en listas
- Dirección: los elementos entran desde donde tiene sentido
  (sidebar desde la izquierda, toast desde arriba, modal desde abajo)

### Framer Motion patterns
```tsx
// Entrada staggered de elementos
const container = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: { staggerChildren: 0.08 }
  }
};

const item = {
  hidden: { opacity: 0, y: 20 },
  show: { 
    opacity: 1, y: 0,
    transition: { duration: 0.5, ease: [0.16, 1, 0.3, 1] }
  }
};

// Hover con escala sutil (NO transform: scale(1.05) — demasiado)
<motion.div whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.98 }} />

// Loading skeleton con shimmer
<div className="animate-pulse bg-gradient-to-r from-muted via-muted/50 to-muted
  bg-[length:200%_100%] animate-[shimmer_1.5s_infinite]" />
```

### Transiciones de estado (OBLIGATORIAS)
Todo elemento interactivo necesita estos estados con transición suave:
1. **Default** → estado base
2. **Hover** → cambio sutil (color, sombra, translate -1px)
3. **Focus-visible** → ring visible (accesibilidad, outline-2 offset-2)
4. **Active/Pressed** → feedback inmediato (scale 0.98)
5. **Loading** → spinner o skeleton (nunca bloquear la UI)
6. **Disabled** → opacity reducida + cursor not-allowed
7. **Success** → feedback positivo (check, color verde, toast)
8. **Error** → feedback claro (color rojo, mensaje específico, shake sutil)

## Componentes shadcn/ui — Cómo personalizar

NUNCA usar shadcn/ui tal cual sale de la caja. Siempre personalizar:

```tsx
// ❌ MAL — Button genérico de shadcn
<Button variant="default">Click me</Button>

// ✅ BIEN — Button personalizado con la identidad del proyecto
<Button 
  className="rounded-xl font-semibold tracking-tight
    shadow-[0_1px_2px_rgba(var(--primary-rgb),0.3)]
    hover:shadow-[0_4px_12px_rgba(var(--primary-rgb),0.25)]
    active:scale-[0.98] transition-all duration-200"
>
  Click me
</Button>
```

## Responsive — Mobile-first real

```css
/* BASE = móvil (375px). Escalar HACIA ARRIBA */
.hero-title {
  font-size: var(--text-3xl);     /* móvil */
  padding: 1.5rem;
}

@media (min-width: 768px) {       /* tablet */
  .hero-title {
    font-size: var(--text-hero);
    padding: 3rem;
  }
}

@media (min-width: 1024px) {      /* desktop */
  .hero-title {
    padding: 4rem 6rem;
  }
}
```

### Breakpoints de testing obligatorios
- 375px (iPhone SE — el más estrecho)
- 390px (iPhone 14)
- 768px (iPad)
- 1024px (laptop)
- 1280px (desktop)
- 1536px (wide)

## Dark Mode
- No invertir colores. Diseñar dark mode como un tema propio
- Fondos oscuros: #09090b, #0a0a0a, #111111 (NO negro puro #000000)
- Reducir el brillo de colores de acento un 10-15% en dark
- Sombras en dark: usar sombras de borde o glow sutil, no drop-shadow
- Imágenes: considerar brightness(0.9) en dark mode

---
name: mobile-design
description: >
  Diseño móvil profesional. Se activa SIEMPRE que se trabaje en componentes UI.
  Cubre touch targets, safe areas, navegación, tipografía, inputs, imágenes,
  performance y accesibilidad táctil.
---

# Mobile Design — Reglas obligatorias

Estas reglas se aplican en TODOS los componentes con interfaz visual.
No son opcionales. El móvil es el dispositivo principal del usuario.

## Touch targets

- Mínimo **44×44px** para cualquier elemento interactivo (estándar Apple HIG)
- Usar `min-h-[44px] min-w-[44px]` en Tailwind para todos los botones, links, íconos
- Separación mínima entre targets: 8px (evitar clics accidentales)
- Si el elemento visual es pequeño (ícono 20px), agregar padding invisible:
  ```css
  .icon-button { padding: 12px; } /* 12 + 20 + 12 = 44px total */
  ```

## Safe areas (notch, home indicator, barra de estado)

```css
/* En globals.css */
body {
  padding-top: env(safe-area-inset-top);
  padding-bottom: env(safe-area-inset-bottom);
  padding-left: env(safe-area-inset-left);
  padding-right: env(safe-area-inset-right);
}

/* En headers fijos */
.header-fixed {
  padding-top: calc(env(safe-area-inset-top) + 16px);
}

/* En nav bottom */
.bottom-nav {
  padding-bottom: calc(env(safe-area-inset-bottom) + 8px);
}
```

En Tailwind con plugin de safe-area:
```
npm install tailwindcss-safe-area
```
```jsx
<nav className="pb-safe pt-2">...</nav>
```

## Patrones de navegación móvil

### Bottom Tab Bar (preferido para apps con 3-5 secciones)
```jsx
// Posición fija abajo, siempre visible, safe-area respetada
<nav className="fixed bottom-0 left-0 right-0 bg-white border-t pb-safe z-50">
  {tabs.map(tab => (
    <Link key={tab.href} href={tab.href} className="flex flex-col items-center min-h-[44px] justify-center">
      <tab.Icon size={24} />
      <span className="text-xs mt-1">{tab.label}</span>
    </Link>
  ))}
</nav>
```

### Hamburger / Drawer lateral
- El botón hamburger: mínimo 44×44px
- Drawer: ocupa máximo 85vw en móvil (dejar contexto visible)
- Cerrar con: botón X, swipe left, tap fuera del drawer
- Animación: `transform translateX` (GPU-accelerated, no `left/right`)

### Swipe gestures
- Usar `@use-gesture/react` para gestures controladas
- Siempre proveer alternativa táctil (botón) para cada swipe
- No depender exclusivamente de swipe (accesibilidad)

## Tipografía móvil

```css
/* MÍNIMOS — nunca bajar de estos valores */
--text-body: 16px;      /* iOS hace zoom si < 16px en inputs */
--text-caption: 14px;   /* Solo para metadata secundaria */
--text-micro: 12px;     /* Absoluto mínimo, solo si hay espacio visual */

/* Line heights para legibilidad táctil */
--leading-body: 1.6;
--leading-heading: 1.2;
```

En Tailwind: `text-base` (16px) como mínimo para texto de contenido.

**CRÍTICO**: Inputs con `font-size < 16px` causan zoom automático en iOS Safari.
Siempre `text-base` o superior en `<input>`, `<select>`, `<textarea>`.

## Breakpoints obligatorios

```js
// tailwind.config.js
screens: {
  'se': '375px',      // iPhone SE — el más pequeño que debes soportar
  'sm': '390px',      // iPhone 14/15 — baseline móvil moderno
  'pro': '393px',     // iPhone 15 Pro
  'pixel': '412px',   // Pixel — Android más común
  'md': '768px',      // iPad vertical
  'lg': '1024px',     // iPad horizontal / laptop pequeño
  'xl': '1280px',     // Desktop
  '2xl': '1536px',    // Desktop grande
}
```

Proceso de diseño: **mobile-first siempre**.
```jsx
// ✅ Correcto: base = móvil, md: = desktop
<div className="flex-col md:flex-row">

// ❌ Incorrecto: base = desktop, ocultar en móvil
<div className="hidden md:flex">  {/* evitar si el contenido es importante */}
```

## Scroll horizontal — PROHIBIDO

```css
/* En globals.css — obligatorio */
body, html {
  overflow-x: hidden;
  max-width: 100vw;
}

/* Verificar con DevTools: ningún elemento debe causar scroll-x */
```

Causas comunes de scroll horizontal:
- `width: 100vw` en elementos con scroll vertical (17px de scrollbar en desktop)
- Usar `min-w-full` en tablas sin `overflow-x: auto` en el contenedor
- Elementos con `position: absolute` fuera del viewport

Solución para tablas:
```jsx
<div className="overflow-x-auto w-full">
  <table className="min-w-full">...</table>
</div>
```

## Inputs móvil

### inputmode correcto
```jsx
// Teclado numérico (sin decimales)
<input inputMode="numeric" pattern="[0-9]*" />

// Teclado con decimales
<input inputMode="decimal" />

// Teclado de teléfono (con +, *, #)
<input inputMode="tel" type="tel" />

// Teclado de email (con @, .)
<input inputMode="email" type="email" />

// URL (con /, .)
<input inputMode="url" type="url" />
```

### Autocompletado
```jsx
// Siempre definir autocomplete para formularios
<input autoComplete="given-name" />
<input autoComplete="family-name" />
<input autoComplete="email" />
<input autoComplete="tel" />
<input autoComplete="current-password" />
<input autoComplete="new-password" />
<input autoComplete="cc-number" />  // tarjeta de crédito
```

### Prevenir zoom en iOS
```jsx
// ✅ font-size ≥ 16px en todos los inputs
<input className="text-base" />  // 16px en Tailwind

// ✅ También en selects y textareas
<select className="text-base" />
<textarea className="text-base" />
```

## Imágenes responsivas

```jsx
// ✅ Siempre usar next/image con sizes definido
import Image from 'next/image'

<Image
  src="/hero.jpg"
  alt="Descripción"
  fill  // o width/height explícito
  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
  loading="lazy"  // nativo, no necesita JS
  priority={false}  // solo true para above-the-fold
/>

// Para imágenes de fondo en CSS
// Usar srcset con picture element para art direction
<picture>
  <source media="(max-width: 767px)" srcSet="/hero-mobile.webp" />
  <source media="(min-width: 768px)" srcSet="/hero-desktop.webp" />
  <img src="/hero-desktop.webp" alt="Descripción" loading="lazy" />
</picture>
```

**Formatos**: WebP con fallback JPEG. AVIF donde sea posible.
**Dimensiones**: nunca servir imagen de 2000px para un slot de 400px.

## Performance móvil

### Connection-aware loading
```js
// Detectar conexión lenta
const connection = navigator.connection || navigator.mozConnection
const isSlowConnection = connection?.effectiveType === '2g' ||
                         connection?.effectiveType === 'slow-2g'

// Cargar versión reducida si conexión lenta
const videoSrc = isSlowConnection ? null : '/hero-video.mp4'
```

### Reducir JS para redes lentas
```jsx
// Usar Server Components por defecto (0 JS al cliente)
// 'use client' solo cuando sea absolutamente necesario

// Lazy load de secciones pesadas
const HeavyComponent = dynamic(() => import('./HeavyComponent'), {
  loading: () => <Skeleton />,
  ssr: false  // si no necesita SSR
})
```

### Bundle budget
- JS inicial: < 200KB comprimido
- LCP: < 2.5s en 4G
- TTI: < 3.8s en 4G
- CLS: < 0.1

## Dark mode

```css
/* Respetar preferencia del sistema siempre */
@media (prefers-color-scheme: dark) {
  :root {
    --background: #0a0a0a;
    --foreground: #ededed;
  }
}
```

En Tailwind:
```js
// tailwind.config.js
darkMode: 'media'  // respeta sistema, no necesita toggle
// O 'class' si quieres toggle manual
```

```jsx
// ✅ Siempre incluir variante dark
<div className="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
```

**Imágenes en dark mode**: considerar versión alternativa o `filter: invert()` para íconos.

## Toasts y notificaciones

```jsx
// ✅ Posición: ABAJO (el pulgar está ahí, es más natural)
// ❌ Posición: arriba (obstruye la barra de estado y el contenido superior)

// Con react-hot-toast
import toast, { Toaster } from 'react-hot-toast'

<Toaster
  position="bottom-center"  // no "top-center"
  containerStyle={{
    bottom: 'calc(env(safe-area-inset-bottom) + 16px)',
  }}
  toastOptions={{
    duration: 3000,
    style: {
      maxWidth: '90vw',
      fontSize: '14px',
    }
  }}
/>
```

## Modales y drawers

```jsx
// Modales en móvil: ocupar pantalla completa o casi
<Dialog className="
  fixed inset-x-0 bottom-0
  rounded-t-2xl
  max-h-[90vh]
  overflow-y-auto
  pb-safe
">
  {/* Indicador de drag */}
  <div className="w-10 h-1 bg-gray-300 rounded-full mx-auto mt-3 mb-4" />
  ...
</Dialog>

// En desktop: modal centrado tradicional
// Usar variantes responsive
```

## Checklist rápido antes de "terminado"

```
□ Touch targets ≥ 44×44px verificados
□ Safe areas aplicadas (header, bottom nav)
□ font-size ≥ 16px en TODOS los inputs
□ No hay scroll horizontal (verificar en 375px)
□ Imágenes con next/image + sizes correctos
□ Dark mode funciona
□ Toasts posicionados abajo
□ Modales full-screen en móvil
□ Probado en 375px (iPhone SE) y 390px (iPhone 14)
□ inputMode correcto en formularios
```

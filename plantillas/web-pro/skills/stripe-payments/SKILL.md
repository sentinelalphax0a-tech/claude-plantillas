---
name: stripe-payments
description: >
  Integración de pagos con Stripe. Usa cuando el proyecto necesite
  cobros, suscripciones, checkout, webhooks, customer portal, o
  cualquier funcionalidad de pagos. Cubre Stripe Checkout, subscriptions,
  one-time payments, y webhooks seguros.
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Stripe Payments Skill

## Arquitectura de pagos (CRÍTICA)

```
CLIENTE (browser)              SERVIDOR (API routes)           STRIPE
─────────────────              ─────────────────────           ──────
  click "Comprar"
       │
       ├──→ POST /api/checkout ──→ stripe.checkout.sessions.create()
       │                                    │
       │         ←── redirect URL ──────────┘
       │
  redirect a Stripe Checkout
       │
       │                          webhook: checkout.session.completed
       │                                    │
       │                          ←─────────┘
       │                          Activar suscripción en DB
       │
  redirect a /success
```

### REGLA DE ORO
**NUNCA confiar en el cliente para confirmar un pago.**
El cliente puede ser manipulado. SOLO el webhook es la fuente de verdad.

## Setup inicial

### 1. Variables de entorno
```env
# .env.local (NUNCA commitear)
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...

# Precios (crear en Stripe Dashboard primero)
STRIPE_PRICE_PRO_MONTHLY=price_...
STRIPE_PRICE_PRO_YEARLY=price_...
```

### 2. Cliente Stripe (servidor)
```ts
// src/lib/stripe/client.ts
import Stripe from 'stripe';

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2025-01-27.acacia', // usar la última versión estable
  typescript: true,
});
```

## Checkout Session (patrón completo)

```ts
// src/app/api/checkout/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { stripe } from '@/lib/stripe/client';
import { createServerClient } from '@/lib/supabase/server';

export async function POST(req: NextRequest) {
  // 1. Verificar autenticación
  const supabase = await createServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: 'No autenticado' }, { status: 401 });

  // 2. Obtener o crear Stripe customer
  const { data: profile } = await supabase
    .from('profiles')
    .select('stripe_customer_id')
    .eq('id', user.id)
    .single();

  let customerId = profile?.stripe_customer_id;
  if (!customerId) {
    const customer = await stripe.customers.create({
      email: user.email,
      metadata: { supabase_user_id: user.id },
    });
    customerId = customer.id;
    await supabase
      .from('profiles')
      .update({ stripe_customer_id: customerId })
      .eq('id', user.id);
  }

  // 3. Crear Checkout Session
  const { priceId } = await req.json();
  const session = await stripe.checkout.sessions.create({
    customer: customerId,
    mode: 'subscription', // o 'payment' para one-time
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: `${req.nextUrl.origin}/billing?success=true`,
    cancel_url: `${req.nextUrl.origin}/pricing`,
    metadata: { supabase_user_id: user.id },
  });

  return NextResponse.json({ url: session.url });
}
```

## Webhook handler (la parte más importante)

```ts
// src/app/api/webhooks/stripe/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { stripe } from '@/lib/stripe/client';
import { createServiceClient } from '@/lib/supabase/admin';
import { headers } from 'next/headers';

export async function POST(req: NextRequest) {
  const body = await req.text();
  const signature = (await headers()).get('stripe-signature')!;

  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    );
  } catch (err) {
    console.error('Webhook signature verification failed:', err);
    return NextResponse.json({ error: 'Firma inválida' }, { status: 400 });
  }

  const supabase = createServiceClient(); // Admin client, sin RLS

  switch (event.type) {
    case 'checkout.session.completed': {
      const session = event.data.object as Stripe.Checkout.Session;
      await supabase
        .from('profiles')
        .update({
          subscription_status: 'active',
          stripe_subscription_id: session.subscription as string,
        })
        .eq('id', session.metadata?.supabase_user_id);
      break;
    }
    case 'customer.subscription.updated':
    case 'customer.subscription.deleted': {
      const subscription = event.data.object as Stripe.Subscription;
      await supabase
        .from('profiles')
        .update({
          subscription_status: subscription.status,
        })
        .eq('stripe_customer_id', subscription.customer as string);
      break;
    }
    case 'invoice.payment_failed': {
      // Notificar al usuario, reintentar, o downgrade
      break;
    }
  }

  return NextResponse.json({ received: true });
}
```

## Testing local de webhooks
```bash
# Terminal 1: tu app
npm run dev

# Terminal 2: Stripe CLI forward
stripe listen --forward-to localhost:3000/api/webhooks/stripe
# Copia el whsec_... a .env.local

# Terminal 3: trigger test events
stripe trigger checkout.session.completed
stripe trigger customer.subscription.deleted
```

## Customer Portal (gestión de suscripción)
```ts
// Permitir al usuario gestionar su suscripción
const portalSession = await stripe.billingPortal.sessions.create({
  customer: customerId,
  return_url: `${origin}/billing`,
});
// Redirect a portalSession.url
```

## Checklist de seguridad Stripe
- [ ] Webhook signature siempre verificada
- [ ] Secret key solo en servidor (nunca NEXT_PUBLIC_)
- [ ] Idempotency keys para operaciones críticas
- [ ] Manejo de todos los estados de suscripción (active, past_due, canceled, unpaid)
- [ ] Rate limiting en endpoint de checkout
- [ ] Logs de todos los eventos de webhook para auditoría

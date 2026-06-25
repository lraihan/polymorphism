# SIGAP — Emergency Reporting & Response for Indonesian Fire Services

**A mobile-and-web platform that connects citizens to their city's fire & rescue service (Damkar) with precise location — and gives the service the tools to dispatch, respond, and prove its response time.**

| | |
|---|---|
| **Role** | Solo founder — product strategy, research, UX & flows, design system, architecture |
| **Type** | Multi-tenant SaaS for government (B2G) |
| **Platforms** | iOS / Android (citizen + field crew) · Web (command center) |
| **Stack** | Flutter · Firebase (Firestore, Auth, Cloud Functions) · real-time, offline-first |
| **Status** | Concept & product design — architecture and screen flows complete; high-fidelity prototype in design |

## Overview

SIGAP is an emergency reporting and response platform built for Indonesian municipal fire & rescue services, which handle far more than fires — rescues, trapped people, animal removal, road accidents, and floods. A citizen reports an emergency in one tap, or with structured detail, the report routes to a dispatcher with an exact location, and field crews respond — every incident timestamped against the 15-minute response-time standard each department is held to.

## The problem

When someone calls for help, the single most common reason a crew reaches the wrong place is that the caller can't describe their location precisely. At the same time, every Indonesian fire service answers to a mandated 15-minute response time (*waktu tanggap*, Permendagri 114/2018) — a metric departments actively report on and try to beat. The national emergency line covers part of this need, but it's voice-only and generic, with uneven coverage and weak handoffs to the fire service specifically.

## The insight

A panic button on its own is a commodity, and it competes with a free national service. The defensible product isn't the button — it's the operational layer that *measures and improves a department's response time*. So I made the **response clock the spine of the entire system** and treated the citizen app as one intake channel feeding it. That reframed the product from "here's a panic button" to "prove and improve your mandated response time" — something a fire-service director is already accountable for.

## What I designed

Three surfaces sharing one incident lifecycle and one design language:

- **Citizen app** — a dominant panic button for life-threatening emergencies, plus a structured report flow (type, photo, draggable-pin location) for everything else, with live tracking of the responding crew.
- **Field-responder app** — field-hardened and glanceable: high contrast, large targets, can't-miss assignment alerts, and one-tap status from en route to on scene to resolved.
- **Command dashboard** — a real-time posko view: a live incident queue with a ticking response clock on every case, a map of incidents and crews, dispatch tools, and the response-time analytics a department reports up the chain.

Underneath: a multi-tenant model where each department owns a geographic coverage area and incidents route by location, a co-brandable citizen app, and offline-first resilience — queued reports with an SMS fallback — for the moments connectivity matters most.

## Design & craft

The design language is built for a credible government emergency service: calm in normal use, urgent only when it matters. Colour is disciplined — red is reserved exclusively for emergencies so it never loses meaning, set against an institutional base for trust — and the live response clock is the signature element that recurs across every surface. All interface copy is in Bahasa Indonesia, named by what people do rather than how the system works.

## Approach

I worked research- and design-first: grounding the product in how Damkar actually operates — and where response most often breaks down — before defining a single screen, settling the architecture and flows, then producing a complete design brief to drive a high-fidelity prototype. The intended path to validation is a single design-partner department before any production build.

---

*SIGAP is a working title.*

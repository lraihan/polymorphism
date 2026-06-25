# ROAST POS — Multi-Tenant Restaurant Operations Platform

*A multi-tenant SaaS platform for Indonesian food & beverage businesses — six products built from a single Flutter monorepo on one shared business-logic core.*

---

## Overview

ROAST POS is an operations platform for restaurants, cafés, and F&B chains in Indonesia. Rather than a single point-of-sale app, it's a **suite of six products** — a tablet POS, a mobile companion app, a time-clock app, a web ordering surface, an admin console, and an integrated cipos terminal — all built from **one Flutter monorepo** that shares a single business-logic core.

The platform doesn't just record transactions; it models how a restaurant actually *runs* — from opening the doors in the morning to counting the cash drawer at night. It covers the full operational day, multi-station inventory down to individual ingredient lots, an owner-configurable menu and modifier system, dynamic payment methods spanning cash to QRIS to e-wallets, per-cashier cash reconciliation, configurable approval workflows, loyalty, staff attendance, and financial reporting — as a coherent, multi-tenant whole.

## The architectural challenge

The defining constraint was **six products, one codebase, zero duplicated business logic**. Every product is a thin presentation layer over the same shared core, which made the architecture decisions the whole project rests on:

- A **repository pattern as the only data layer** — UI and controllers never touch the database directly, so business rules live in exactly one place and every product inherits them identically.
- A **single source-of-truth toggle** that swaps the entire data layer between a live Firebase backend and an in-memory mock environment without touching a line of feature code — enabling the full app to run, be developed, and be tested offline against deterministic data.
- **Stream-first reactivity** throughout, so state changes propagate automatically from the data layer to every screen across every product.
- A **strict design-token system** (color, spacing, radius, typography, motion) with no hardcoded values, giving six products a consistent, themeable visual language from one source.
- Domain-correct money handling (integer Rupiah), a fully Bahasa Indonesia interface, and transactional integrity for the invariants that matter.

## Core systems

The platform is built from several substantial, interlocking domain systems:

- **Restaurant operational lifecycle** — an enforced state machine (Closed → Preparing → Open → Closing) where each transition gates real behavior: trading is only possible when open, opening requires a completed readiness checklist and cash float, and closing is blocked until every order is settled, every bill paid, and every table cleared — clean books by construction.
- **Multi-station inventory** — ingredient stock tracked per location and per lot, with station-relative availability (a dish is available only if the station that produces it has the stock), category-scoped reorder warnings so each station focuses on what matters to it, and an expiry-to-waste disposal flow with full shrinkage records.
- **Menu & variant builder** — item-scoped variants and modifier groups with required/optional and single/multi-select rules, signed price and stock impacts, and recipe-driven availability that ties the menu directly to inventory.
- **Dynamic payment configuration** — owner-defined payment methods as data rather than a fixed list, each tagged with a behavioral *kind* (cash, card, QRIS, e-wallet, transfer, voucher) so a branch can accept any mix of methods while the system still knows which ones drive cash handling.
- **Cash management** — per-cashier shifts with start/end balances and over-short reconciliation, configurable cash rounding (honestly accounted as an expected term, never a phantom shortage), explicit drawer movements (paid-outs, cash drops, refunds, float top-ups), and a real-time cash-in-drawer monitor.
- **Unified approvals** — a single configurable approval engine that any sensitive action (cancellations, refunds, disposals, high-value cash movements) routes through, with owner-defined approval paths and levels.
- **Supporting systems** — a loyalty program, staff and branch management with attendance integration (staff must be clocked in to log in), and sales/financial reporting with end-of-day reconciliation summaries.

## Engineering approach

The project is built with a deliberate, audit-first discipline. Major changes begin with a **read-only audit** that establishes ground truth against the live codebase before any design or implementation — a practice that repeatedly corrected wrong assumptions (a stock subsystem that looked like it needed a rewrite turned out to need a precise realignment; a presumed data bug turned out to be a logic bug) and prevented building on a faulty premise.

Work ships in **phased, independently committed slices**, each gated on a clean static analysis and a green test suite — currently **680+ passing tests** — so progress is always safe to stop and resume. The result is a large, complex domain delivered incrementally without regressions, on an architecture designed to keep six products in lockstep.

## Tech stack

Flutter · Dart 3 · GetX (state management & DI) · Firebase (Firestore, Auth, Cloud Functions, Hosting) · freezed (immutable models) · fl_chart (data visualization) · a multi-flavor build setup for the six product targets.

---

*Role: architecture, system design, and technical direction — defining the data-layer contracts, the domain models, the operational rules, and the design system that the six products are built on.*

# ProFund Manager
### Project Funding & Cost-Control Platform — web console + mobile companion

> A B2B SaaS platform that tracks every rupiah of a project across four states — budget, reserved, committed, actual — to give teams real-time cost visibility and stop over-budget surprises *before* the money is gone. Designed and built solo, end to end: product, UX, architecture, and implementation.

---

## At a glance

| | |
|---|---|
| **Role** | Solo founder & builder — product strategy, UX/UI, system architecture, implementation |
| **Type** | B2B SaaS · Project financial control / cost management |
| **Platforms** | Web/desktop console + iOS/Android companion (single Flutter codebase, two flavors) |
| **Stack** | Flutter · GetX · Firebase (Firestore, Cloud Functions) · freezed · repository pattern |
| **Market** | Indonesian project teams — Bahasa Indonesia UX, IDR-native |
| **Status** | Fully designed; functional high-fidelity prototypes of both apps; in active development |

---

## Overview

ProFund Manager is a project financial-control platform. It follows a project's money through its entire life — from the budget that's approved, to funds that are reserved, to commitments locked by purchase orders, to the actual cash that goes out — and keeps that picture accurate in real time.

The insight behind it: project budgets in Indonesia are usually managed across disconnected spreadsheets and accounting software that only records costs *after* they happen. ProFund instead controls cost **at the point of spend**, inside one integrated ecosystem — a dense web console for managers and procurement, and a focused mobile companion for directors and field teams.

## The problem

Most project teams discover they're over budget only after the money is already spent. Commitments that have quietly locked up funds — signed POs, vendor contracts — stay invisible until the invoice arrives, so a budget can look healthy while it's actually fully consumed. Approvals for revisions and large spend happen ad-hoc, with no authorization trail. Project-management tools track tasks and time but not the money lifecycle; accounting and ERP systems record actuals too late to prevent anything. Nothing holds a budget ceiling at the moment someone is about to spend.

## The solution — a four-state money model

The heart of the product is a **four-state model**. Every rupiah moves through **Budget → Reserved → Committed → Actual**, where:

```
Available = Budget − Reserved − Committed − Actual
```

with automatic *relief* at each transition (a reservation releases when it becomes a commitment; a commitment releases when it's paid). Because reservation (pre-encumbrance) is first-class, exposure always reflects reality — not just what's already been invoiced.

Over-budget is a deliberate, **record-first** state. It is *never* blocked — work continues — but it's flagged loud, propagates up the entire work-breakdown tree, and forces a director sign-off. Overruns become conscious decisions made at the right moment, instead of month-end surprises.

## Key features

- **Arbitrary-depth WBS** — a folder-like tree where any node holds both sub-nodes *and* documents; budgets and costs roll up all the way to the project root
- **Four-state tracking** with pre-encumbrance and automatic relief
- **Record-first over-budget exceptions** with a resolution lifecycle (open → reviewed → resolved)
- **DOA approvals** — a Delegation-of-Authority matrix with delegation and segregation of duties
- **Full procurement lifecycle** — PR → PO → Goods Receipt → Invoice (3-way match) → Payment
- **CAPEX/OPEX classification** as a third axis, split and rolled up automatically
- **Cash-flow forecasting**, vendor management, role-based dashboards (7 roles), and a complete audit trail
- **~30 reports** across budget & exposure, procurement, commitments, cost & margin, compliance, and multi-project consolidation

## Design

I designed a calm, finance-grade visual language — deep navy, treasury teal, and warm-neutral surfaces — with a monospaced treatment for all IDR figures so tabular numbers align and read precisely. A single four-state color system (reserved, committed, actual, and a loud over-budget red) runs through every budget bar, node, and report, so the model is legible at a glance anywhere in the product.

The entire experience is in Bahasa Indonesia and built for Indonesian project-finance conventions (IDR notation, *juta*/*miliar*). I produced a full design system and per-screen specifications across ~25 console screens and the mobile companion, and validated the direction with high-fidelity, interactive prototypes of both apps.

## Architecture & engineering

ProFund is **one Flutter codebase with two flavors** — Console (web/desktop) and Companion (mobile) — that share the same domain layer, use cases, and four-state calculation engine. The difference between them is an **adaptive presentation layer**: dense tables and Miller-column WBS navigation on the console; drill-down navigation, bottom-nav, and bottom sheets on mobile. Full feature parity on mobile is achieved through presentation, not by building a second app.

Data is a **flat Firestore model** — `nodes` and `lineItems` that each carry a `parentId` and an `ancestors[]` array. Budget aggregation is an **ancestor-walk inside a transaction**, so a single line item correctly rolls up through every parent to the project root without recursive reads. The app uses a repository pattern with `freezed` models and GetX for state, and ships with a **MockData backend that mirrors the Firestore interface** — so the entire UI runs in an offline demo mode and flips to live Firebase behind a single flag. Firestore is regioned to `asia-southeast1`.

## Key decisions

- **Money as four states, not one number.** Tracking reserved/committed/actual separately (with relief) keeps exposure accurate and makes pre-encumbrance first-class — the difference between a budget that *looks* fine and one that *is* fine.
- **Soft control over hard blocks.** Over-budget is recorded, made loud, and escalated — never silently blocked. Work never stops, but nothing slips by unseen.
- **Flat schema, transactional rollups.** Denormalized ancestor arrays turn arbitrary-depth WBS aggregation into a single transactional walk instead of expensive recursive queries.
- **One codebase, two adaptive flavors.** Sharing the domain and engine while adapting only the presentation keeps web and mobile permanently in sync.

## Outcome

The product is fully designed — architecture, money model, complete screen inventory, and design system — with **functional, high-fidelity prototypes of both the web console and the mobile companion**, demonstrated on a realistic scenario (*PT Lucid Finance*, an 11-project digital-banking portfolio). I also produced the go-to-market materials: a written sales proposal and an ecosystem pitch deck.

---

**Skills demonstrated:** product strategy · domain modeling (project finance & encumbrance accounting) · UX/UI & design systems · system architecture · Flutter + Firebase · B2B SaaS for an emerging market.

# Portfolio Entry — Curated Drops Auction App

> Replace `[App Name]` with your product's real name. Written for an English-facing portfolio; ask for a Bahasa Indonesia version if you need one.

---

## Metadata block

- **Role:** Founder · Product & UX lead · System architect (solo)
- **Platform:** Mobile (Flutter)
- **Backend:** Firebase — real-time listeners, Cloud Functions
- **Market:** Indonesia
- **Status:** In design (screen flows and design system defined; interactive prototype and build underway)

---

## Tagline (one line)

An auction app with a curator's eye — themed, timed drops instead of an endless marketplace.

---

## Short blurb (~60 words, for a project card)

`[App Name]` is a mobile auction platform reframed around **curated drops**: a curator assembles a themed sale of a few lots, schedules it, and it runs as a live timed event. Built on an auction-house proxy-bidding model with staggered closes and anti-snipe extensions, it trades the noise of an endless marketplace for taste, scarcity, and appointment viewing.

---

## Full description (~320 words, main portfolio entry)

Most auction apps are endless marketplaces — infinite listings, no point of view. `[App Name]` is built on the opposite instinct: scarcity and taste. The product centres on **curated drops**, where a curator assembles a themed sale of a handful of lots, sets the schedule, and the whole thing runs as a live, timed event with a real sense of occasion.

The system is organised around three roles. **Sellers** submit items for consideration. A **curator** reviews submissions, sets the financial terms, and assembles and schedules each drop — the curator is the product's point of view, the layer that turns a pile of listings into a show. **Buyers** browse the drops and compete live.

Bidding follows an auction-house model rather than a frantic one: ascending **proxy bidding**, where each buyer sets a secret maximum and the system bids on their behalf. The live experience is shaped by **staggered closes** — lots close in sequence, a spotlight moving down the running order — and **anti-snipe soft closes**, where a last-second bid extends the clock. Hidden reserves and absentee bids round out the house feel.

The design direction is editorial and image-forward, closer to a gallery catalogue than a shopping grid, with a deliberate contrast between a calm, paper-toned browsing experience and a dramatic, dark "gallery spotlight" mode for the live moment. The live lot screen is the hero: a price counting up, a tightening countdown ring, and unmistakable winning/outbid states.

Technically, it's designed as a Flutter mobile app on Firebase, using real-time listeners to stream the climbing price to every watcher and **server-side, transactional bid resolution** (via Cloud Functions) to keep the proxy logic fair and race-condition-free.

As a solo project, I led every layer: the product reframe, the three-role system design, the auction mechanics, the end-to-end screen flows, and the visual language.

---

## Highlights (crisp bullets for a sidebar)

- Reframed a generic auction concept into a curated, event-driven **drops** model built on scarcity and taste.
- Designed an auction-house **proxy-bidding** engine with staggered closes and anti-snipe extensions.
- Defined a **three-role system** (seller → curator → buyer) with the curator as the editorial layer.
- Designed a **real-time bidding architecture** on Firebase with server-side transactional bid resolution.
- Established an **editorial visual language** with a light-browse / dark-live mode split, anchored by a hero live-auction screen.

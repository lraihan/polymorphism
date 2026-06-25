# FitX Gym — Mobile App
*Product design & system architecture for a multi-branch fitness platform*

FitX is a mobile app for a multi-branch Indonesian gym, designed to turn everyday attendance into a habit and bring a scattered set of member services — class booking, personal training, barber and nail appointments, retail, and membership management — into one connected experience. I led the full product definition: strategy, information architecture, system design, end-to-end user flows, and visual direction, built toward a Flutter and Firebase implementation.

## The opportunity
Most gym apps bolt features onto a login screen and stop at booking. The harder, more valuable problem is retention — getting members to come back. FitX is built around a daily habit loop: scan in at the gym, watch a visit streak grow, book the next session. Everything else — progress tracking, retail, membership — is arranged as satellites around that core, so the app earns a daily open rather than an occasional one.

## Approach
- **Two-sided, one system.** Members and personal trainers share a single mobile app behind role-based access, with a separate admin application. The two sides connect directly: a trainer's bookable hours become the slots a member sees, and a workout a trainer assigns surfaces in that member's progress log — proving it's one platform, not two apps glued together.
- **One booking layer, two engines.** Instead of three separate booking features, every reservation is modeled as one of two patterns: seat-claiming (group classes, with capacity and waitlists) or provider-reservation (personal training, barber, nails). It keeps the system small while covering very different booking behaviors.
- **Built for the Indonesian market.** Per-branch barcode check-in, multi-branch from the ground up, Bahasa Indonesia throughout, QRIS and bank-transfer payments, and reserve-and-collect retail.
- **Gamified, dark visual language.** A bold, high-contrast, energetic interface that treats streaks, weekly calendars, and progress charts as the visual heroes — because the data is the motivation.

## Stack & process
Architected for Flutter and Firebase using a repository pattern and a mock-data-first approach, so the full interface runs before any backend is wired. The product moved from concept through a complete screen inventory and a navigable, end-to-end flow map into a high-fidelity prototype — a design-first process that locks the experience before implementation begins.

## Role
Solo founder and builder — product strategy, information architecture, two-sided system design, UX flows, and visual art direction.

**Stage:** Client pitch prototype, in design.

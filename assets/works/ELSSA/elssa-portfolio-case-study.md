# ELSSA — School management & parent engagement, reimagined for Indonesian high schools

*A platform that runs the school — and that parents open every morning.*

ELSSA is a school-management and parent-engagement platform built for Indonesian SMA/SMK (senior high and vocational schools). I designed and built it end-to-end as a solo founder: product strategy, UX/UI, the full design system, a clickable multi-role prototype, the Firebase architecture, and the go-to-market deck. Its wedge is the parent experience — the moment a student taps in at the school gate, their parent gets a notification, and from there grades, tuition, and school news are one tap away.

**Role** — Founder · product strategy, UX/UI design, prototyping, architecture
**Type** — Multi-product SaaS (mobile + web + biometric kiosk)
**Platform** — Flutter + Firebase
**Market** — Indonesia (SMA / SMK)
**Year** — 2025–2026
**Status** — High-fidelity prototype, pilot-ready pitch

## The problem

A single school day runs on a dozen disconnected tools. Announcements live in WhatsApp groups, attendance in paper books or spreadsheets, tuition (SPP) is billed by hand, grades get typed twice, and Dapodik is updated manually. Parents spend the day guessing how their child is doing. Teachers lose teaching time to administration. Tuition leaks through manual billing, and tunggakan (arrears) pile up. And school leadership has no single, real-time picture of attendance, finance, and academics. Nothing talks to anything else.

## The approach

Rather than build yet another standalone tool — or a heavy LMS — I designed ELSSA as one connected platform that runs daily operations *and* gives every parent a live window into their child's day. Crucially, it rides the systems Indonesian schools are already required to use: it imports rosters from Dapodik and exports grades to e-Rapor (supporting both Kurikulum 2013 and Kurikulum Merdeka), so it complements government systems instead of fighting them. That decision removes double data entry and takes compliance anxiety off the table — a recurring objection when selling software to schools.

The strategic wedge is parent engagement. Indonesian parents live in WhatsApp, so ELSSA meets them with the same instant, familiar notifications — but tied to what they care about most: their child's safety and progress. The signature moment is the morning *hadir*: when a student taps in at the gate, the parent's phone lights up — "Raihan sudah di sekolah · Hadir 06:58" — and opens into attendance history, grades, the SPP balance, and school announcements. That small daily reassurance is what earns a school its parents' trust, and the reason families open the app every single day.

## What it does

For parents, ELSSA is a live feed of their child's school life: attendance alerts the moment a student checks in, grades by subject and semester, the tuition balance with one-tap online payment, school announcements, leave and sick-day requests, and all of a family's children in a single account.

For teachers and staff, it removes administrative drag: attendance in seconds, a gradebook that exports straight to e-Rapor, assignments and learning materials, homeroom monitoring for wali kelas, and confidential records for guidance counselors (BK).

For the office and leadership, it's the operational backbone: online SPP billing, scheduling and class management, new-student admissions (PPDB), Dapodik import, financial and operational reporting, and a real-time dashboard showing attendance percentage, tuition collected, and trends at a glance.

Attendance itself is reimagined around three capture methods — biometric face and fingerprint check-in at the gate (with anti-spoofing and a manual fallback), GPS check-in from a student's phone for field activities, and an instant notification to parents for every tap.

## Design

I built a warm, modern design language around deep forest green, cream surfaces, and a single warm-orange accent, paired with a clean type system. Everything is phone-first and deliberately calm: the app should feel trustworthy and effortless for a parent glancing at it between errands, and fast for a teacher taking attendance before the bell. I prototyped all seven roles — student, parent, teacher, homeroom teacher, counselor, finance/admin, and principal — at high fidelity, including the unglamorous-but-essential states that products usually skip: loading, empty, error, and offline.

## Architecture

ELSSA is one connected platform spread across four surfaces: **ELSSA App** (mobile, for parents, students, and staff), **ELSSA Console** (web, for the office and leadership), **ELSSA Gate** (the biometric attendance kiosk at the gate), and **ELSSA Control** (the operator backbone). The most consequential decision was to give each school its own isolated Firebase project rather than a shared multi-tenant database. For a product handling children's attendance, grades, money, and biometrics, that isolation is the strongest possible privacy posture — one school's data is never mixed with another's — and it makes the trust conversation with cautious school leaders far simpler. Access is strictly role-based throughout, so sensitive information such as counseling notes stays confidential.

## What I delivered

Working solo, I produced the full product foundation: the architecture and data model, a complete UI design system and screen inventory, a clickable high-fidelity prototype covering every role and state, and a Bahasa Indonesia sales deck built around real screenshots captured from that prototype — written in natural, local copy aimed at school owners (yayasan) and principals. The result is a coherent product story and a pilot-ready pitch, taking ELSSA from a market insight to something a school can see, touch, and say yes to.

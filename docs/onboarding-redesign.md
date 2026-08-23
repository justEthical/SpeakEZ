# SpeakEZ — Onboarding Redesign (drop-off optimized)

_Date: 2026-07-05_

Goal: replace the "everyone starts A1 / auth-first / download-wait" onboarding with a personalized, high-completion flow modeled on Learna AI (see `LearnaOnboardindSS/`), adapted to SpeakEZ's existing controller and **bundled** content.

Companion doc: [product-critique.md](product-critique.md).

---

## Core philosophy: linear inputs, personalized-feeling output

Don't over-engineer branching. The conversion win comes from the *feeling* of personalization, not from actually re-routing the flow. So:

- **Keep the quiz linear.** No deep branching — it multiplies QA for little gain.
- **The emotional questions (why / pain statements / interests) are the hook, not the engine.** Their job is relatability + problem-agitation + micro-commitment, and to make the final plan *feel* bespoke. Don't build learning logic on their answers — but make **one** of them do something real so the app delivers on what it implied (see #7 → landing tab, and "can't speak" → conversation).
- **The word-pills are the truth.** They (not self-report, not the emotional questions) set `currentEnglishLevel`.
- **The reveal sells the personalization.** All the linear inputs pay off in a "You're B1 — here's your plan" moment that makes the whole thing feel tailored.

**The only 3 places anything actually adapts** (everything else is linear/cosmetic):
1. Self-report level (#4) → *gates* the word-pills (skip a band, set starting difficulty).
2. Word-pills (#10) → *set* `currentEnglishLevel` + landing content. The one objective measurement.
3. "Area to improve" (#7) → *pick* the landing tab.

## Guiding principles (why this converts)

1. **Defer auth to the end.** Current app shows login/signup first (`onboarding_screen.dart`) — the biggest drop-off point. Let users complete the whole quiz as a guest; ask to sign up only *after* the personalized payoff ("save your level & streak").
2. **Long but single-tap is fine.** Sunk-cost investment + a personalized result increases completion. Every screen = one tap, persistent progress bar, persistent back button.
3. **Objective placement, then reveal it.** Learna never shows a result. We set `currentEnglishLevel` from the word-pills and *show it* ("You're B1"). This is our edge and the fix for the hard-coded A1 (`onboarding_controller.dart:311`).
4. **Keep the existing Hindi download (no bundling for v1).** Hindi already downloads via `PreparingScreen` → `hi.zip`, so the download flow works unchanged — bundling was only a drop-off optimization; defer it. Repurpose `PreparingScreen` as the "building your plan" reveal with the real download running behind the checklist (labor illusion = real work). Word-pills placement is unaffected (uses the bundled vocab bank, on-device). **Sequence: download → level reveal → quick-win lesson** (the quick-win needs the pack; if download fails/offline, still show the level from word-pills and defer the quick-win).

## The reference flow (Learna, 18 screens)

Age gate → native language → self-report level (plant metaphor) → why learn → goal → 7 pain statements → area to improve → **word-pills ×3 bands (A1-A2 / B1-B2 / C1-C2)** → interests → "Creating your personal experience" (AI robot, fake %, checklist). Never shows an objective result; auth/paywall implied after.

---

## SpeakEZ target flow

Legend: **[E]** reuse existing onboarding question · **[N]** new screen · **[R]** repurpose existing screen.
Role: **HOOK** = emotional/cosmetic, feeds the "feels tailored" narrative but drives no logic · **REAL** = actually changes app behavior.

| # | Screen | Type | Role | Notes / maps to |
|---|--------|------|------|-----------------|
| 1 | Welcome + "Find your level · 2-min quiz" hook | N | HOOK | Lightweight value screen. Age gate OPTIONAL — cut for v1 unless needed for ads. |
| ~~2~~ | ~~Native language~~ | — | CUT | **Hindi-only app → hardcode `motherTongue = Hindi`.** Skip this screen. Remove/short-circuit `addLanguageBasedQuestionInOnboarding()` (`onboarding_controller.dart:373`). |
| ~~3~~ | ~~App language~~ | — | CUT | Hardcode app language. Skip this screen. |
| 4 | Self-report level (Beginner→Proficient = A1→C2) | N | REAL | **Gates the word-pills** (skip a band / set starting difficulty) + tie-break vs pills. Does NOT set the final level on its own. |
| 5 | Why learn English | N | HOOK | Re-enable commented-out `motivation`. Investment + relatability only. |
| 6 | 3 pain-point statements (True / Partially / Not true) | N | HOOK | Trim Learna's 7 to 3. Emotional mirroring + problem-agitation. Exception: "I understand but can't speak" → open **conversation** tab first (the one hook that does something real). |
| 7 | Which area to improve: Speaking / Listening / Vocabulary | N | REAL | Maps to your 3 features → picks landing tab. |
| 8 | Confidence | E | HOOK | Existing `confidence`. Minor: soft nudge in scoring tie-breaks only. |
| 9 | Daily study time | E | REAL | Existing `dailyStudyDuration` → daily goal + notification copy. |
| 10 | **Word-pills placement ×3 bands** | N | REAL | **THE objective level signal — the only thing that sets `currentEnglishLevel`.** A1-A2 / B1-B2 / C1-C2, ~18 words each from bundled vocab + 2 pseudowords/screen. |
| 11 | Interests (optional) | N | HOOK | Cosmetic for v1. Can feed conversation scenario recommendations later. Skippable. |
| 12 | **"Building your plan" + Level reveal** | R | REAL | The payoff that *sells* the personalization. Repurpose `PreparingScreen`: compute level, show "You're B1!", labor-illusion checklist while bundle copies to app-doc dir. |
| 13 | **Quick win** — 1 short lesson/question at placed level | N | REAL | First-session success = strongest D1-retention lever. Reuse `buildQnaList`. |
| 14 | **Soft auth** (sign up to save progress) | R | REAL | Move `onboarding_screen.dart` auth to HERE, after payoff. Social login. |
| 15 | Notification opt-in (practice time) | E | REAL | Existing `preferredPracticeTime` → `scheduleDailyReminder` (`onboarding_controller.dart:99`). Ask with a reason. |
| 16 | Home (landing tab = area chosen in #7) | — | REAL | |

**Language: Hindi-only.** Steps 2 & 3 are cut — `motherTongue` and app language are hardcoded to Hindi, no selection screens. QnA uses the existing **Hindi pack** (`hi.zip`) via the current download flow — no bundling, no change to the download path for v1. This also drops one setup screen from the funnel — good for drop-off.

**Minimal viable subset** (if trimming for v1): #4 (self-report) → #10 (word-pills) → #12 (reveal) → #14 (auth). Everything else is conversion/personalization polish that can land incrementally.

---

## Word-pills placement — design & scoring

**3 screens**, one CEFR band-group each (matches Learna). Pull real words from bundled `assets/vocabulary_builder/content/<LEVEL>/**` + inject 2 pseudowords per screen as an over-claim control.

- Screen A — **A1-A2**: e.g. eat, water, house, happy, friend, morning, walk, book, family, dog… + fakes
- Screen B — **B1-B2**: e.g. challenge, concentrate, responsibility, ambition, maintain, perception, decrease, honesty… + fakes
- Screen C — **C1-C2**: e.g. ambiguity, meticulous, resilience, articulate, introspection, credibility, cultivate… + fakes
- Pseudowords (plausible non-words): mophrent, glorptic, tranomize, quastic, fendible

**Framing:** "Tap the words you know — no wrong answers, this personalizes your lessons." Skip = "I'm a total beginner" → A1.

**Scoring → CEFR:**
```
for each band group: rate[band] = known / shown
penalty = fraction of PSEUDOWORDS tapped as known   // 0..1

level = A1
if (rateA1A2 - penalty) >= 0.6: level = A2
if above AND (rateB1B2 - penalty) >= 0.6: level = B2   // (or B1 if only partial)
if above AND (rateC1C2 - penalty) >= 0.6: level = C2   // (or C1 if only partial)

// cross-check with self-report (#4): if objective is >1 band above self-report
// AND confidence == "Not confident", nudge down one band.

currentEnglishLevelProgress = 0   // or round(rate[level]*10) for a small head-start
```
Level = highest band consistently known, with everything below known. Fail early → A1. The bundled QnA engine then self-corrects via lesson accuracy / unlock tests.

**Curate once:** build a small `assets/placement/word_bank.json` (sampled from the vocab bank + pseudowords) rather than runtime-scanning hundreds of topic files.

---

## Code integration points

- **Insert placement + reveal:** in `_completeOnboarding()` (`onboarding_controller.dart:~177`), replace the direct `Get.offAll(PreparingScreen)` with the placement screens → reveal → then home.
- **Set level:** mutate `globalController.userProfile.value.currentEnglishLevel` / `.currentEnglishLevelProgress`, call `globalController.updateProfile()` (writes SharedPreferences + Firestore, `global_controller.dart:146`). Overrides hard-coded `'A1'` at `onboarding_controller.dart:311`.
- **QnA download unchanged:** keep the existing `PreparingScreen` → `hi.zip` download (`AppData.appLanguagesMap`, `app_data.dart:1226`). Just fold the level reveal + checklist into `PreparingScreen` so the real download backs the reveal. Bundling into `assets/lessons/` + first-launch copy is a later optimization, not v1.
- **New screens are custom UI** (selectable chips for pills, radio lists for statements) — not the existing simple-option question widget; the interactions differ.
- **Word data:** `EnglishVocabLevelModel` + `TopicWordContent`/`VocabWord` in `lib/Models/vocabulary_word_model.dart`.
- **Reuse for quick-win:** `buildQnaList` (`question_options_controller.dart:433`).

## What to copy vs skip from Learna

**Copy:** 3-band word-pills · pain-point statements (trim to 3) · area-to-improve → landing tab · "AI building your plan" labor-illusion screen · deferred auth · persistent progress bar + back.
**Skip / fix:** age gate (cut unless ad-driven) · 7 statements (too many) · **their lack of an objective result — we set & reveal the level, that's our edge.**

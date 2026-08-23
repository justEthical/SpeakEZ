# SpeakEZ — Product Critique & Improvement Plan

_Date: 2026-07-05_

Critical assessment of SpeakEZ as an English-learning app, benchmarked against Stimuler, Speak (Supernova), and Learna.

---

## The core problem

The app is marketed as "practice English and **improve**," but improvement requires a loop:
**measure → target weak spots → practice → re-measure.** The app currently has none of that loop.
It has three good activities sitting in three separate silos.

- **Everyone starts at A1.** No placement test (`onboarding_controller.dart:311` hard-codes `currentEnglishLevel: 'A1'`). A fluent B2 user gets beginner treatment — the biggest credibility gap vs competitors.
- **Nothing adapts.** No feature reads performance to adjust difficulty or re-surface weak words. Vocabulary isn't spaced repetition — a topic is "done" the moment it's touched; mistakes never return.
- **Three parallel progress systems.** Lessons drive level; vocab has its own unlock logic and progress store; conversation ignores level entirely. Feels like three mini-apps, not one journey.

## Feature map (current state)

### 1. Conversation Practice — semi-guided
- Scenario-based AI role-play (10 categories, CEFR-tagged), voice-based, 15-turn cap, per-session AI feedback (fluency/grammar/vocab/pronunciation). "Free Talk" scenario is the one open mode.
- Costs 100 gems/session. Scenario level is **informational only** (not gated).
- **Gaps:** AI prompt never receives the user's CEFR level → no difficulty scaling. Per-session feedback is **discarded** — not persisted, not fed into progression.

### 2. Vocabulary — static pronunciation bank
- Level (A1–C2) → Category → Topic → words. Static bundled JSON. User pronounces words; scored and saved.
- **Gaps:** Not SRS, not adaptive. `isTopicCompleted` just checks a key exists. Missed/incorrect words never re-surface. Level unlock ignores the user's assessed level.

### 3. QnA / Duolingo-type Lessons — the strongest feature
- Strict CEFR path A1→C2, sequential lesson unlock, 50-lessons-per-level auto-advance, Level Unlock Tests (≥80% to jump). 5 skill types, 6 question types, gems by accuracy, streaks.
- This is genuinely **better structured** than most competitors ship. It's the app's strength.

### Cross-cutting gaps
- **No placement/assessment** — every user hard-coded to A1. Onboarding self-report answers (confidence etc.) are stored but unused.
- **No adaptivity / SRS / personalization** anywhere.
- **Siloed features** — shared only by profile counters (gems, streak, level); no feature reads another's performance.

## Grades vs competition

| | SpeakEZ | Stimuler | Speak (Supernova) | Learna |
|---|---|---|---|---|
| Placement/assessment | ❌ none | ✅ | ✅ | ✅ |
| QnA/lessons (guided) | ✅ genuinely strong | weaker | course-based | weaker |
| Conversation AI | ⚠️ AI never gets user level | ✅ strong error analysis | ✅✅ best-in-class | ✅ |
| Vocab | ⚠️ static, no SRS | tied to errors | in-context | in-context |
| Adaptivity | ❌ | ✅ (whole pitch) | ✅ | ✅ |
| Error feedback depth | ⚠️ scored then discarded | ✅✅ (its moat) | ✅ | ✅ |

**Competitive strength:** QnA/lessons structure.
**Where it loses:** Stimuler's identity is "we find your exact mistakes and fix them"; Speak's is "most natural AI conversation." SpeakEZ does neither deeply — conversation feedback is computed then thrown away.

## Honest score
**6/10 as a "practice" app, 3/10 as an "improve" app.** The activities and content exist; the intelligence layer that turns activity into measurable improvement is missing — and that layer _is_ the product in 2026's market.

## What to do — priority order

1. **Add a placement test (highest ROI, smallest effort).** Reuse the existing QnA/unlock-test engine — leveled question pools already exist. Run a 10–15 question adaptive quiz at onboarding and set `currentEnglishLevel` from the result instead of hard-coding A1.
2. **Pass the user's CEFR level into the conversation AI prompt.** One line of system-prompt context. Trivial fix, big perceived-quality jump.
3. **Stop discarding conversation feedback.** Persist the per-session fluency/grammar/vocab/pronunciation scores, show a trend, drive a "practice this" nudge. Path to a Stimuler-style hook without a rebuild.
4. **Make vocab a real SRS.** Per-word perfect/incorrect/skipped is already stored — re-surface missed words on a schedule.
5. **Connect the silos with one "next step."** Home should say _"You struggled with past tense in conversation → try this lesson / these words."_ Makes it feel like a coach, not a toolbox.

**On guided vs freeform:** the current guided/free mix across the three features is fine. The real issue was never "should conversation be guided" — it's that **nothing is personalized to the learner.** Guided or free, a B2 user getting A1 treatment churns.

**Start with #1 and #2** — days of work, reuse existing code, directly attack the "improve" credibility gap.

# English Learning App – Business Model Summary (India-Focused)
*As of December 2025*

## Core Features
1. **Live-style Lessons** (similar to Duolingo)
   - Users complete lessons and earn gems based on accuracy
   - Perfect score (100%) → 100 gems
   - Lower accuracy → proportionally fewer gems
2. **AI Speaking Practice Sessions**
   - Cost: **100 gems per session**
   - Duration: max **7.5 minutes**
   - One interstitial ad shown **after every speaking session**
   - If user has <100 gems → can watch a **rewarded video** to instantly get **100 gems**

## Gem Economy
- New users start with **500 free gems** (enough for 5 free speaking sessions)
- Gems earned only through lesson performance
- Main monetization gate: speaking sessions require 100 gems

## Technical Costs per Speaking Session
| Component                  | Usage / Rate                            | Cost (USD)    |
|---------------------------|-----------------------------------------|---------------|
| LLM Tokens                | ~5,000 tokens (≈4k input, 1k output)    | $0.00026      |
|                           | Input: $0.03 / million                  |               |
|                           | Output: $0.14 / million                 |               |
| Speech-to-Text (STT)      | Max 7.5 minutes                         | $0.0015       |
|                           | Rate: $0.0002 per minute                |               |
| **Total cost per session**|                                         | **≈ $0.00176**|

## Ad Revenue (India 2025 Real Numbers)
| Ad Type                   | Average eCPM (India) | Revenue per View (USD) |
|---------------------------|----------------------|-------------------------|
| Interstitial (after session) | ~$2.3              | ~$0.0023               |
| Rewarded Video (for 100 gems) | $12 – $14 (can reach $15–20 with mediation) | $0.012 – $0.014+ |

## Per-Session Profit Scenarios
| User Path                                      | Total Revenue | Cost     | Net Profit     |
|------------------------------------------------|---------------|----------|----------------|
| Normal session (using earned/free gems)        | $0.0023       | $0.00176 | +$0.00054      |
| Rewarded video → 100 gems → session + interstitial | $0.0143 – $0.0163 | $0.00176 | **+$0.0125 – $0.0145** |

**Rewarded video path is ~8–10× more profitable** → Indian users love this loop.

## Target Market
- 95%+ users from **India**
- Extremely high tolerance and preference for rewarded video ads when reward = real value (free AI speaking practice)

## Projected Monthly Profit Examples
| MAU       | Sessions/User/Month | Rewarded Views Ratio | Monthly Gross Profit (USD) |
|-----------|---------------------|----------------------|-----------------------------|
| 50,000    | 15                  | 60%                  | ~$6,300                     |
| 100,000   | 25                  | 70%                  | ~$24,100                    |
| 250,000   | 40                  | 80%                  | ~$109,000+                  |

Even at 50k MAU → **₹5+ lakh/month profit** with near-zero marginal cost.

## Key Advantages
- Total cost per session ≈ **₹0.15**
- Revenue per rewarded cycle ≈ **₹1.25**
- Profit margin on rewarded sessions: **88–90%**
- Users self-fund unlimited sessions via rewarded ads
- No dependency on IAP (perfect for Indian market)

## Recommended Optimizations (Already Winning, But Can 2x Revenue)
1. Slightly reduce max gems from lessons (70–80 instead of 100)
2. Add daily/weekly rewarded offers (e.g., “Watch → 150 gems”)
3. Add streak bonus via rewarded video
4. Use top mediation (AppLovin MAX / IronSource / AdMob mediation) → push rewarded eCPM to $15–20

**Conclusion**: This is one of the strongest ad-monetized English learning app models possible for the Indian market in 2025. The rewarded-video-to-gems gate turns churn into high-paying ad views. Scale fast — the economics are heavily in your favor.
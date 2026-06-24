# SpeakEZ DeepInfra Proxy (Cloudflare Worker)

Hides `DEEP_INFRA_API_KEY` from the app bundle. The Flutter app calls this Worker
with a Firebase App Check token; the Worker verifies the token and forwards the
request to DeepInfra with the secret key injected server-side.

Allowlisted upstream paths only:

- `POST /v1/openai/chat/completions`
- `POST /v1/inference/openai/whisper-large-v3-turbo`

## Deploy

```bash
cd cloudflare
npm install

# Set the DeepInfra key as an encrypted secret (NOT in wrangler.toml)
npx wrangler secret put DEEP_INFRA_API_KEY

# Deploy
npx wrangler deploy
```

Wrangler prints the Worker URL, e.g. `https://speakez-proxy.<account>.workers.dev`.
Put that in the app's `.env` as `PROXY_BASE_URL` (no trailing slash).

## Firebase App Check setup (one-time, in Firebase console)

1. Firebase console → **App Check** → register the iOS app (App Attest) and the
   Android app (Play Integrity).
2. Enforcement is verified by this Worker against the App Check JWKS — you do NOT
   need to enable App Check enforcement on any Firebase backend product for this.
3. For local development, register a **debug token** (the app prints one on launch
   when built in debug mode) under each app's App Check settings.

## How verification works

The Worker validates the App Check JWT against:

- issuer `https://firebaseappcheck.googleapis.com/890810544590`
- audience `projects/890810544590`

(project number `890810544590`, project id `speakez-ai`). Update
`FIREBASE_PROJECT_NUMBER` in `wrangler.toml` if the project changes.

## Local test

```bash
echo 'DEEP_INFRA_API_KEY = "sk-..."' > .dev.vars
npx wrangler dev
```

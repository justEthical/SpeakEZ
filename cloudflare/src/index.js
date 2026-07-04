import { createRemoteJWKSet, jwtVerify } from 'jose';

// Firebase App Check public keys. jose caches and refreshes these automatically.
const JWKS = createRemoteJWKSet(
  new URL('https://firebaseappcheck.googleapis.com/v1/jwks'),
);

// Only these upstream paths may be proxied — keep this a narrow allowlist so the
// Worker can never be turned into an open relay to arbitrary DeepInfra endpoints.
const ALLOWED_PATHS = new Set([
  '/v1/openai/chat/completions',
  '/v1/inference/openai/whisper-large-v3-turbo',
]);

// Constant-time string compare so the dev-secret check can't be timing-attacked.
function timingSafeEqual(a, b) {
  const enc = new TextEncoder();
  const ab = enc.encode(a);
  const bb = enc.encode(b);
  if (ab.length !== bb.length) return false;
  let diff = 0;
  for (let i = 0; i < ab.length; i++) diff |= ab[i] ^ bb[i];
  return diff === 0;
}

export default {
  async fetch(request, env) {
    if (request.method !== 'POST') {
      return new Response('Method Not Allowed', { status: 405 });
    }

    const url = new URL(request.url);
    if (!ALLOWED_PATHS.has(url.pathname)) {
      return new Response('Not Found', { status: 404 });
    }

    // 1. Authenticate the request. Debug builds present a shared dev secret so
    //    developers don't have to register a fresh App Check debug token on
    //    every reinstall; everything else must pass real App Check attestation.
    const devSecret = request.headers.get('X-Dev-Secret');
    const isDevBypass =
      env.DEV_BYPASS_SECRET &&
      devSecret &&
      timingSafeEqual(devSecret, env.DEV_BYPASS_SECRET);

    if (!isDevBypass) {
      // Gate on a valid Firebase App Check token so only our app can spend credits.
      const appCheckToken = request.headers.get('X-Firebase-AppCheck');
      if (!appCheckToken) {
        return new Response('Missing App Check token', { status: 401 });
      }
      try {
        await jwtVerify(appCheckToken, JWKS, {
          issuer: `https://firebaseappcheck.googleapis.com/${env.FIREBASE_PROJECT_NUMBER}`,
          audience: `projects/${env.FIREBASE_PROJECT_NUMBER}`,
        });
      } catch (_) {
        return new Response('Invalid App Check token', { status: 401 });
      }
    }

    // 2. Forward to DeepInfra with the secret key injected server-side.
    const headers = new Headers(request.headers);
    headers.set('Authorization', `Bearer ${env.DEEP_INFRA_API_KEY}`);
    headers.delete('X-Firebase-AppCheck');
    headers.delete('X-Dev-Secret');
    headers.delete('Host');

    const upstream = await fetch(env.DEEPINFRA_BASE + url.pathname + url.search, {
      method: 'POST',
      headers,
      body: request.body,
    });

    return new Response(upstream.body, {
      status: upstream.status,
      headers: upstream.headers,
    });
  },
};

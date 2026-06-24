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

export default {
  async fetch(request, env) {
    if (request.method !== 'POST') {
      return new Response('Method Not Allowed', { status: 405 });
    }

    const url = new URL(request.url);
    if (!ALLOWED_PATHS.has(url.pathname)) {
      return new Response('Not Found', { status: 404 });
    }

    // 1. Gate on a valid Firebase App Check token so only our app can spend credits.
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

    // 2. Forward to DeepInfra with the secret key injected server-side.
    const headers = new Headers(request.headers);
    headers.set('Authorization', `Bearer ${env.DEEP_INFRA_API_KEY}`);
    headers.delete('X-Firebase-AppCheck');
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

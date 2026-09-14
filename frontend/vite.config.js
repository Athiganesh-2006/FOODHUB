import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    // Bind the IPv4 loopback explicitly. Vite's default host is 'localhost',
    // which Node 17+ resolves to the IPv6 ::1 ONLY — so a browser that reaches
    // for 127.0.0.1 gets ECONNREFUSED ("localhost refused to connect") even
    // though the dev server is running. Use '::' here instead if you also want
    // the dev server reachable from other machines on the LAN.
    host: '127.0.0.1',
    // The backend CORS allowlist names 5173/5174/3000, and 5173 is the port to
    // open in the browser. strictPort makes a busy 5173 a hard error instead of
    // silently sliding to 5174/5175 — that fallback is what leaves orphaned dev
    // servers behind and the URL you have open out of sync with the one Vite
    // just printed.
    port: 5173,
    strictPort: true,
    proxy: {
      // Dev only: /api/** is forwarded to the Spring Boot backend, so no
      // cross-origin request (and no CORS preflight) is ever made.
      // 127.0.0.1 rather than localhost, for the same IPv4/IPv6 reason above.
      '/api': {
        target: 'http://127.0.0.1:8081',
        changeOrigin: false,
      },
    },
  },
})

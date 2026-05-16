import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'

// 502 多为代理连不上后端：请先启动 Spring Boot，并确认端口与 target 一致。
// 可在项目根目录建 .env.development，写一行：VITE_API_PROXY=http://127.0.0.1:你的端口
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  const target = env.VITE_API_PROXY || 'http://127.0.0.1:8791'

  return {
    plugins: [vue()],
    server: {
      port: 5173,
      proxy: {
        '/api': {
          target,
          changeOrigin: true,
        },
      },
    },
  }
})

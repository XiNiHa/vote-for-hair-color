import path from 'path'
import { defineConfig } from 'vite'
import reactRefresh from '@vitejs/plugin-react-refresh'
import reactSvg from 'vite-plugin-react-svg'
import WindiCSS from 'vite-plugin-windicss'

// https://vitejs.dev/config/
export default defineConfig({
  resolve: {
    alias: {
      "@": path.resolve(__dirname, 'src')
    }
  },
  plugins: [
    reactRefresh(),
    reactSvg({
      expandProps: 'start',
      svgProps: {
        width: '{props.width}',
        height: '{props.height}',
      }
    }),
    WindiCSS()
  ]
})

const pnpApi = require('./.pnp.cjs')
pnpApi.setup()

const plugin = require('windicss/plugin')

export default {
  theme: {
    extend: {
      fontFamily: {
        sans: ["Noto Sans CJK KR", "Noto Sans KR", "sans-serif"]
      },
      colors: {
        all: {
          3: '#333333',
          5: '#555555',
          7: '#777777',
          9: '#999999',
          E: '#EEEEEE',
        },
        myBlue: '#399BC5'
      },
      boxShadow: {
        DEFAULT: '0px 2px 2px rgba(0, 0, 0, 0.25)'
      }
    }
  },
  plugins: [
    plugin(({ addUtilities }) => {
      addUtilities({
        '.keep-words': {
          wordBreak: 'keep-all'
        }
      })
    })
  ]
}

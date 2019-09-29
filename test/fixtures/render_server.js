require('@babel/polyfill')
require('@babel/register')({
  presets: [
    [require.resolve("@babel/preset-env")],
    [require.resolve("@babel/preset-react")]
  ],
  plugins: [
    require.resolve("@babel/plugin-syntax-dynamic-import"),
    require.resolve("@babel/plugin-syntax-import-meta"),
    require.resolve("@babel/plugin-proposal-class-properties"),
    require.resolve("@babel/plugin-proposal-json-strings")
  ]
})

module.exports = require('../../priv/server.js')

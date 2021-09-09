const path = require('path');

module.exports = {
  mode: 'production',
  entry: './src/Index.bs.js',
  target: 'node16',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
    libraryTarget: 'commonjs',
  }
}

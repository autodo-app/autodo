module.exports = {
  entry: './src/app.tsx',
  output: {
    path: __dirname + '/public',
    filename: 'build/app.js',
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js'],
  },
  module: {
    rules: [{ test: /\.tsx?$/, loader: 'ts-loader' }],
  },
  devServer: {
    host: '0.0.0.0',
    port: 8080,
    historyApiFallback: true,
  },
};

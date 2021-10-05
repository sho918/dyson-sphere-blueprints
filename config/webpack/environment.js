const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')

const webpack = require('webpack');
const CopyPlugin = require("copy-webpack-plugin");
const path = require('path');

// Preventing Babel from transpiling NodeModules packages
environment.loaders.delete('nodeModules');
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    Popper: ['popper.js', 'default']
  })
);

environment.plugins.prepend('Copy',
  new CopyPlugin({
    patterns: [
      {
        from: 'node_modules/dsp-bp-parser/dist/*.wasm',
        to({ _context, absoluteFilename }) {
          return `js/${path.parse(absoluteFilename).base}`;
        }
      },
    ],
  })
);

environment.loaders.prepend('erb', erb)
module.exports = environment

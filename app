#!/usr/bin/node

var Promise = require('bluebird');
var config = require('./knexfile')[process.env.NODE_ENV || 'production'];
var knex = require('knex')(config);
var stdin = process.stdin;

function readStdin() {
  var payload = [];
  var length = 0;

  return new Promise(function(resolve, reject) {
    function resolveWithPayload() {
      return resolve(Buffer.concat(payload, length));
    }

    function collectChunks() {
      var chunk;

      while (chunk = stdin.read()) {
        payload.push(chunk);
        length += chunk.length;
      }
    }

    if (stdin.isTTY) {
      return resolveWithPayload();
    }

    stdin.on('readable', collectChunks);
    stdin.on('end', resolveWithPayload);
    stdin.on('error', reject);
  });
}

function store(payload) {
  payload || (payload = new Buffer(''));
  var now = new Date();
  var data = {
    to: process.env.USER,
    context: process.env.MODULE,
    content_type: process.env.CONTENT_TYPE,
    payload: payload,
    created_at: now,
    updated_at: now,
  };

  data.context == null && delete data.context;
  data.content_type == null && delete data.content_type;

  if (data.to) {
    return knex('messages').insert(data);
  }
}

function cleanup() {
  knex.destroy();
}

function errorHandler(err) {
  process.exitCode = 1;
  process.stderr.write(err.toString());
}

readStdin().then(store).catch(errorHandler).finally(cleanup);

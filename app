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

function prepare() {
  return knex.migrate.latest(config).then(readStdin);
}

function store(payload) {
  payload || (payload = new Buffer(''));
  var data = {
    to: process.env.USER || '',
    context: process.env.MODULE || '',
    content_type: process.env.CONTENT_TYPE || '',
    payload: payload.toString('binary'),
  };

  return knex('messages').insert(data);
}

function quit() {
  process.exit(0);
  return null;
}

prepare().then(store).then(quit);

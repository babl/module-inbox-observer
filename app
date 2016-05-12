#!/usr/bin/node

var Promise = require('bluebird');
var config = require('./knexfile')[process.env.NODE_ENV || 'production'];
var knex = require('knex')(config);

function readStdin() {
  var payload = [], stdin = process.stdin;

  return new Promise(function(resolve, reject) {
    if (stdin.isTTY) {
      resolve(Buffer.concat(payload));
    } else {
      stdin.on('data', payload.push.bind(payload));
      stdin.on('close', function() {
        resolve(Buffer.concat(payload));
      });
      stdin.on('error', reject);
    }
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

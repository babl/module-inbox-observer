exports.up = function(knex, Promise) {
  return knex.schema.createTable('messages', function (table) {
    table.increments();
    table.string('to').notNullable().index();
    table.string('context').index();
    table.string('content_type');
    table.binary('payload');
    table.timestamps(true, true);
  })
};

exports.down = function(knex, Promise) {
  return knex.schema.dropTable('messages');
};

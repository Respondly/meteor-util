Package.describe({
  summary: 'Common utility helpers.'
});

Npm.depends({
  'colors': '0.6.0-1'
});


Package.on_use(function (api) {
  api.use(['coffeescript', 'sugar']);
  api.export('Util');
  api.export('ReactiveHash');
  api.export('Handlers');
  api.export('ScopedSession');
  api.export('LocalStorage');
  api.export('ClientSettings');

  // Generated with: github.com/philcockfield/meteor-package-paths
  api.add_files('shared/_export.coffee', ['client', 'server']);
  api.add_files('shared/client-settings.shared.coffee', ['client', 'server']);
  api.add_files('shared/compound-values.coffee', ['client', 'server']);
  api.add_files('shared/handlers.coffee', ['client', 'server']);
  api.add_files('shared/reactive-hash.coffee', ['client', 'server']);
  api.add_files('shared/timer.coffee', ['client', 'server']);
  api.add_files('shared/util.coffee', ['client', 'server']);
  api.add_files('server/client-settings.server.coffee', 'server');
  api.add_files('server/main.coffee', 'server');
  api.add_files('client/events.coffee', 'client');
  api.add_files('client/local-storage.coffee', 'client');
  api.add_files('client/scoped-session.coffee', 'client');

});



Package.on_test(function (api) {
  api.use(['munit', 'coffeescript']);
  api.use('util');

  // Generated with: github.com/philcockfield/meteor-package-paths
  api.add_files('tests/shared/_init.coffee', ['client', 'server']);
  api.add_files('tests/shared/compound-values.coffee', ['client', 'server']);
  api.add_files('tests/shared/handlers.coffee', ['client', 'server']);
  api.add_files('tests/shared/reactive-hash.coffee', ['client', 'server']);
  api.add_files('tests/shared/timer.coffee', ['client', 'server']);
  api.add_files('tests/shared/util.coffee', ['client', 'server']);
  api.add_files('tests/server/client-settings.coffee', 'server');
  api.add_files('tests/client/local-storage-test.coffee', 'client');
  api.add_files('tests/client/scoped-session-test.coffee', 'client');

});


Package.describe({
  summary: 'Common utility helpers.'
});



Package.on_use(function (api) {
  api.use(['coffeescript', 'sugar']);
  api.export('Util');

  // Generated with: github.com/philcockfield/meteor-package-loader
  api.add_files('shared/_export.coffee', ['client', 'server']);
  api.add_files('shared/handlers.coffee', ['client', 'server']);
  api.add_files('shared/reactive-hash.coffee', ['client', 'server']);
  api.add_files('shared/timer.coffee', ['client', 'server']);
  api.add_files('shared/util.coffee', ['client', 'server']);

});



Package.on_test(function (api) {
  api.use(['munit', 'coffeescript']);
  api.use('util');

  // Generated with: github.com/philcockfield/meteor-package-loader
  api.add_files('tests/shared/_init.coffee', ['client', 'server']);

  // api.add_files('tests/shared/handlers-test.coffee', ['client', 'server']);
  api.add_files('tests/shared/reactive-hash-test.coffee', ['client', 'server']);
  // api.add_files('tests/shared/timer-test.coffee', ['client', 'server']);
  // api.add_files('tests/shared/util-test.coffee', ['client', 'server']);

});


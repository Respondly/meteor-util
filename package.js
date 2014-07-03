Package.describe({
  summary: 'Common utility helpers.'
});



Package.on_use(function (api) {
  api.use(['coffeescript', 'sugar']);
  api.export('Util');

  // Generated with: github.com/philcockfield/meteor-package-loader
  api.add_files('shared/exports.coffee', ['client', 'server']);
  api.add_files('shared/handlers.coffee', ['client', 'server']);
  api.add_files('shared/timer.coffee', ['client', 'server']);

});



Package.on_test(function (api) {
  api.use(['munit', 'coffeescript']);
  api.use('util');

  // Generated with: github.com/philcockfield/meteor-package-loader
  api.add_files('tests/shared/handlers-test.coffee', ['client', 'server']);
  api.add_files('tests/shared/init.coffee', ['client', 'server']);
  api.add_files('tests/shared/timer-test.coffee', ['client', 'server']);

});


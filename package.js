Package.describe({
  summary: 'Common utility helpers.'
});


Npm.depends({
  'colors': '0.6.0-1'
});


Package.on_use(function (api) {
  api.use(['coffeescript']);
  api.export('Util');
  api.export('ReactiveHash');
  api.export('ReactiveArray');
  api.export('Handlers');
  api.export('ScopedSession');
  api.export('LocalStorage');
  api.export('ClientSettings');
  api.export('AutoRun');
  api.export('ControllerBase');
  api.export('UserAgent');
  api.export('KeyboardController');
  api.export('Const');
  api.export('PageJS');
  api.export('QueryString');
  api.export('Url');
  api.export('Server');

  // Generated with: github.com/philcockfield/meteor-package-paths
  api.add_files('shared/util.coffee', ['client', 'server']);
  api.add_files('shared/ns.coffee', ['client', 'server']);
  api.add_files('shared/classes/auto-run.coffee', ['client', 'server']);
  api.add_files('shared/classes/handlers.coffee', ['client', 'server']);
  api.add_files('shared/classes/page-js.js', ['client', 'server']);
  api.add_files('shared/classes/query-string.coffee', ['client', 'server']);
  api.add_files('shared/classes/reactive-array.coffee', ['client', 'server']);
  api.add_files('shared/classes/reactive-hash.coffee', ['client', 'server']);
  api.add_files('shared/classes/url.coffee', ['client', 'server']);
  api.add_files('shared/const/const.coffee', ['client', 'server']);
  api.add_files('shared/const/const-keys.coffee', ['client', 'server']);
  api.add_files('shared/libs/sugar.js', ['client', 'server']);
  api.add_files('shared/client-settings.shared.coffee', ['client', 'server']);
  api.add_files('shared/compound-values.coffee', ['client', 'server']);
  api.add_files('shared/const.coffee', ['client', 'server']);
  api.add_files('shared/conversion.coffee', ['client', 'server']);
  api.add_files('shared/position.coffee', ['client', 'server']);
  api.add_files('shared/timer.coffee', ['client', 'server']);
  api.add_files('shared/user-agent.coffee', ['client', 'server']);
  api.add_files('server/client-settings.server.coffee', 'server');
  api.add_files('server/db.coffee', 'server');
  api.add_files('server/npm.coffee', 'server');
  api.add_files('server/server.coffee', 'server');
  api.add_files('server/util.coffee', 'server');
  api.add_files('client/dom/css.coffee', 'client');
  api.add_files('client/classes/controller-base.coffee', 'client');
  api.add_files('client/classes/keyboard-controller.coffee', 'client');
  api.add_files('client/classes/scoped-session.coffee', 'client');
  api.add_files('client/classes/user-agent.coffee', 'client');
  api.add_files('client/dom/browser.coffee', 'client');
  api.add_files('client/dom/height-animator.coffee', 'client');
  api.add_files('client/dom/jquery-caret.js', 'client');
  api.add_files('client/dom/jquery.3rd-party.coffee', 'client');
  api.add_files('client/dom/jquery.coffee', 'client');
  api.add_files('client/dom/pulse.coffee', 'client');
  api.add_files('client/dom/style.coffee', 'client');
  api.add_files('client/db.coffee', 'client');
  api.add_files('client/draggable.coffee', 'client');
  api.add_files('client/events.coffee', 'client');
  api.add_files('client/keyboard-controller.coffee', 'client');
  api.add_files('client/keyboard.coffee', 'client');
  api.add_files('client/keys.coffee', 'client');
  api.add_files('client/local-storage.coffee', 'client');

});



Package.on_test(function (api) {
  api.use(['munit', 'coffeescript']);
  api.use('util');

  // Generated with: github.com/philcockfield/meteor-package-paths
  api.add_files('tests/shared/_init.coffee', ['client', 'server']);
  api.add_files('tests/shared/auto-run.coffee', ['client', 'server']);
  api.add_files('tests/shared/compound-values.coffee', ['client', 'server']);
  api.add_files('tests/shared/conversion.coffee', ['client', 'server']);
  api.add_files('tests/shared/handlers.coffee', ['client', 'server']);
  api.add_files('tests/shared/ns.coffee', ['client', 'server']);
  api.add_files('tests/shared/position.coffee', ['client', 'server']);
  api.add_files('tests/shared/reactive-array.coffee', ['client', 'server']);
  api.add_files('tests/shared/reactive-hash.coffee', ['client', 'server']);
  api.add_files('tests/shared/timer.coffee', ['client', 'server']);
  api.add_files('tests/shared/util.coffee', ['client', 'server']);
  api.add_files('tests/server/client-settings.coffee', 'server');
  api.add_files('tests/client/controller-base.coffee', 'client');
  api.add_files('tests/client/local-storage-test.coffee', 'client');
  api.add_files('tests/client/scoped-session-test.coffee', 'client');

});


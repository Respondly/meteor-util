Package.describe({
  name: 'respondly:util',
  summary: 'Common utility helpers.',
  version: '1.0.3',
  git: 'https://github.com/Respondly/meteor-util.git'
});



Npm.depends({
  'colors': '0.6.0-1'
});


Package.onUse(function (api) {
  // api.versionsFrom('1.0');
  api.use([
    'coffeescript@1.0.10',
    'jquery@1.11.4',
    'tracker@1.0.9',
    'session@1.1.1'
  ]);
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
  api.export('Fonts');
  api.export('Stamps');
  // Exported namespaces - code in other packages.
  api.export('Collector');
  api.export('Service');

  // Generated with: github.com/philcockfield/meteor-package-paths
  api.addFiles('shared/ns.js', ['client', 'server']);
  api.addFiles('shared/helpers/util.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/ns.coffee', ['client', 'server']);
  api.addFiles('shared/classes/reactive-hash.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/app.coffee', ['client', 'server']);
  api.addFiles('shared/classes/auto-run.coffee', ['client', 'server']);
  api.addFiles('shared/classes/elapsed.coffee', ['client', 'server']);
  api.addFiles('shared/classes/handlers.coffee', ['client', 'server']);
  api.addFiles('shared/classes/page-js.js', ['client', 'server']);
  api.addFiles('shared/classes/query-string.coffee', ['client', 'server']);
  api.addFiles('shared/classes/reactive-array.coffee', ['client', 'server']);
  api.addFiles('shared/classes/url.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/client-settings.shared.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/compound-values.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/conversion.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/date.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/email.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/html.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/path.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/position.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/string.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/timer.coffee', ['client', 'server']);
  api.addFiles('shared/helpers/user-agent.coffee', ['client', 'server']);
  api.addFiles('shared/libs/stampit.js', ['client', 'server']);
  api.addFiles('shared/libs/sugar.js', ['client', 'server']);
  api.addFiles('shared/stamps/auto-run.coffee', ['client', 'server']);
  api.addFiles('shared/stamps/disposable.coffee', ['client', 'server']);
  api.addFiles('shared/stamps/events.coffee', ['client', 'server']);
  api.addFiles('shared/const.coffee', ['client', 'server']);
  api.addFiles('server/client-settings.server.coffee', 'server');
  api.addFiles('server/db.coffee', 'server');
  api.addFiles('server/fonts.coffee', 'server');
  api.addFiles('server/npm.coffee', 'server');
  api.addFiles('server/server.coffee', 'server');
  api.addFiles('server/server.publish.coffee', 'server');
  api.addFiles('client/dom/css.coffee', 'client');
  api.addFiles('client/classes/controller-base.coffee', 'client');
  api.addFiles('client/classes/draggable.coffee', 'client');
  api.addFiles('client/classes/events.coffee', 'client');
  api.addFiles('client/classes/keyboard-controller.coffee', 'client');
  api.addFiles('client/classes/keyboard.coffee', 'client');
  api.addFiles('client/classes/scoped-session.coffee', 'client');
  api.addFiles('client/classes/subscriptions.coffee', 'client');
  api.addFiles('client/classes/user-agent.coffee', 'client');
  api.addFiles('client/dom/browser.coffee', 'client');
  api.addFiles('client/dom/height-animator.coffee', 'client');
  api.addFiles('client/dom/jquery-caret.js', 'client');
  api.addFiles('client/dom/jquery.3rd-party.coffee', 'client');
  api.addFiles('client/dom/jquery.coffee', 'client');
  api.addFiles('client/dom/pulse.coffee', 'client');
  api.addFiles('client/dom/style.coffee', 'client');
  api.addFiles('client/helpers/db.coffee', 'client');
  api.addFiles('client/helpers/fonts.coffee', 'client');
  api.addFiles('client/helpers/keys.coffee', 'client');
  api.addFiles('client/helpers/local-storage.coffee', 'client');

});



Package.onTest(function (api) {
  api.use(['mike:mocha-package@0.5.7', 'coffeescript@1.0.10']);
  api.use('respondly:util@1.0.0');

  // Generated with: github.com/philcockfield/meteor-package-paths
  api.addFiles('tests/shared/_init.coffee', ['client', 'server']);
  api.addFiles('tests/shared/auto-run.coffee', ['client', 'server']);
  api.addFiles('tests/shared/compound-values.coffee', ['client', 'server']);
  api.addFiles('tests/shared/conversion.coffee', ['client', 'server']);
  api.addFiles('tests/shared/date.coffee', ['client', 'server']);
  api.addFiles('tests/shared/email.coffee', ['client', 'server']);
  api.addFiles('tests/shared/events.coffee', ['client', 'server']);
  api.addFiles('tests/shared/handlers.coffee', ['client', 'server']);
  api.addFiles('tests/shared/html.coffee', ['client', 'server']);
  api.addFiles('tests/shared/ns.coffee', ['client', 'server']);
  api.addFiles('tests/shared/path.coffee', ['client', 'server']);
  api.addFiles('tests/shared/position.coffee', ['client', 'server']);
  api.addFiles('tests/shared/reactive-array.coffee', ['client', 'server']);
  api.addFiles('tests/shared/string.coffee', ['client', 'server']);
  api.addFiles('tests/shared/timer.coffee', ['client', 'server']);
  api.addFiles('tests/shared/util.coffee', ['client', 'server']);
  api.addFiles('tests/server/client-settings.coffee', 'server');
  api.addFiles('tests/server/server.coffee', 'server');
  api.addFiles('tests/client/controller-base.coffee', 'client');
  api.addFiles('tests/client/local-storage-test.coffee', 'client');
  api.addFiles('tests/client/reactive-hash.coffee', 'client');
  api.addFiles('tests/client/scoped-session-test.coffee', 'client');

});

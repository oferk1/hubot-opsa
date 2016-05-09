//
// (function() {
//     var proxy;
//
//     proxy = require('proxy-agent');
//
//     module.exports = function(robot) {
//         robot.globalHttpOptions.httpAgent = proxy('http://web-proxy.bbn.hpecorp.net:8080', false);
//         return robot.globalHttpOptions.httpsAgent = proxy('http://web-proxy.bbn.hpecorp.net:8080', true);
//     };
//
// }).call(this);

//# sourceMappingURL=proxy.js.map


require('coffee-script/register');
//require('better-require')('coffeescript');
require('../node_modules/hubot/bin/hubot.js');

//node_modules/hubot/bin/hubot.js


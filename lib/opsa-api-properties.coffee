fs = require('fs');
configurationFile = './opsa-configuration.json';
String.prototype.replaceAll = (search, replacement) ->
  target = this;
  return target.replace(new RegExp(search, 'g'), replacement)

rawFile = fs.readFileSync(configurationFile, 'utf8')
module.exports = JSON.parse(rawFile)

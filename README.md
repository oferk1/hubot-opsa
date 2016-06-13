Hubot for OpsA
***************

A hubot implementation to interact with OpsA Rest Services

Deployment and Launching:
**********************
1. Login to slack and install Hubot bot plugin. Write down the slack token
2. Clone repository and run npm install.
3. Rename opsa-configuration-sample.json to opsa-configuration.json and fill credentials in it.
4. Run npm install
( on windows with proxy run the following in the terminal: npm config set http-proxy http://[proxy-name]:[port-number]
    same on https)

5. (optional - if you want to use jetbrains ide debugger) Configure jetbrains file watchers to create javascript files from coffeescript.
3. Run the following command in terminal, Substituting [port-number] and [slack-token] with desired port number and token from previous step.

ON LINUX
*********

Run the following command in terminal, Substituting [port-number] , [slack-token], [proxy-url:port] with desired port number and token from previous step.
HUBOT_SLACK_TOKEN=[slack-token] NODE_TLS_REJECT_UNAUTHORIZED=0 HTTP_PROXY=[proxy-url:port] PORT=[port-number]  PATH=node_modules/hubot/node_modules:/home/ofer/myhubot:node_modules/hubot:node_modules/hubot/bin:node_modules/:node_modules/.bin:node_modules/hubot/node_modules/.bin:./src:$PATH HUBOT_LOG_LEVEL=debug NODE_PATH=$NODE_PATH:./node_modules:./scripts:./src:./lib bin/hubot --adapter slack

ON WINDOWS
***********

Run the following commands in Power Shell, Substituting [port-number] , [slack-token],[proxy-url:port] with desired port number and token from previous step.

$env:HUBOT_SLACK_TOKEN = "[slack-token]"

$env:NODE_TLS_REJECT_UNAUTHORIZED = "0"

$env:PORT = "[port-number]"

$env:PATH = "node_modules/hubot/node_modules:node_modules/hubot:node_modules/hubot/bin:node_modules/:node_modules/.bin:node_modules/hubot/node_modules/.bin:./src:$PATH"

$env:NODE_PATH = "./node_modules:./scripts:./src:./lib:$NODE_PATH"

$env:HUBOT_LOG_LEVEL = "debug" (optional)

$env:HTTP_PROXY = "[proxy-url:port]"


npm install -g coffee-script/n

bin\hubot --adapter slack


Tips
*****


To auto - start the hubot script on reboot on centos, create a script file with above launch command named  start-opsa-hubot.sh adn add the following line to  /etc/rc.d/rc.local
 
runuser -l  [user-name] -c /path/to/start-opsa-hubot.sh

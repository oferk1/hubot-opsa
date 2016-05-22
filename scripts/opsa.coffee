
scan = (obj, level) ->
  k = undefined
  if typeof level == 'undefined'
    level = 0
  spaces = ''
  c = 0
  while c < level
    spaces += ' '
    c++
  if obj instanceof Object
    fields = ''
    lineNum = 1
    for k of obj
      `k = k`
      if obj.hasOwnProperty(k)
#recursive call to scan property\
        fields += spaces + '*' + k + ':*' + scan(obj[k], level + 1) + "\n"
  else
#not an Object so obj[k] here is a value
    return spaces + "`" + obj + '`\n'
  fields + '\n'

request = require('request')
require('request-debug')(request);
user = "opsa"
password = "opsa"
ongoing = false
port = "8080"
path = "opsa"
protocol = "http"
host = "16.60.188.94"
lastTime = Date.now()

getSessionId = (res, cookieIndex) ->
  cookie = res.headers["set-cookie"]
  if typeof cookie == 'undefined'
    return
  firstCookie = cookie[cookieIndex]
  jSessionId = firstCookie.split("=")[1].split(";")[0]

generateJar = (jSessionId, url) ->
  jar = request.jar()
  cookie = request.cookie('JSESSIONID=' + jSessionId)
  console.log "setting cookie: " + cookie
  jar.setCookie cookie, url, (error, cookie) ->
  return jar

createJar = (res, url, cookieIndex) ->
  if !cookieIndex
    cookieIndex = 0
  jSessionId = getSessionId(res, cookieIndex)
  if typeof jSessionId == 'undefined'
    return
  jar = generateJar(jSessionId, url)
  return jar

OpsaAPI = (xsrfToken, jSessionId) ->
  @xsrfToken = xsrfToken.slice 1, -1
  @jSessionId = jSessionId
  return

AnomaliesAPI = (xsrfToken, jSessionId, hostName, from, to) ->
  OpsaAPI.call this, xsrfToken, jSessionId
  @hostName = hostName
  @from = from
  @to = to
  return

OpsaAPI::invoke = (callback)->
  console.log 'invoking API' + @jSessionId
  @invoker(callback)
  return

AnomaliesAPI.prototype = Object.create(OpsaAPI.prototype)
AnomaliesAPI::constructor = AnomaliesAPI
getOpsaUri = ->
  protocol + "://" + host + ":" + port + "/" + path
AnomaliesAPI::invoker = (callback) ->
  ONE_HOUR = 60 * 60 * 1000;
  now = new Date().getTime()
  oneHourAgo = now - ONE_HOUR

  anomUrl = getOpsaUri() + "/rest/getQueryResult?aqlQuery=%5Banomalies%5BattributeQuery(%7Bopsa_collection_anomalies%7D,+%7B%7D,+%7Bi.anomaly_id%7D)%5D()%5D+&endTime=" + now + "&granularity=0&pageIndex=1&paramsMap=%7B%22$drill_dest%22:%22AnomalyInstance%22,%22$drill_label%22:%22opsa_collection_anomalies_description%22,%22$drill_value%22:%22opsa_collection_anomalies_anomaly_id%22,%22$limit%22:%22500%22,%22$interval%22:300,%22$offset%22:0,%22$N%22:5,%22$pctile%22:10,%22$timeoffset%22:0,%22$starttimeoffset%22:0,%22$endtimeoffset%22:0,%22$timeout%22:0,%22$drill_type%22:%22%22,%22$problemtime%22:1463653196351,%22$aggregate_playback_flag%22:null%7D&queryType=generic&startTime=" + oneHourAgo + "&timeZoneOffset=-180&timeout=10&visualType=table"
  anomJar = generateJar(@jSessionId, anomUrl)
  anomHeaders =
    'XSRFToken': @xsrfToken
  requestp(anomUrl, anomJar, 'POST', anomHeaders).then ((anomResponse) ->
    callback(anomResponse.body)
  )
  return

okToContinue = ->
  secondsSinceLastTime = (Date.now() - lastTime) / 1000
  if secondsSinceLastTime < 30 && ongoing
    return false
  else
    lastTime = Date.now();
    ongoing = true
    return true

loginOpsa = (userRes, loginCallback) ->
  if !okToContinue()
    return
  # '16.60.188.94:8080/opsa'
  opsaUri = getOpsaUri();
  seqUrl = getOpsaUri() + "/j_security_check"
  xsrfUrl = getOpsaUri() + "/rest/getXSRFToken"
  loginForm =
    j_username: user
    j_password: password

  invokeAPI = (res, apiSessionResponse) ->
    xsrfToken = res.body
    sessionId = getSessionId(apiSessionResponse, 0)
    loginCallback(xsrfToken, sessionId)

  requestp(opsaUri).then ((res) ->
    jar4SecurityRequest = createJar(res, seqUrl, 1)
    requestp(seqUrl, jar4SecurityRequest, 'POST', {}, loginForm).then ((res) ->
      requestp(opsaUri, jar4SecurityRequest).then ((apiSessionResponse) ->
        jar4XSRFRequest = createJar(apiSessionResponse, xsrfUrl)
        requestp(xsrfUrl, jar4XSRFRequest).then ((res) ->
          invokeAPI res, apiSessionResponse

        )
      )
    )
    return
  ), (err) ->
    ongoing = false
    console.error '%s; %s', err.message, getOpsaUri()
    console.log '%j', err.res.statusCode
    return
  userRes.reply 'Please wait'

requestp = (url, jar, method, headers, form) ->
  headers = headers or {}
  method = method or 'GET'
  jar = jar or {}
  form = form or {}
  new Promise((resolve, reject) ->
    reqData = {
      uri: url
      headers: headers
      method: method
    }
    if jar
      reqData.jar = jar
    if form
      reqData.form = form
    request reqData, (err, res, body) ->
      if err
        return reject(err)
      else if res.statusCode == 200 || res.statusCode == 302 || res.statusCode == 400
        resolve res, body
      else
        ongoing = false
        err = new Error('Unexpected status code: ' + res.statusCode)
        err.res = res
        return reject(err)
      resolve res, body
      return
    return
  )


getRequestedHost = (res) ->
  res.match[1].replace(/^https?\:\/\//i, "");
module.exports = (robot) ->
  robot.respond /display anomalies for host:?:\s*(.*)/i, (res) ->
    loginCallback = (xsrfToken, sessionId) ->
      anomaliesAPI = new AnomaliesAPI(xsrfToken, sessionId, 'host', 'from', 'to')
      apiCallback = (body) ->
        colNames = new Array()
        collections = JSON.parse(body)
        output = ""
        requestedHost = getRequestedHost(res)
        for collectionId of collections
          for resultObjectIdx of collections[collectionId]
            obj = collections[collectionId]
            for tableIdx of obj[resultObjectIdx].processedResult
              table = obj[resultObjectIdx].processedResult[tableIdx]
              for columnIdx of table.columnNames
                colNames.push table.columnNames[columnIdx].columnTitle
              for rowIdx of table.tableDataWithDrill
                row = table.tableDataWithDrill[rowIdx]
                rowStr = ""
                display = false;
                displayed = 0
                for colIdx of row
                  colName = colNames[colIdx]
                  colValue = row[colIdx].displayValue
                  if display == false && colName == "Entity" && (colValue == requestedHost || requestedHost == "*")
                    display = true
                    displayed++
                  rowStr += "*" + colName + ":* " + colValue + "\n"
                if (display)
                  output += rowStr
        if displayed == 0
          replyText = 'No data found for host: ' + getRequestedHost(res) + "\n"
        else
          replyText = 'Displaying Anomalies For Host: ' + getRequestedHost(res) + "\n" + output
        res.reply replyText
        ongoing = false
        return

      anomaliesAPI.invoke apiCallback
    loginOpsa(res, loginCallback)


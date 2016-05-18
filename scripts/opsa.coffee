# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

createMessage = (res) ->
    numHosts = res.match[1]
    opsa = JSON.stringify `{
        "oa_sysperf_global"
    :
        [
            {
                "processedResult": [
                    {
                        "resultType": "singlevalue",
                        "metricName": "AGGREGATE_AVG_oa_sysperf_global_cpu_util",
                        "metricLabel": "CPU Util &#x28;Aggregate avg&#x29;",
                        "metricUnit": "%",
                        "metricDescription": "CPU Util &#x28;Aggregate avg&#x29;",
                        "dimensionValues": [
                            "16.60.188.71"
                        ],
                        "displayDimensionValues": [
                            "16.60.188.71"
                        ],
                        "drillLabel": "host withkey \"16.60.188.71\"",
                        "drillPQL": "host withkey \"16.60.188.71\"",
                        "drillTimeFrame": null,
                        "metricValues": [
                            {
                                "metricValue": 41.6077777777778,
                                "computeType": "topn_aggregate_avg"
                            }
                        ]
                    },
                    {
                        "resultType": "singlevalue",
                        "metricName": "TOPN_AGGREGATE_AVG_oa_sysperf_global_cpu_util_10",
                        "metricLabel": "CPU Util &#x28;Aggregate avg&#x29; &#x28;Topn&#x29;",
                        "metricUnit": "",
                        "metricDescription": "CPU Util &#x28;Aggregate avg&#x29; &#x28;Topn&#x29;",
                        "dimensionValues": [
                            "16.60.188.71"
                        ],
                        "displayDimensionValues": [
                            "16.60.188.71"
                        ],
                        "drillLabel": "host withkey \"16.60.188.71\"",
                        "drillPQL": "host withkey \"16.60.188.71\"",
                        "drillTimeFrame": null,
                        "metricValues": [
                            {
                                "metricValue": 1.0,
                                "computeType": "topn_aggregate_avg_rank"
                            }
                        ]
                    },
                    {
                        "resultType": "singlevalue",
                        "metricName": "AGGREGATE_AVG_oa_sysperf_global_cpu_util",
                        "metricLabel": "CPU Util &#x28;Aggregate avg&#x29;",
                        "metricUnit": "%",
                        "metricDescription": "CPU Util &#x28;Aggregate avg&#x29;",
                        "dimensionValues": [
                            "opsa-aob2.hpswlabs.adapps.hp.com"
                        ],
                        "displayDimensionValues": [
                            "opsa-aob2.hpswlabs.adapps.hp.com"
                        ],
                        "drillLabel": "host withkey \"opsa-aob2.hpswlabs.adapps.hp.com\"",
                        "drillPQL": "host withkey \"opsa-aob2.hpswlabs.adapps.hp.com\"",
                        "drillTimeFrame": null,
                        "metricValues": [
                            {
                                "metricValue": 3.06888888888889,
                                "computeType": "topn_aggregate_avg"
                            }
                        ]
                    },
                    {
                        "resultType": "singlevalue",
                        "metricName": "TOPN_AGGREGATE_AVG_oa_sysperf_global_cpu_util_10",
                        "metricLabel": "CPU Util &#x28;Aggregate avg&#x29; &#x28;Topn&#x29;",
                        "metricUnit": "",
                        "metricDescription": "CPU Util &#x28;Aggregate avg&#x29; &#x28;Topn&#x29;",
                        "dimensionValues": [
                            "opsa-aob2.hpswlabs.adapps.hp.com"
                        ],
                        "displayDimensionValues": [
                            "opsa-aob2.hpswlabs.adapps.hp.com"
                        ],
                        "drillLabel": "host withkey \"opsa-aob2.hpswlabs.adapps.hp.com\"",
                        "drillPQL": "host withkey \"opsa-aob2.hpswlabs.adapps.hp.com\"",
                        "drillTimeFrame": null,
                        "metricValues": [
                            {
                                "metricValue": 2.0,
                                "computeType": "topn_aggregate_avg_rank"
                            }
                        ]
                    }
                ],
                "filterQueryResult": false,
                "metricLabels": [
                    "CPU Util &#x28;Aggregate avg&#x29; &#x28;Topn&#x29;",
                    "CPU Util &#x28;Aggregate avg&#x29; &#x28;&#x25;&#x29;"
                ],
                "outerCall": false,
                "partialResult": false,
                "aggregatePlayback": false,
                "metaResult": false
            }
        ]
    }
    `
    msgData = {
        text: "Latest changes"
        attachments: [
            {
                fallback: "Comparing 77777",
                title: "Comparing 88988888}"
                title_link: "89988898"
                text: "commits_summary"
                mrkdwn_in: ["text"]
            }
        ]
    }
    res.robot.emit 'slack.attachment',
        message: {
            "type": "message",
            "channel": "C2147483705",
            "user": "ofer",
            "text": "Hello world",
            "ts": "1355517523.000005"
            "envelope": "envelope"

        }
        content:
# see https://api.slack.com/docs/attachments
            text: "Alert Test"
            fallback: "Alert fallback"
            fields: [{
                title: "Alert Field 1"
                value: "Alert value 1"
            }]
        channel: "#opsa-channel" # optional, defaults to message.room
        username: "opsa" # optional, defaults to robot.name
        icon_url: "..." # optional
        icon_emoji: "..." # optional
#    res.robot.adapter.customMessage msgData
#    res.reply "Displaying top #{numHosts} hosts"+ opsa
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

# ---
# generated by js2coffee 2.2.0

# ---
# generated by js2coffee 2.2.0

# ---
# generated by js2coffee 2.2.0
# ---
# generated by js2coffee 2.2.0
# ---
# generated by js2coffee 2.2.0
displayHosts = (res) ->
    numHosts = res.match[1]
    opsa = JSON.stringify `{
        "oa_sysperf_global"
    :
        [
            {
                "processedResult": [
                    {
                        "resultType": "singlevalue",
                        "metricName": "AGGREGATE_AVG_oa_sysperf_global_cpu_util",
                        "metricLabel": "CPU Util &#x28;Aggregate avg&#x29;",
                        "metricUnit": "%",
                        "metricDescription": "CPU Util &#x28;Aggregate avg&#x29;",
                        "dimensionValues": [
                            "16.60.188.71"
                        ],
                        "displayDimensionValues": [
                            "16.60.188.71"
                        ],
                        "drillLabel": "host withkey \"16.60.188.71\"",
                        "drillPQL": "host withkey \"16.60.188.71\"",
                        "drillTimeFrame": null,
                        "metricValues": [
                            {
                                "metricValue": 41.6077777777778,
                                "computeType": "topn_aggregate_avg"
                            }
                        ]
                    },
                    {
                        "resultType": "singlevalue",
                        "metricName": "TOPN_AGGREGATE_AVG_oa_sysperf_global_cpu_util_10",
                        "metricLabel": "CPU Util &#x28;Aggregate avg&#x29; &#x28;Topn&#x29;",
                        "metricUnit": "",
                        "metricDescription": "CPU Util &#x28;Aggregate avg&#x29; &#x28;Topn&#x29;",
                        "dimensionValues": [
                            "16.60.188.71"
                        ],
                        "displayDimensionValues": [
                            "16.60.188.71"
                        ],
                        "drillLabel": "host withkey \"16.60.188.71\"",
                        "drillPQL": "host withkey \"16.60.188.71\"",
                        "drillTimeFrame": null,
                        "metricValues": [
                            {
                                "metricValue": 1.0,
                                "computeType": "topn_aggregate_avg_rank"
                            }
                        ]
                    },
                    {
                        "resultType": "singlevalue",
                        "metricName": "AGGREGATE_AVG_oa_sysperf_global_cpu_util",
                        "metricLabel": "CPU Util &#x28;Aggregate avg&#x29;",
                        "metricUnit": "%",
                        "metricDescription": "CPU Util &#x28;Aggregate avg&#x29;",
                        "dimensionValues": [
                            "opsa-aob2.hpswlabs.adapps.hp.com"
                        ],
                        "displayDimensionValues": [
                            "opsa-aob2.hpswlabs.adapps.hp.com"
                        ],
                        "drillLabel": "host withkey \"opsa-aob2.hpswlabs.adapps.hp.com\"",
                        "drillPQL": "host withkey \"opsa-aob2.hpswlabs.adapps.hp.com\"",
                        "drillTimeFrame": null,
                        "metricValues": [
                            {
                                "metricValue": 3.06888888888889,
                                "computeType": "topn_aggregate_avg"
                            }
                        ]
                    },
                    {
                        "resultType": "singlevalue",
                        "metricName": "TOPN_AGGREGATE_AVG_oa_sysperf_global_cpu_util_10",
                        "metricLabel": "CPU Util &#x28;Aggregate avg&#x29; &#x28;Topn&#x29;",
                        "metricUnit": "",
                        "metricDescription": "CPU Util &#x28;Aggregate avg&#x29; &#x28;Topn&#x29;",
                        "dimensionValues": [
                            "opsa-aob2.hpswlabs.adapps.hp.com"
                        ],
                        "displayDimensionValues": [
                            "opsa-aob2.hpswlabs.adapps.hp.com"
                        ],
                        "drillLabel": "host withkey \"opsa-aob2.hpswlabs.adapps.hp.com\"",
                        "drillPQL": "host withkey \"opsa-aob2.hpswlabs.adapps.hp.com\"",
                        "drillTimeFrame": null,
                        "metricValues": [
                            {
                                "metricValue": 2.0,
                                "computeType": "topn_aggregate_avg_rank"
                            }
                        ]
                    }
                ],
                "filterQueryResult": false,
                "metricLabels": [
                    "CPU Util &#x28;*Aggregate* avg&#x29; &#x28;Topn&#x29;",
                    "CPU Util &#x28;*Aggregate* avg&#x29; &#x28;&#x25;&#x29;"
                ],
                "outerCall": false,
                "partialResult": false,
                "aggregatePlayback": false,
                "metaResult": false
            }
        ]
    }
    `
    res.reply "Displaying top #{numHosts} hosts"+ scan(JSON.parse(opsa))
#Promise = require('promise')
request = require('request')
require('request-debug')(request);
hostName = '16.60.188.235:8080/opsa'
user = "opsa"
password = "opsa"
semaphore = false;

getSessionId = (res) ->
    firstCookie = res.headers["set-cookie"][0]
    jSessionId = firstCookie.split("=")[1].split(";")[0]

createJar = (res, securityCheckUrl) ->
    jSessionId = getSessionId(res)
    jar = request.jar()
    cookie = request.cookie('JSESSIONID=' + jSessionId)
    jar.setCookie cookie, securityCheckUrl, (error, cookie) ->

displayAnomalies = (res1) ->
    if semaphore == true
        return;
    semaphore = true
    opsaHomeUrl = 'http://' + hostName
    requestp(opsaHomeUrl).then ((res, data) ->
        securityCheckUrl = opsaHomeUrl + "/j_security_check"
        jar = createJar(res, securityCheckUrl)
        form =
            j_username: user
            j_password: password
        headers =
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
            'Accept-Encoding': 'gzip, deflate'
            'Accept-Language': 'en-US,en;q=0.8,he;q=0.6'
            'Connection': 'keep-alive'
            'Content-Type': 'application/x-www-form-urlencoded'
            'Upgrade-Insecure-Requests': '1'
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36'
            'Origin': 'http://16.60.188.235:8080'
            'Referer': 'http://16.60.188.235:8080/opsa/'
            'Cache-Control': 'max-age=0'
        requestp(securityCheckUrl, headers, 'POST', jar, form).then ((res) ->
            headers =
                'Accept': 'application/json, text/plain, */*'
                'Accept-Encoding': 'gzip, deflate, sdch'
                'Accept-Language': 'en-US,en;q=0.8,he;q=0.6'
                'Connection': 'keep-alive'
                'Upgrade-Insecure-Requests': '1'
                'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36'
                'Cache-Control': 'max-age=0'
            getXSRFTokenUrl = opsaHomeUrl + "/rest/getXSRFToken"
            jar = createJar(res, getXSRFTokenUrl)
            requestp(getXSRFTokenUrl, headers, 'GET', jar).then ((res) ->
                iconv = require("iconv-lite")
                console.log iconv.decode(res.body, 'x-www-form-urlencoded')
        )
        )
        return
    ), (err) ->
        console.error '%s; %s', err.message, opsaHomeUrl
        console.log '%j', err.res.statusCode
        return
    res1.reply 'Displaying Anomalies For Host: ' + res1.match[1]

requestp = (url, headers, method, jar, form) ->
    headers = headers or {}
    method = method or 'GET'
    jar = jar or {}
    form = form or {}

    new Promise((resolve, reject) ->
        request {
            uri: url
            headers: headers
            method: method
            jar: jar
            form: form
            encoding: null
        }, (err, res, body) ->
            if err
                return reject(err)
            else if res.headers["set-cookie"]
                resolve res, body
            else if res.statusCode != 200
                err = new Error('Unexpected status code: ' + res.statusCode)
                err.res = res
                return reject(err)
            resolve res, body
            return
        return
    )




module.exports = (robot) ->
    robot.respond /top (.*) hosts/i, (res) ->
        displayHosts(res)

    robot.respond /alert (.*)/i, (res) ->
        createMessage(res)

    robot.respond /display anomalies for host: (.*)/i, (res) ->
        displayAnomalies(res)


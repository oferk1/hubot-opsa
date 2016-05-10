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
            text: "Attachment text"
            fallback: "Attachment fallback"
            fields: [{
                title: "Field title"
                value: "Field value"
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

module.exports = (robot) ->
    robot.respond /top (.*) hosts/i, (res) ->
        displayHosts(res)

    robot.respond /alert (.*)/i, (res) ->
        createMessage(res)


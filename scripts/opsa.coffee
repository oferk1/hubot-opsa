# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

displayHosts = (res) ->
  numHosts = res.match[1]
  res.reply "Displaying top #{numHosts} hosts"+ JSON.stringify `{
          "oa_sysperf_global": [
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

module.exports = (robot) ->
  robot.respond /top (.*) hosts/i, (res) ->
    displayHosts(res)


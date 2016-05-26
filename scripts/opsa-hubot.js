// Generated by CoffeeScript 1.10.0
(function () {
  var AnomHandler, OpsaSession, Properties, createJar, generateJar, getLabels, getLinkToHost, getOneHourAgoTS, getOpsaUri, getRequestedHost, getSessionId, handleAnomRes, lastTime, now, okToContinue, ongoing, request, requestp;

  request = require('request');

  Properties = require('opsa-api-properties.coffee');

  require('request-debug')(request);
  OpsaSession = function (xsrfToken, jSessionId) {
    if (xsrfToken) {
      this.xsrfToken = xsrfToken.slice(1, -1);
    }
    if (jSessionId) {
      this.jSessionId = jSessionId;
    }
  };
  OpsaSession.prototype.login = function (userRes, loginCallback) {
    var localSessionData, loginForm, opsaUri, seqUrl, xsrfUrl;
    if (!okToContinue()) {
      return new Promise(function (resolve, reject) {
      });
    }
    userRes.reply('Please wait...');
    opsaUri = getOpsaUri();
    seqUrl = opsaUri + "/j_security_check";
    xsrfUrl = opsaUri + "/rest/getXSRFToken";
    loginForm = {
      j_username: Properties.user,
      j_password: Properties.password
    };
    this.sData = {};
    localSessionData = this.sData;
    return requestp(opsaUri).then((function (res) {
      var jar4SecurityRequest;
      jar4SecurityRequest = createJar(res, seqUrl, 1);
      return requestp(seqUrl, jar4SecurityRequest, 'POST', {}, loginForm).then((function (res) {
        return requestp(opsaUri, jar4SecurityRequest).then((function (apiSessionResponse) {
          var jar4XSRFRequest;
          localSessionData.sId = getSessionId(apiSessionResponse, 0);
          jar4XSRFRequest = createJar(apiSessionResponse, xsrfUrl);
          return requestp(xsrfUrl, jar4XSRFRequest);
        }));
      }));
    }), function (err) {
      var ongoing;
      ongoing = false;
      console.error('%s; %s', err.message, getOpsaUri());
      console.log('%j', err.res.statusCode);
    });
  };
  requestp = function (url, jar, method, headers, form) {
    headers = headers || {};
    method = method || 'GET';
    jar = jar || {};
    form = form || {};
    return new Promise(function (resolve, reject) {
      var reqData;
      reqData = {
        uri: url,
        headers: headers,
        method: method
      };
      if (jar) {
        reqData.jar = jar;
      }
      if (form) {
        reqData.form = form;
      }
      request(reqData, function (err, res, body) {
        var ongoing;
        if (err) {
          return reject(err);
        } else if (res.statusCode === 200 || res.statusCode === 302 || res.statusCode === 400) {
          resolve(res, body);
        } else {
          ongoing = false;
          err = new Error('Unexpected status code: ' + res.statusCode);
          err.res = res;
          return reject(err);
        }
        resolve(res, body);
      });
    });
  };
  getOpsaUri = function () {
    return Properties.protocol + "://" + Properties.host + ":" + Properties.port + "/" + Properties.path;
  };
  getSessionId = function (res, cookieIndex) {
    var cookie, firstCookie, jSessionId;
    cookie = res.headers["set-cookie"];
    if (typeof cookie === 'undefined') {
      return;
    }
    firstCookie = cookie[cookieIndex];
    return jSessionId = firstCookie.split("=")[1].split(";")[0];
  };
  generateJar = function (jSessionId, url) {
    var cookie, jar;
    jar = request.jar();
    cookie = request.cookie('JSESSIONID=' + jSessionId);
    console.log("setting cookie: " + cookie);
    jar.setCookie(cookie, url, function (error, cookie) {
    });
    return jar;
  };
  createJar = function (res, url, cookieIndex) {
    var jSessionId, jar;
    if (!cookieIndex) {
      cookieIndex = 0;
    }
    jSessionId = getSessionId(res, cookieIndex);
    if (typeof jSessionId === 'undefined') {
      return;
    }
    jar = generateJar(jSessionId, url);
    return jar;
  };

  lastTime = Date.now();

  ongoing = false;
  okToContinue = function () {
    var secondsSinceLastTime;
    secondsSinceLastTime = (Date.now() - lastTime) / 1000;
    if (secondsSinceLastTime < 10 && ongoing) {
      return false;
    } else {
      lastTime = Date.now();
      ongoing = true;
      return true;
    }
  };
  getRequestedHost = function (res) {
    return res.match[1].replace(/^https?\:\/\//i, "");
  };
  getLabels = function (resultResponse) {
    var childProp, i, j, label, labels, len, len1, pref, prop, ref, resJson, val;
    resJson = JSON.parse(resultResponse.body);
    labels = "";
    for (prop in resJson) {
      val = resJson[prop];
      if (prop !== "anomaly_result") {
        for (i = 0, len = val.length; i < len; i++) {
          childProp = val[i];
          if (childProp.metricLabels.length > 1) {
            pref = "\n>";
          } else {
            pref = "";
          }
          ref = childProp.metricLabels;
          for (j = 0, len1 = ref.length; j < len1; j++) {
            label = ref[j];
            labels += pref + label.replace(/&#x[0-9]+;/g, '');
          }
        }
      }
    }
    return labels.replace(",", "");
  };
  getOneHourAgoTS = function () {
    var ONE_HOUR;
    ONE_HOUR = 60 * 60 * 1000;
    return now - ONE_HOUR;
  };
  getLinkToHost = function (hostName) {
    var encodedQuery, url;
    encodedQuery = encodeURIComponent('host withkey "' + hostName);
    url = getOpsaUri() + '/#/logsearchpql?search=' + encodedQuery + '"&start=' + getOneHourAgoTS() + '&end=' + now + '&selectedTimeRange=ONE_HOUR';
    return url;
  };

  now = new Date().getTime();
  AnomHandler = function (xsrfToken, jSessionId) {
    OpsaSession.call(this, xsrfToken, jSessionId);
  };

  AnomHandler.prototype.constructor = AnomHandler;
  AnomHandler.prototype.invokeAPI = function () {
    var anomUrl, createAnomaliesApiUri, oneHourAgo;
    oneHourAgo = getOneHourAgoTS();
    createAnomaliesApiUri = function (startTime, endTime) {
      return "/rest/getQueryResult?aqlQuery=%5Banomalies%5BattributeQuery(%7Bopsa_collection_anomalies%7D,+%7B%7D,+%7Bi.anomaly_id%7D)%5D()%5D+&endTime=" + endTime + "&granularity=0&pageIndex=1&paramsMap=%7B%22$drill_dest%22:%22AnomalyInstance%22,%22$drill_label%22:%22opsa_collection_anomalies_description%22,%22$drill_value%22:%22opsa_collection_anomalies_anomaly_id%22,%22$limit%22:%22500%22,%22$interval%22:300,%22$offset%22:0,%22$N%22:5,%22$pctile%22:10,%22$timeoffset%22:0,%22$starttimeoffset%22:0,%22$endtimeoffset%22:0,%22$timeout%22:0,%22$drill_type%22:%22%22,%22$problemtime%22:1463653196351,%22$aggregate_playback_flag%22:null%7D&queryType=generic&startTime=" + startTime + "&timeZoneOffset=-180&timeout=10&visualType=table";
    };
    anomUrl = getOpsaUri() + createAnomaliesApiUri(oneHourAgo, now);
    this.sJar = generateJar(this.jSessionId, anomUrl);
    this.sHeaders = {
      'XSRFToken': this.xsrfToken
    };
    return requestp(anomUrl, this.sJar, 'POST', this.sHeaders);
  };
  AnomHandler.prototype.getMetricsDescUrl = function (parsedInfo) {
    var endTime, metricsUri, ref;
    now = new Date().getTime();
    endTime = (ref = parsedInfo.inactiveTime) != null ? ref : now;
    metricsUri = "/rest/getQueryDescriptors?endTime=" + endTime + "&q=AnomalyInstance(" + parsedInfo.anomalyId + ")&startTime=" + parsedInfo.triggerTime;
    return getOpsaUri() + metricsUri;
  };
  AnomHandler.prototype.getMetricsUrl = function (parsedInfo, descResponse) {
    var desc, descArray, endTime, ref;
    now = new Date().getTime();
    endTime = (ref = parsedInfo.inactiveTime) != null ? ref : now;
    descArray = JSON.parse(descResponse.body).descriptors;
    for (desc in descArray) {
      if (descArray[desc].label.startsWith("Breaches for Anomaly")) {
        return getOpsaUri() + "/rest/getQueryResult?aqlQuery=" + encodeURIComponent(descArray[desc].aql) + "&endTime=" + endTime + '&granularity=0&pageIndex=1&paramsMap={"$starttime":"' + new Date(parsedInfo.triggerTime) + '","$limit":"1000","$interval":7200,"$offset":0,"$N":5,"$pctile":10,"$timeoffset":0,"$starttimeoffset":0,"$endtimeoffset":0,"$timeout":0,"$drill_dest":"","$drill_label":"","$drill_value":"","$drill_type":"","$problemtime":' + parsedInfo.triggerTime + ',"$aggregate_playback_flag":null}&queryType=anomalyInstance&startTime=' + parsedInfo.triggerTime + '&timeZoneOffset=-180&timeout=10';
      }
    }
  };
  AnomHandler.prototype.parseRes = function (body, requestedHost) {
    var anomalies, collection, collectionGroup, collectionGroupId, collectionId, collections, columnIdx, extractInfoFromRawProps, extractSingleAnomalyData, modifyOutput, propNames, row, rowIdx, singleAnomaly, table, tableIdx, tableRows;
    anomalies = new Array();
    collections = JSON.parse(body);
    extractInfoFromRawProps = function (props, propName, propVal) {
      switch (propName) {
        case "Active time":
          props.triggerTime = propVal;
          break;
        case "Inactive time":
          props.inactiveTime = propVal;
          break;
        case "Anomaly id":
          props.anomalyId = propVal;
          break;
        case "Entity":
          props.rawEntity = propVal;
      }
      return props;
    };
    modifyOutput = function (propName, propVal) {
      var jsonValue, str, val;
      switch (propName) {
        case "Status":
          if (propVal === "Inactive") {
            return null;
          }
          break;
        case "Inactive time":
        case "First breach":
        case "Breaches timestamps":
        case "Rules":
          return null;
        case "Active time":
          propName = "Trigger Time";
          propVal = new Date(Number(propVal));
          break;
        case "Severity":
          str = '';
          jsonValue = JSON.parse(propVal);
          for (val in jsonValue) {
            str += ',' + jsonValue[val];
          }
          str = str.replace(',', '');
          propVal = str;
          break;
        case "Entity":
          propVal = getLinkToHost(propVal);
      }
      return {
        propName: propName,
        propVal: propVal
      };
    };
    extractSingleAnomalyData = function (anomalyRawData) {
      var anomalyPropertiesAsText, colIdx, display, extractedInfo, hostName, modifiedProps, propName, propVal;
      anomalyPropertiesAsText = "";
      display = false;
      extractedInfo = {};
      extractedInfo.anomalyPropertiesText = "";
      for (colIdx in anomalyRawData) {
        propName = propNames[colIdx];
        propVal = anomalyRawData[colIdx].displayValue;
        extractedInfo = extractInfoFromRawProps(extractedInfo, propName, propVal);
        modifiedProps = modifyOutput(propName, propVal);
        if (!modifiedProps) {
          continue;
        }
        propName = modifiedProps.propName;
        propVal = modifiedProps.propVal;
        if (propName === "Status" && propVal !== "active") {
          return null;
        }
        if (display === false && propName === "Entity" && (propVal === requestedHost || requestedHost === "*")) {
          display = true;
          hostName = extractedInfo.rawEntity;
        }
        anomalyPropertiesAsText += "*" + propName + ":* " + propVal + "\n";
      }
      if (!display) {
        return null;
      }
      extractedInfo.text = "\n*Displaying anomalies for host:* " + hostName + "\n>>>" + anomalyPropertiesAsText;
      return extractedInfo;
    };
    for (collectionGroupId in collections) {
      collectionGroup = collections[collectionGroupId];
      for (collectionId in collectionGroup) {
        collection = collectionGroup[collectionId].processedResult;
        for (tableIdx in collection) {
          table = collection[tableIdx];
          propNames = new Array();
          for (columnIdx in table.columnNames) {
            propNames.push(table.columnNames[columnIdx].columnTitle);
          }
          tableRows = table.tableDataWithDrill;
          for (rowIdx in tableRows) {
            row = tableRows[rowIdx];
            singleAnomaly = extractSingleAnomalyData(row);
            if (singleAnomaly) {
              anomalies.push(singleAnomaly);
            }
          }
        }
      }
    }
    return anomalies;
  };
  AnomHandler.prototype.getMetrics = function (anom) {
    var mDescUrl, sHeaders, sJar;
    sJar = this.sJar;
    sHeaders = this.sHeaders;
    mDescUrl = AnomHandler.prototype.getMetricsDescUrl(anom);
    return requestp(mDescUrl, sJar, 'GET', sHeaders).then((function (descRes) {
      var mUrl;
      mUrl = AnomHandler.prototype.getMetricsUrl(anom, descRes);
      return requestp(mUrl, sJar, 'POST', sHeaders);
    }));
  };
  handleAnomRes = function (anomHandler, anomRes, rHost, userRes) {
    var anom, anoms, getMetricsAndReply, i, len, results;
    anoms = anomHandler.parseRes(anomRes.body, rHost);
    if (anoms.length === 0) {
      userRes.reply('No data found for host: ' + rHost + "\n");
    }
    getMetricsAndReply = function (anom) {
      var clonedAnom;
      clonedAnom = JSON.parse(JSON.stringify(anom));
      return function () {
        return anomHandler.getMetrics(clonedAnom).then((function (resultRes) {
          clonedAnom.text += "*Breached Metrics:* " + getLabels(resultRes);
          return userRes.reply(clonedAnom.text);
        }));
      };
    };
    results = [];
    for (i = 0, len = anoms.length; i < len; i++) {
      anom = anoms[i];
      results.push((getMetricsAndReply(anom))());
    }
    return results;
  };
  module.exports = function (robot) {
    return robot.respond(/display anomalies for host:?:\s*(.*)/i, function (userRes) {
      var rHost, sess;
      rHost = getRequestedHost(userRes);
      sess = new OpsaSession();
      return sess.login(userRes).then((function (res) {
        var anomHandler;
        anomHandler = new AnomHandler(res.body, sess.sData.sId);
        return anomHandler.invokeAPI().then((function (anomRes) {
          handleAnomRes(anomHandler, anomRes, rHost, userRes);
          ongoing = false;
        }));
      }));
    });
  };

}).call(this);

//# sourceMappingURL=opsa-hubot.js.map

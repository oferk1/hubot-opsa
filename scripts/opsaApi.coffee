OpsaAPI = (xsrfToken, jSessionId) ->
  @xsrfToken = xsrfToken.slice 1, -1
  @jSessionId = jSessionId
  return


module.exports = () ->
  this.OpsaAPI = OpsaAPI


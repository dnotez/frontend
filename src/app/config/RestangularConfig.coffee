angular.module "dNotez"
.config(['RestangularProvider', (RestangularProvider) ->
  RestangularProvider.setBaseUrl '/users/public'
  RestangularProvider.addResponseInterceptor (data, operation, what, url, response, deferred) ->
    console.log 'url:'+url+', data:', data
    return data.results if data.results?
    return data
  return
])

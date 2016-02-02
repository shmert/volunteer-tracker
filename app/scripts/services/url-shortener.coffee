'use strict'

###*
 # @ngdoc service
 # @name volunteerTrackerHtmlApp.urlShortener
 # @description
 # # urlShortener
 # Service in the volunteerTrackerHtmlApp.
###
angular.module 'volunteerTrackerHtmlApp'
.service 'urlShortener', ($http, $q) ->
  accessTokenBitly = 'fad780834fedf61d89f157ebc280ed6ada449c69'
  cache = {}

  @shorten = (shortenMe, title) ->
    return $q.resolve(cache[shortenMe]) if (cache[shortenMe])
    # BIT.LY API
    url = 'https://api-ssl.bitly.com/v3/shorten?access_token=' + accessTokenBitly + '&longUrl=' + encodeURIComponent(shortenMe);
    $http.get(url, {withCredentials:false}).then (response) -> cache[shortenMe] = response.data.data.url;
#    bitly = 'https://api-ssl.bitly.com/v3/user/link_save'
#    $http.get(bitly, {
#      withCredentials:false
#      params: {
#        access_token:accessTokenBitly
#        longUrl:encodeURIComponent(url)
#        title:title
#      }
#    }).then (response) -> response.data.data.url;


  return this;

### GOOGLE API
    $http.post('https://www.googleapis.com/urlshortener/v1/url?key=#key',
      {
        longUrl: 'http://uihacker.blogspot.ca/2013/04/javascript-use-googl-link-shortener.html'
      }
    ).then( (response) ->
      response.data;
    )
###


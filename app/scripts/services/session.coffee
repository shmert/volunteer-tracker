'use strict'

###*
 # @ngdoc service
 # @name volunteerTrackerHtmlApp.session
 # @description
 # # session
 # Service in the volunteerTrackerHtmlApp.
###
angular.module 'volunteerTrackerHtmlApp'
  .service 'session', ($http, $location, $rootScope, REST_URL) ->
    # eg {admin: true, uid: 7562241, name: null}
    @schoologyAccount = null;
    @userAccount = null;

    that = this

    console.log('Getting schoology account')
    $http.get(REST_URL + '/schoology-account').success( (acctResponse) ->
      that.schoologyAccount = acctResponse
      console.log('Getting user record for ' + acctResponse.uid)
      $http.get(REST_URL + '/users/' + acctResponse.uid).success (userResponse) ->
        that.userAccount = userResponse
        console.log('Login complete: ' + userResponse)
        $rootScope.$broadcast('loggedIn', true)
    ).error((err) ->
      #alert('Please log in to Schoology again')
      $location.path('not-logged-in');
      throw err;
    )

    @switchUser = (userId) ->
      $http.get(REST_URL + '/users/' + userId, {params:{su:true}}).success (user) ->
        that.userAccount = user
        $rootScope.$broadcast('su', user)
        $http.get(REST_URL + '/schoology-account').success (acctResponse) ->
          that.schoologyAccount = acctResponse


    @stopSwitchUser = ->
      $http.get(REST_URL + '/stop-switch-user').success (user) ->
        that.userAccount = user
        $rootScope.$broadcast('su', user)
        $http.get(REST_URL + '/schoology-account').success (acctResponse) ->
          that.schoologyAccount = acctResponse

    return this


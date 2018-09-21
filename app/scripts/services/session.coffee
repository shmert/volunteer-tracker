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
    @schoologyAccountBackup = null;
    @userAccountBackup = null;
    @errors = []

    that = this

    console.log('Getting schoology account')
    $http.get(REST_URL + '/schoology-account').then( (o) ->
      that.schoologyAccount = o.data
      console.log('Getting user record for ' + that.schoologyAccount.uid)
      $http.get(REST_URL + '/users/' + that.schoologyAccount.uid).then (userResponse) ->
        that.userAccount = userResponse.data;
        console.log('Login complete: ' + that.userAccount)
        $rootScope.$broadcast('loggedIn', true)
    ).catch((err) ->
      #alert('Please log in to Schoology again')
      $location.path('not-logged-in');
      throw err;
    )

    @logAndReportError = (err, optionalMessage) ->
      errorString = err?.data?.message || err?.data || err
      errorString = JSON.stringify(errorString) if typeof errorString == 'object'
      alert(optionalMessage || errorString)
      @errors.push(errorString)
      report = {
        email: that.userAccount?.primary_email
        user:that.userAccount?.name_display
        userId:that.userAccount?.id
        date:new Date().getTime()
        notes:'Auto-generated bug report\n\n' + errorString
      }
      $http.post(REST_URL + '/bug-report', report) # fire and forget :/



    @switchUser = (userId) ->
      $http.get(REST_URL + '/users/' + userId, {params:{su:true}}).then (response) ->
        that.userAccountBackup - that.userAccount if !that.userAccountBackup
        that.userAccount = response.data
        $rootScope.$broadcast('su', that.userAccount)
        $http.get(REST_URL + '/schoology-account').then (acctResponse) ->
          that.schoologyAccountBackup = that.schoologyAccount if !that.schoologyAccountBackup
          that.schoologyAccount = acctResponse.data


    @stopSwitchUser = ->
      $http.get(REST_URL + '/stop-switch-user').then (response) ->
        that.userAccount = response.data
        that.userAccountBackup = null
        $rootScope.$broadcast('su', that.userAccount)
        $http.get(REST_URL + '/schoology-account').then (acctResponse) ->
          that.schoologyAccount = acctResponse.data
          that.schoologyAccountBackup = null

    return this


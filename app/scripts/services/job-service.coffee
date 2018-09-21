'use strict'

###*
 # @ngdoc service
 # @name volunteerTrackerHtmlApp.jobService
 # @description
 # # jobService
 # Service in the volunteerTrackerHtmlApp.
###
angular.module 'volunteerTrackerHtmlApp'
  .service 'jobService', ($rootScope, $http, REST_URL) ->
    dummyJobs = []
    unwrap = (response) -> response.data;

    this.setAllJobs = (jobs) -> dummyJobs = jobs
    #this.allJobs = -> dummyJobs
    this.allJobs = (params)->
      $http.get(REST_URL + '/jobs', {params:params}).then(unwrap);

    this.myJobs = (params)->
      $http.get(REST_URL + '/jobs', {params:{upcoming:'false', for:'me'}}).then(unwrap);

    this.findByUserId = (userId)->
      $http.get(REST_URL + '/jobs', {params:{upcoming:'false', userId:userId}}).then(unwrap);

    this.findByFilter = (filter) ->
      $http.get(REST_URL + '/jobs', {params:filter}).then(unwrap);

    this.findById = (id) ->
      $http.get(REST_URL + '/jobs/' + id).then(unwrap);
      #dummyJobs[id]

    this.updateSignUp = (signUp) ->
      $http.post(REST_URL + '/signUps', signUp, {withCredentials:true}).then ( saved) ->
        $rootScope.$broadcast('save')
        return unwrap(saved);

    this.push = (job) ->
      $http.post(REST_URL + '/jobs', job, {withCredentials:true}).then( (saved) ->
        $rootScope.$broadcast('save')
        return unwrap(saved);
      )
      #return alert('Duplicate job') if _.find(dummyJobs, job)
      #if (!job.id)
      #  job.id = dummyJobs.length
      #dummyJobs.push(job)
      #$rootScope.$broadcast('save')

    #this.saveSlot = (slot) ->
    #  $http.post(REST_URL + '/slots', slot);

    return this

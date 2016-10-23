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

    this.setAllJobs = (jobs) -> dummyJobs = jobs
    #this.allJobs = -> dummyJobs
    this.allJobs = (params)->
      $http.get(REST_URL + '/jobs', {params:params})

    this.myJobs = (params)->
      $http.get(REST_URL + '/jobs', {params:{upcoming:'false', for:'me'}})

    this.findByUserId = (userId)->
      $http.get(REST_URL + '/jobs', {params:{upcoming:'false', userId:userId}})

    this.findByFilter = (filter) ->
      $http.get(REST_URL + '/jobs', {params:filter})

    this.findById = (id) ->
      $http.get(REST_URL + '/jobs/' + id)
      #dummyJobs[id]

    this.updateSignUp = (signUp) ->
      $http.post(REST_URL + '/signUps', signUp, {withCredentials:true}).then ( saved) ->
        $rootScope.$broadcast('save')
        return saved;

    this.push = (job) ->
      $http.post(REST_URL + '/jobs', job, {withCredentials:true}).then( (saved) ->
        $rootScope.$broadcast('save')
        return saved;
      )
      #return alert('Duplicate job') if _.find(dummyJobs, job)
      #if (!job.id)
      #  job.id = dummyJobs.length
      #dummyJobs.push(job)
      #$rootScope.$broadcast('save')

    #this.saveSlot = (slot) ->
    #  $http.post(REST_URL + '/slots', slot);

    return this

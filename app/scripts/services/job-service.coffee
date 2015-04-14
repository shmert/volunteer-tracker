'use strict'

###*
 # @ngdoc service
 # @name volunteerTrackerHtmlApp.jobService
 # @description
 # # jobService
 # Service in the volunteerTrackerHtmlApp.
###
angular.module 'volunteerTrackerHtmlApp'
  .service 'jobService', ($rootScope) ->
    dummyJobs = []

    this.setAllJobs = (jobs) -> dummyJobs = jobs
    this.allJobs = -> dummyJobs
      
    this.findById = (id) ->
      dummyJobs[id]

    this.push = (job) ->
      return alert('Duplicate job') if _.find(dummyJobs, job)
      if (!job.id)
        job.id = dummyJobs.length
      dummyJobs.push(job)
      $rootScope.$broadcast('save')

    return this

'use strict'

describe 'Service: jobService', ->

  # load the service's module
  beforeEach module 'volunteerTrackerHtmlApp'

  # instantiate service
  jobService = {}
  http = null

  beforeEach inject (_jobService_, $httpBackend) ->
    jobService = _jobService_
    http = $httpBackend

  it 'should save new jobs', () ->
    jobDate = new Date('2015-01-23 04:56:07 PM')
    endTime = moment('8:00:00', 'HH:mm:ss').add(5, 'h').format('HH:mm:ss')
    newJob = {
      id: null,
      name: 'JobServiceTest',
      date: jobDate,
      private:true
      categories: ['School-wide'],
      recurrence: {type: ''},
      tasks: [
        {id: null, name: 'JobServiceTest', description: 'Generated by test case'}
      ]
      timeSlots: [
        {
          signUps:{
            userId:42, date: jobDate, verified:false
          }
          needed:1
          startTime:'8:00:00'
          endTime:endTime
          taskId:null
        }
      ]

    }
    http.expectPOST('/jobs', {"id": null, "name": "JobServiceTest", "date": "Invalid Date", "private": true, "categories": [
      "School-wide"], "recurrence": {"type": ""}, "tasks": [
      {"id": null, "name": "JobServiceTest", "description": "Generated by test case"}
    ], "timeSlots": [
      {"signUps": {"userId": 42, "date": "Invalid Date", "verified": false}, "needed": 1, "startTime": "8:00:00", "endTime": "13:00:00", "taskId": null}
    ]}).respond(->
      copiedJob = (newJob) # FIX! clone this
      copiedJob.id=123
      copiedJob.tasks[0].id = 1883
      copiedJob.timeSlots[0].taskId=1883
    )
    jobService.push(newJob)
    http.flush()


'use strict'

describe 'Service: jobService', ->

  # load the service's module
  beforeEach module 'volunteerTrackerHtmlApp'

  # instantiate service
  jobService = {}
  beforeEach inject (_jobService_) ->
    jobService = _jobService_

  it 'should do something', ->
    expect(!!jobService).toBe true

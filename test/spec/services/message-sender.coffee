'use strict'

describe 'Service: messageSender', ->

  # load the service's module
  beforeEach module 'volunteerTrackerHtmlApp'

  # instantiate service
  messageSender = {}
  beforeEach inject (_messageSender_) ->
    messageSender = _messageSender_

  it 'should do something', ->
    expect(!!messageSender).toBe true

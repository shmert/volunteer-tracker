'use strict'

describe 'Service: volunteerUtils', ->

  # load the service's module
  beforeEach module 'volunteerTrackerHtmlApp'

  # instantiate service
  volunteerUtils = {}
  beforeEach inject (_volunteerUtils_) ->
    volunteerUtils = _volunteerUtils_

  it 'should do something', ->
    expect(!!volunteerUtils).toBe true

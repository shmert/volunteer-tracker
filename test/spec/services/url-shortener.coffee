'use strict'

describe 'Service: urlShortener', ->

  # load the service's module
  beforeEach module 'volunteerTrackerHtmlApp'

  # instantiate service
  urlShortener = {}
  beforeEach inject (_urlShortener_) ->
    urlShortener = _urlShortener_

  it 'should do something', ->
    expect(!!urlShortener).toBe true

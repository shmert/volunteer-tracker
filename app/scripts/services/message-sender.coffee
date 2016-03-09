'use strict'

###*
 # @ngdoc service
 # @name volunteerTrackerHtmlApp.messageSender
 # @description
 # # messageSender
 # Service in the volunteerTrackerHtmlApp.
###
angular.module 'volunteerTrackerHtmlApp'
  .service 'messageSender', ($http, REST_URL, session) ->
    ###*
     Sample payload:
      payload =
        subject: msg.subject
        message: msg.body
        recipient_ids: [123,456]

    ###
    @sendWithFeedback = (payload) ->
      if (!payload.subject || !payload.message || !payload.recipient_ids)
        throw 'Invalid message payload: subject, message, recipient_ids are required'
      if (!angular.isArray(payload.recipient_ids))
        payload.recipient_ids = [payload.recipient_ids]
      $http.post(REST_URL + '/messages', payload).then ->
        alert('Message was sent to ' + payload.recipient_ids.length + ' recipient(s)')
      ,(error) ->
        session.logAndReportError(error, 'Unable to send your message: ' + (error.data?.message || error?.data));


    return this

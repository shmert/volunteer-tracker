'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:AdminAddindividualtimeCtrl
 # @description
 # # AdminAddindividualtimeCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
.controller 'AdminAddindividualtimeCtrl', ($scope, userService, users, jobService, $location, $q, $http, session, REST_URL) ->
  $scope.userOptions = users

  u = session.userAccount;

  $scope.job = {
    volunteers: [
      {user: {"id":u.id,"roleId":null,"firstName":u.name_first,"lastName":u.name_last,"fullName":u.name_display}},
      {user:null}
    ]
  }

  $scope.findUsers = (q) ->
#    return $q.defer([session.userAccount]).promise if (false && !$scope.isAdmin())
#
    linkedTo = null;
    linkedTo = session.userAccount.id if !$scope.isAdmin()
    userService.quickSearch(q, {linkedTo:linkedTo}).then (found) ->
      return found

  $scope.ensureEmptyVolunteerSlotExists = ->
    if ($scope.job.volunteers.length == 0 || $scope.job.volunteers[$scope.job.volunteers.length - 1].user != null)
      $scope.job.volunteers.push({user: null})

  $scope.removeVolunteer = ($index) ->
    $scope.job.volunteers.splice($index, 1)
    $scope.ensureEmptyVolunteerSlotExists()

  $scope.queryCategories = (q) ->
    url = REST_URL + '/groups-mine'
    $http.get(url, {params:{q:q,},withCredentials:true}).then (response)->
      _.map(response.data, 'title')

  $scope.save = ->

    signUps = _.map( $scope.job.volunteers, (v)->{userId:v.user?.id, date:$scope.job.date, verified:$scope.isAdmin(), fullName:v.user?.fullName})
    signUps.pop()

    return alert('Please choose at least one group / class') if $scope.job.categories.length == 0
    return alert('Please choose at least one volunteer') if signUps.length == 0

    startTime = '08:00';
    endTime = moment(startTime, 'HH:mm').add($scope.job.hours, 'h').format('HH:mm')


    newJob = {
      id: null,
      name: $scope.job.description,
      date: $scope.job.date,
      private:true
      categories: $scope.job.categories,
      recurrence: {type:'', daysOfWeek:{1:true,2:true,3:true,4:true,5:true}},
      tasks: [
        {
          id: null,
          name: $scope.job.description,
          description: 'One-off job item'
          timeSlots: [
            {
              signUps:signUps
              needed:signUps.length
              startTime:startTime
              endTime:endTime
              hrsCredit: $scope.job.hours
              hrsCreditOverride: $scope.job.hours
            }
          ]

        }
      ]

    }
    jobService.push(newJob).then ->
      alert('Your time has been posted. Thank you!')
      $location.path('/admin')
    , (e)-> session.logAndReportError(e)

  $scope.jobCount = ->
    return jobService.allJobs().length # FIX! this is a promise, right?

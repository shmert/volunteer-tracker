'use strict'

###*
 # @ngdoc function
 # @name volunteerTrackerHtmlApp.controller:ProfileEditCtrl
 # @description
 # # ProfileEditCtrl
 # Controller of the volunteerTrackerHtmlApp
###
angular.module 'volunteerTrackerHtmlApp'
  .controller 'ProfileEditCtrl', ($scope, $location, session, userService) ->
    userService.findById(session.userAccount.id).then (found) ->
      $scope.user = found.data;
      $scope.user.phone = $scope.user.profile_info.phone if !$scope.user.phone # use schoology phone if none specified

    $scope.save = () ->
      userService.updateUser($scope.user).then(
        (updated) ->
          alert('Your account has been updated, thanks!')
#          session.userAccount = updated;
          $location.path('/admin')
        , (e) ->
          session.logAndReportError(e)
      )

    return

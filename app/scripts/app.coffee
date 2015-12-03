'use strict'

users = []

###*
 # @ngdoc overview
 # @name volunteerTrackerHtmlApp
 # @description
 # # volunteerTrackerHtmlApp
 #
 # Main module of the application.
###
angular
  .module('volunteerTrackerHtmlApp', [
    'ngAnimate',
    'ngCookies',
    'ngRoute',
    'ui.bootstrap'
    'jshor.angular-addtocalendar'
    'ngTagsInput'
  ])
  .run ($rootScope, jobService) ->
    $rootScope.$on('su', (event, u) ->
        $rootScope.user = u
        $rootScope.$emit('save')
    )
    $rootScope.$on('$routeChangeError', (event, error) ->
      if (error.$$route.controller=='JobDetailCtrl')
        alert('Could not load job ' + error.params.id + ', it may have been deleted from the database.');
    )


  .config ($routeProvider, $httpProvider) ->
    $httpProvider.defaults.withCredentials = true;

    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        resolve:{
          myJobs:(jobService)->jobService.myJobs()
        }
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
      .when '/job-detail/:id',
        templateUrl: 'views/job-detail.html'
        controller: 'JobDetailCtrl'
        reloadOnSearch:false
        resolve:{
          job:($route, jobService)->jobService.findById $route.current.params.id
        }
      .when '/job-list',
        templateUrl: 'views/job-list.html'
        controller: 'JobListCtrl'
        reloadOnSearch: false
      .when '/job-add',
        templateUrl: 'views/job-admin.html'
        controller: 'JobAdminCtrl'
        resolve:{
          job: -> {data:{id:null, name:'', recurrence:{type:''}, timeSlots:[], tasks:[{name:null,description:null,timeSlots:[{signUps:[],needed:1,startTime:moment('8:00:00', 'HH:mm:ss').toDate(),endTime:moment('9:00:00', 'HH:mm:ss').toDate()}]}], categories:[]}}
        }
      .when '/job-admin/:id',
        templateUrl: 'views/job-admin.html'
        controller: 'JobAdminCtrl'
        resolve:{
          job:($route, jobService)->jobService.findById($route.current.params.id)
        }
      .when '/admin',
        templateUrl: 'views/admin.html'
        controller: 'AdminCtrl'
      .when '/admin/users',
        templateUrl: 'views/admin-users.html'
        controller: 'AdminUsersCtrl'
        resolve:{
          allJobs:(jobService)->jobService.allJobs()
          #allUsers:(userService) -> userService.allUsers({max:10000})
        }
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
      .when '/ssb',
        templateUrl: 'views/ssb.html'
        controller: 'SsbCtrl'
      .when '/admin/addIndividualTime',
        templateUrl: 'views/admin-addindividualtime.html'
        controller: 'AdminAddindividualtimeCtrl'
        resolve:{
          users:->users
        }

      .when '/admin/signups',
        templateUrl: 'views/admin-signups.html'
        controller: 'AdminSignupsCtrl'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
      .when '/not-logged-in',
        templateUrl: 'views/not-logged-in.html'
        controller: 'NotLoggedInCtrl'
      .when '/admin/users/:id',
        templateUrl: 'views/admin-user-edit.html'
        controller: 'AdminUserEditCtrl'
        resolve: {
          user: ($route, userService) -> userService.findById($route.current.params.id)
        }
      .when '/bug-report',
        templateUrl: 'views/bug-report.html'
        controller: 'BugReportCtrl'
        controllerAs: 'bugReport'
      .when '/admin/groups',
        templateUrl: 'views/groups.html'
        controller: 'GroupsCtrl'
        controllerAs: 'groups'
        resolve: {
          groups: (groupService) -> groupService.findMyGroups()
        }
      .when '/admin/groups/:id',
        templateUrl: 'views/groups-detail.html'
        controller: 'GroupsDetailCtrl'
        controllerAs: 'groupsDetail'
        resolve:{
          group: ($route, groupService) -> groupService.findById($route.current.params.id)
        }
      .otherwise
        redirectTo: '/'


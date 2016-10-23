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
  .run ($rootScope, jobService, session) ->
    $rootScope.$on('su', (event, u) ->
        $rootScope.user = u
        $rootScope.$emit('save')
    )
    $rootScope.$on('$routeChangeError', (event, error) ->
      if (error.$$route.controller=='JobDetailCtrl')
        session.logAndReportError(error, 'Could not load job ' + error.params.id + ', it may have been deleted from the database.')
    )

  .config ($compileProvider) ->
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome-extension):/);

  .config ($routeProvider, $httpProvider) ->
    $httpProvider.defaults.withCredentials = true;

    $routeProvider
      .when '/',
        templateUrl: 'views/main.html?v=2016-10-21'
        controller: 'MainCtrl'
        resolve:{
          myJobs:(jobService)->jobService.myJobs()
        }
      .when '/about',
        templateUrl: 'views/about.html?v=2016-10-21'
        controller: 'AboutCtrl'
      .when '/job-detail/:id',
        templateUrl: 'views/job-detail.html?v=2016-10-21'
        controller: 'JobDetailCtrl'
        reloadOnSearch:false
        resolve:{
          job:($route, jobService)->jobService.findById $route.current.params.id
        }
      .when '/job-signup-report/:id',
        templateUrl: 'views/job-signup-report.html?v=2016-10-21'
        controller: 'JobSignupReportCtrl'
        controllerAs: 'jobSignupReport'
        resolve:{
          job:($route, jobService)->jobService.findById $route.current.params.id
        }
      .when '/job-list',
        templateUrl: 'views/job-list.html?v=2016-10-21'
        controller: 'JobListCtrl'
        reloadOnSearch: false
      .when '/job-add',
        templateUrl: 'views/job-admin.html?v=2016-10-21'
        controller: 'JobAdminCtrl'
        resolve:{
          job: -> {data:{id:null, name:'', recurrence:{type:'',daysOfWeek:{1:true,2:true,3:true,4:true,5:true}}, timeSlots:[], tasks:[{name:null,description:null,timeSlots:[{signUps:[],needed:1,startTime:moment('8:00:00', 'HH:mm:ss').toDate(),endTime:moment('9:00:00', 'HH:mm:ss').toDate()}]}], categories:[]}}
        }
      .when '/job-admin/:id',
        templateUrl: 'views/job-admin.html?v=2016-10-21'
        controller: 'JobAdminCtrl'
        resolve:{
          job:($route, jobService)->jobService.findById($route.current.params.id)
        }
      .when '/admin',
        templateUrl: 'views/admin.html?v=2016-10-21'
        controller: 'AdminCtrl'
      .when '/admin/users',
        templateUrl: 'views/admin-users.html?v=2016-10-21'
        controller: 'AdminUsersCtrl'
        resolve:{
          allJobs:(jobService)->jobService.allJobs()
          #allUsers:(userService) -> userService.allUsers({max:10000})
        }
      .when '/about',
        templateUrl: 'views/about.html?v=2016-10-21'
        controller: 'AboutCtrl'
      .when '/ssb',
        templateUrl: 'views/ssb.html?v=2016-10-21'
        controller: 'SsbCtrl'
      .when '/admin/addIndividualTime',
        templateUrl: 'views/admin-addindividualtime.html?v=2016-10-21'
        controller: 'AdminAddindividualtimeCtrl'
        resolve:{
          users:->users
        }

      .when '/admin/signups',
        templateUrl: 'views/admin-signups.html?v=2016-10-21'
        controller: 'AdminSignupsCtrl'
      .when '/about',
        templateUrl: 'views/about.html?v=2016-10-21'
        controller: 'AboutCtrl'
      .when '/not-logged-in',
        templateUrl: 'views/not-logged-in.html?v=2016-10-21'
        controller: 'NotLoggedInCtrl'
      .when '/admin/users/:id',
        templateUrl: 'views/admin-user-edit.html?v=2016-10-21'
        controller: 'AdminUserEditCtrl'
        resolve: {
          user: ($route, userService) -> userService.findById($route.current.params.id)
        }
      .when '/bug-report',
        templateUrl: 'views/bug-report.html?v=2016-10-21'
        controller: 'BugReportCtrl'
        controllerAs: 'bugReport'
      .when '/admin/groups',
        templateUrl: 'views/groups.html?v=2016-10-21'
        controller: 'GroupsCtrl'
        controllerAs: 'groups'
        resolve: {
          groups: (groupService) -> groupService.findMyGroups()
        }
      .when '/admin/groups/:id',
        templateUrl: 'views/groups-detail.html?v=2016-10-21'
        controller: 'GroupsDetailCtrl'
        controllerAs: 'groupsDetail'
        resolve:{
          group: ($route, groupService) -> groupService.findById($route.current.params.id)
        }
      .when '/signup-list',
        templateUrl: 'views/signup-list.html?v=2016-10-21'
        controller: 'SignupListCtrl'
        controllerAs: 'signupList'
      .when '/profile-edit',
        templateUrl: 'views/profile-edit.html?v=2016-10-21'
        controller: 'ProfileEditCtrl'
        controllerAs: 'profileEdit'
      .when '/admin/volunteer-roundup',
        templateUrl: 'views/admin-volunteer-roundup.html?v=2016-10-21'
        controller: 'AdminVolunteerRoundupCtrl'
        controllerAs: 'adminVolunteerRoundup'
      .otherwise
        redirectTo: '/'


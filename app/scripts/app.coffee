'use strict'

users = []
APP_VERSION = '$VERSION$';

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
        templateUrl: 'views/main.html?v=' + APP_VERSION
        controller: 'MainCtrl'
        resolve:{
          myJobs:(jobService)->jobService.myJobs()
        }
      .when '/about',
        templateUrl: 'views/about.html?v=' + APP_VERSION
        controller: 'AboutCtrl'
      .when '/job-detail/:id',
        templateUrl: 'views/job-detail.html?v=' + APP_VERSION
        controller: 'JobDetailCtrl'
        reloadOnSearch:false
        resolve:{
          job:($route, jobService)->jobService.findById $route.current.params.id
        }
      .when '/job-signup-report/:id',
        templateUrl: 'views/job-signup-report.html?v=' + APP_VERSION
        controller: 'JobSignupReportCtrl'
        controllerAs: 'jobSignupReport'
        resolve:{
          job:($route, jobService)->jobService.findById $route.current.params.id
        }
      .when '/job-list',
        templateUrl: 'views/job-list.html?v=' + APP_VERSION
        controller: 'JobListCtrl'
        reloadOnSearch: false
      .when '/job-add',
        templateUrl: 'views/job-admin.html?v=' + APP_VERSION
        controller: 'JobAdminCtrl'
        resolve:{
          job: -> {data:{id:null, name:'', recurrence:{type:'',daysOfWeek:{1:true,2:true,3:true,4:true,5:true}}, timeSlots:[], tasks:[{name:null,description:null,timeSlots:[{signUps:[],needed:1,startTime:moment('8:00:00', 'HH:mm:ss').toDate(),endTime:moment('9:00:00', 'HH:mm:ss').toDate()}]}], categories:[]}}
        }
      .when '/job-admin/:id',
        templateUrl: 'views/job-admin.html?v=' + APP_VERSION
        controller: 'JobAdminCtrl'
        resolve:{
          job:($route, jobService)->jobService.findById($route.current.params.id)
        }
      .when '/admin',
        templateUrl: 'views/admin.html?v=' + APP_VERSION
        controller: 'AdminCtrl'
      .when '/admin/users',
        templateUrl: 'views/admin-users.html?v=' + APP_VERSION
        controller: 'AdminUsersCtrl'
        resolve:{
          allJobs:(jobService)->jobService.allJobs()
          #allUsers:(userService) -> userService.allUsers({max:10000})
        }
      .when '/about',
        templateUrl: 'views/about.html?v=' + APP_VERSION
        controller: 'AboutCtrl'
      .when '/ssb',
        templateUrl: 'views/ssb.html?v=' + APP_VERSION
        controller: 'SsbCtrl'
      .when '/admin/addIndividualTime',
        templateUrl: 'views/admin-addindividualtime.html?v=' + APP_VERSION
        controller: 'AdminAddindividualtimeCtrl'
        resolve:{
          users:->users
        }

      .when '/admin/signups',
        templateUrl: 'views/admin-signups.html?v=' + APP_VERSION
        controller: 'AdminSignupsCtrl'
      .when '/about',
        templateUrl: 'views/about.html?v=' + APP_VERSION
        controller: 'AboutCtrl'
      .when '/not-logged-in',
        templateUrl: 'views/not-logged-in.html?v=' + APP_VERSION
        controller: 'NotLoggedInCtrl'
      .when '/admin/users/:id',
        templateUrl: 'views/admin-user-edit.html?v=' + APP_VERSION
        controller: 'AdminUserEditCtrl'
        resolve: {
          user: ($route, userService) -> userService.findById($route.current.params.id)
        }
      .when '/bug-report',
        templateUrl: 'views/bug-report.html?v=' + APP_VERSION
        controller: 'BugReportCtrl'
        controllerAs: 'bugReport'
      .when '/admin/groups',
        templateUrl: 'views/groups.html?v=' + APP_VERSION
        controller: 'GroupsCtrl'
        controllerAs: 'groups'
        resolve: {
          groups: (groupService) -> groupService.findMyGroups()
        }
      .when '/admin/groups/:id',
        templateUrl: 'views/groups-detail.html?v=' + APP_VERSION
        controller: 'GroupsDetailCtrl'
        controllerAs: 'groupsDetail'
        resolve:{
          group: ($route, groupService) -> groupService.findById($route.current.params.id)
        }
      .when '/signup-list',
        templateUrl: 'views/signup-list.html?v=' + APP_VERSION
        controller: 'SignupListCtrl'
        controllerAs: 'signupList'
      .when '/profile-edit',
        templateUrl: 'views/profile-edit.html?v=' + APP_VERSION
        controller: 'ProfileEditCtrl'
        controllerAs: 'profileEdit'
      .when '/admin/volunteer-roundup',
        templateUrl: 'views/admin-volunteer-roundup.html?v=' + APP_VERSION
        controller: 'AdminVolunteerRoundupCtrl'
        controllerAs: 'adminVolunteerRoundup'
      .otherwise
        redirectTo: '/'


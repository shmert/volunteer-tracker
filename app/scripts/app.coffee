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
          job: -> {data:{id:null, name:'New Job', recurrence:{type:''}, timeSlots:[], tasks:[], categories:[]}}
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
      .otherwise
        redirectTo: '/'


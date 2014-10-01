'use strict'

dummyJobs = []

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
    'ngSanitize'
  ])
  .run ($rootScope) -> 
    $rootScope.user = JSON.parse(localStorage.getItem('user') ) || {id:1,fullName:'Admin Person'}
    dummyJobs = JSON.parse(localStorage.getItem('jobs') ) || []

    $rootScope.$on('save', ->
        localStorage.setItem('jobs', JSON.stringify(dummyJobs))
        localStorage.setItem('user', JSON.stringify($rootScope.user))
    )
    $rootScope.$on('su', (event, u) ->
        $rootScope.user = u
        $rootScope.$emit('save')
    )
    $rootScope.$on('resetData', ->
      dummyJobs = [
        {id:0, name:'Fall Festival', date:'2014-09-22', category:'School-wide',recurrence:{type:''},timeSlots:[
          {signUps:[{userId:123,date:'2014-09-22',verified:true},
            {userId:456,date:'2014-09-22',verified:false}],needed:4, startTime:'12:00', endTime:'14:00', name:'Set up tables'}
          {signUps:[{userId:123,date:'2014-09-22',verified:true}],needed:1, startTime:'15:00', endTime:'16:00', name:'Sell raffle tickets'}
          {signUps:[],needed:1, startTime:'16:00', endTime:'17:00', name:'Sell raffle tickets'}
          {signUps:[{userId:456,date:'2014-09-22',verified:true}],needed:1, startTime:'17:00', endTime:'18:00', name:'Sell raffle tickets'}
          {signUps:[],needed:2, startTime:'17:00', endTime:'18:00', name:'Clear away tables'}
        ]}
        {id:1, name:'Chaperone Field Trip', description:'We will be going to the symphony!', date:'2014-10-30', category:'Mizuho Second',recurrence:{type:''},timeSlots:[
          {signUps:[],needed:2, startTime:'7:00', endTime:'13:00', name:'Accompany kids'}
        ]}
        {id:2, name:'Snack', date:'2014-09-22', category:'Mizuho Second',recurrence:{type:'week',endDate:'2015-06-01'},timeSlots:[
          {signUps:[],needed:2, startTime:'7:00', endTime:'9:00', name:'Provide Snack for Mizuho\'s Class'}
        ]}
        {id:3, name:'Change the Calendar', date:'2014-10-01', category:'David\'s Fourth',recurrence:{type:'month',endDate:'2015-06-01'},timeSlots:[
          {signUps:[],needed:1, startTime:'13:00', endTime:'13:30', name:'Flip the calendar to the next page. Tricky, I know'}
        ]}
      ]
      $rootScope.user = {id:1,fullName:'Admin Person', admin:true}
      $rootScope.$emit('save')
      alert('Data has been reset. Reload the page to refresh the display.')
    )
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        resolve:{
          allJobs:->dummyJobs
        }
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
      .when '/job-detail/:id',
        templateUrl: 'views/job-detail.html'
        controller: 'JobDetailCtrl'
        resolve:{
          job:($route)->dummyJobs[$route.current.params.id]
        }
      .when '/job-list',
        templateUrl: 'views/job-list.html'
        controller: 'JobListCtrl'
        resolve:{
          jobs:->dummyJobs
        }
      .when '/job-add',
        templateUrl: 'views/job-admin.html'
        controller: 'JobAdminCtrl'
        resolve:{
          job:->
            dummyJobs.push(newJob = {id:dummyJobs.length,name:'New Job', recurrence:{type:''}, timeSlots:[]})
            return newJob
        }
      .when '/job-admin/:id',
        templateUrl: 'views/job-admin.html'
        controller: 'JobAdminCtrl'
        resolve:{
          job:($route)->dummyJobs[$route.current.params.id]
        }
      .when '/admin',
        templateUrl: 'views/admin.html'
        controller: 'AdminCtrl'
      .otherwise
        redirectTo: '/'


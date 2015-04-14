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
    $rootScope.user = JSON.parse(localStorage.getItem('user') ) || {id:1,fullName:'Admin Person'}
    jobService.setAllJobs( JSON.parse(localStorage.getItem('jobs') ) || [] )
    users = JSON.parse(localStorage.getItem('users') ) || []

    $rootScope.$on('save', ->
        localStorage.setItem('jobs', JSON.stringify(jobService.allJobs()))
        localStorage.setItem('users', JSON.stringify(users))
        localStorage.setItem('user', JSON.stringify($rootScope.user))
    )
    $rootScope.$on('su', (event, u) ->
        $rootScope.user = u
        $rootScope.$emit('save')
    )
    $rootScope.$on('resetData', ->
      jobService.setAllJobs [
        {id: 0, name: 'Fall Festival', date: '2015-10-22', categories:[{name: 'School-wide'}], description:'This is a big deal event, the whole school will come together for a fundraiser auction and dinner.', recurrence: {type: ''}, tasks: [
          {id: 1, name: 'Set up tables', description: 'Unfold the tables, move them into position, and set place settings and such.'}
          {id: 2, name: 'Sell Raffle Tickets', description: 'Low-pressure sales environment, selling raffle tickets to people'}
          {id: 3, name: 'Clear away tables', description: ''}
        ], timeSlots: [
          {signUps: [
            {userId: 123, date: '2015-10-22', verified: true},
            {userId: 456, date: '2015-10-22', verified: false}
          ], needed: 4, startTime: '12:00', endTime: '14:00', taskId: 1}
          {signUps: [
            {userId: 53, date: '2015-10-22', verified: true}
          ], needed: 1, startTime: '15:00', endTime: '16:00', taskId: 2}
          {signUps: [
          ], needed: 1, startTime: '16:00', endTime: '17:00', taskId: 2}
          {signUps: [
            {userId: 456, date: '2015-10-22', verified: true}
          ], needed: 1, startTime: '17:00', endTime: '18:00', taskId: 2}
          {signUps: [
          ], needed: 2, startTime: '17:00', endTime: '18:00', taskId: 3}
        ]}
            {id: 1, name: 'Chaperone Field Trip', description: 'We will be going to the symphony!', date: '2015-10-30', categories:[{name: 'Mizuho Second'}], recurrence: {type: ''}, tasks: [
              {id: 4, name: 'Accompany Kids', description: 'Chaperones need to stay with the field trip while the kids do their activity, and will need to blah blah blah'}
            ], timeSlots: [
              {signUps: [
              ], needed: 2, startTime: '7:00', endTime: '13:00', taskId: 4}
            ]}
            {id: 2, name: 'Snack', date: '2014-09-22', categories:[{name: 'Mizuho Second'}], recurrence: {type: 'week', endDate: '2015-06-01'}, tasks: [
              {id: 5, name: 'Provide Snack for Mizuho\'s Class', description: 'Bring healthy snacks for the class week' }
            ], timeSlots: [
              {signUps: [
              ], needed: 2, startTime: '7:00', endTime: '9:00', taskId: 5}
            ]}
            {id: 3, name: 'Change the Calendar', date: '2015-10-01', categories:[{name: 'David\'s Fourth'}], recurrence: {type: 'month', endDate: '2015-06-01'}, tasks: [
              {id: 6, name: 'Flip the calendar to the next page.', description: 'Tricky, I know!'}
            ], timeSlots: [
              {signUps: [
              ], needed: 1, startTime: '13:00', endTime: '13:30', taskId: 6}
            ]}
            {id: 4, name: 'Old Job', date: '2015-09-01', categories:[{name: 'Dummy Data'}], recurrence: {type: ''}, tasks: [
              {id: 7, name: 'This already happened, and nobody signed up', description: null}
            ], timeSlots: [
              {signUps: [
                {userId: 123, date: '2015-09-01', verified: true}
              ], needed: 1, startTime: '13:00', endTime: '13:30', taskId: 7}
            ]}
            {
              id: 4,
              name: 'Completely Booked Job',
              date: '2015-11-11',
              categories:[{name: 'Dummy Data'}],
              recurrence: {type: ''},
              tasks: [
                {id: 8, name: 'This dummy job is all signed up, but is in the future so users can see it', description: 'Prevent people from knocking down Arthur Dent\'s house'}
              ],
              timeSlots: [
                {signUps: [
                  {userId: 123, date: '2015-11-11', verified: false}
                ], needed: 1, startTime: '13:00', endTime: '14:00', taskId: 8}
              ]
            }
            {
              id: 5,
              name: 'Miscellaneous 2015?',
              date: '2015-11-11',
              categories:[{name: 'Miscellaneous'}],
              recurrence: {type: ''},
              tasks: [
                {id: 9, name: 'Random volunteer time can be linked to this job without creating a new job', description: ''}
              ],
              timeSlots: [
              ]
            }
      ]
      users = [
        {id: 1, fullName: 'Admin Person', admin:true, linkedUsers:{}, targetHours:0}
        {id: 123, fullName: 'Wendy Three', linkedUsers:{53:true}, targetHours:40}
        {id: 53, fullName: 'Fitz Three', linkedUsers:{123:true}, targetHours:40}
        {id: 42, fullName: 'Ford E. Tou', linkedUsers:{}, targetHours:20}
        {id: 456, fullName: 'Lonesome Lou', linkedUsers:{}, targetHours:20}
      ]

      $rootScope.user = users[0]
      $rootScope.$emit('save')
      alert('Data has been reset. Reload the page to refresh the display.')
    )
  .config ($routeProvider, $httpProvider) ->
    $httpProvider.defaults.withCredentials = true;

    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        resolve:{
          users:->users
          allJobs:(jobService)->jobService.allJobs()
        }
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
      .when '/job-detail/:id',
        templateUrl: 'views/job-detail.html'
        controller: 'JobDetailCtrl'
        resolve:{
          job:($route, jobService)->jobService.findById $route.current.params.id
        }
      .when '/job-list',
        templateUrl: 'views/job-list.html'
        controller: 'JobListCtrl'
        resolve:{
          jobs:(jobService)->jobService.allJobs()
        }
      .when '/job-add',
        templateUrl: 'views/job-admin.html'
        controller: 'JobAdminCtrl'
        resolve:{
          job:(jobService)->
            jobService.push(newJob = {id:jobService.allJobs().length,name:'New Job', recurrence:{type:''}, timeSlots:[], tasks:[]})
            return newJob
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
          users:->users
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
      .otherwise
        redirectTo: '/'


var Naanal= angular.module('Naanal', ['ui.router', 'slick', 'NaanalControllers', 'ngMap']);

 Naanal.config(function($stateProvider, $urlRouterProvider){
      
      // For any unmatched url, send to /route1
      $urlRouterProvider.otherwise("/");
      
      $stateProvider
		.state('index', {
		    url: "/",
		    templateUrl: "views/home.html",
		    controller: 'HomePageController'
		})
		.state('vdi', {
		  url: "/solutions/VirtualDesktopInfrastructure",
		  templateUrl: "views/solutions/vdi.html"
		})
		.state('devops', {
		  url: "/solutions/devops",
		  templateUrl: "views/solutions/devops.html"
		})
		.state('bigdata', {
		  url: "/solutions/bigdata",
		  templateUrl: "views/solutions/bigdata.html"
		})
		.state('vcl', {
		  url: "/solutions/VirtualComputingLab",
		  templateUrl: "views/solutions/vcl.html"
		})
		.state('hpc', {
		  url: "/solutions/HighPerformanceCluster",
		  templateUrl: "views/solutions/hpc.html"
		})
		.state('iot', {
		  url: "/solutions/InternetOfThings",
		  templateUrl: "views/solutions/iot.html"
		})
		.state('applications', {
		  url: "/applications",
		  templateUrl: "views/applications/applications.html"
		})
		.state('aboutus', {
		  url: "/company/aboutus",
		  templateUrl: "views/company/about.html"
		})
		.state('careers', {
		  url: "/company/careers",
		  templateUrl: "views/company/careers.html"
		})
		.state('demo', {
		  url: "/demo",
		  templateUrl: "views/demos/demo.html"
		})
    })
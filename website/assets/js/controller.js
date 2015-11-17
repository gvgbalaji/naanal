var NaanalControllers=angular.module('NaanalControllers', []);
NaanalControllers.controller('HomePageController', function($scope){
 	
 

});

NaanalControllers.controller('demoCtrl', function($scope, $http){
   $http.get("assets/data/demovideos.json")
    .success(function(response) 
      {$scope.videoData = response.demovideos;
        console.log(response);
      }
    );
});
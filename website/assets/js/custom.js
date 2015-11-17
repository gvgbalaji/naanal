 /** Script for Navigation Resize on scroll**/
		$(function(){
			$('.navbar').data('size','big');
		});

		$(window).scroll(function(){
			if($(document).scrollTop() > 100)
			{
				 if ($(window).width() >= 750) {
				 	$(".navbar-default").css({"margin-top":"0px"});
					if($('.navbar').data('size') == 'big')
					{
						$('.navbar').data('size','small');
						$('.navbar').stop().animate({
							height:'30px'
						},600);
						$(".navbar-header").css({"padding-top": "8px"});
						$(".navbar-collapse").css({"padding-top": "8px"});
						$(".navbar-nav > li > a").css({"padding-top": "5px"});
						$(".navbar-nav > li > a").css({"padding-bottom": "5px"});
						$(".navbar-brand").css({"padding": "5px 15px"});
						}
				}
			}
			else
			{
				if ($(window).width() >= 750) {
				$(".navbar-default").css({"margin-top":"0px"});
				if($('.navbar').data('size') == 'small')
				{
					$('.navbar').data('size','big');
					$('.navbar').stop().animate({
						height:'70px'
					},600);
					 
						$(".navbar-header").css({"padding-top": "10px"});
						$(".navbar-collapse").css({"padding-top": "10px"});
						$(".navbar-nav > li > a").css({"padding-top": "8px"});
						$(".navbar-nav > li > a").css({"padding-bottom": "8px"});
						$(".navbar-brand").css({"padding": "15px 15px"});
					}
				}  
			}
		});
/** End of Script for Navigation Resize on scroll **/


(function (ng) {
  'use strict';

  var app = ng.module('ngLoadScript', []);

  app.directive('script', function() {
    return {
      restrict: 'E',
      scope: false,
      link: function(scope, elem, attr) {
        if (attr.type === 'text/javascript-lazy') {
          var code = elem.text();
          var f = new Function(code);
          f();
        }
      }
    };
  });

}(angular));


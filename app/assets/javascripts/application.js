// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.cookie
//= require jquery.ui.all
//= require turbolinks
//= require_tree .
//= require default/loader
//= require default/bootswatch

var ready = function () {
	//$('body').scrollspy({ target: '.nav-search' });

	$('body').css("padding-top",$('nav.navbar').height() + 20);
	$(window).resize(function() {
		$('body').css("padding-top",$('nav.navbar').height() + 20);
	});

    $('a.inner-link[href^=#]').click(function(){
        var speed = 500;
        var href= $(this).attr("href");
        var target = $(href == "#" || href == "" ? 'html' : href);
        var position = target.offset().top - $('nav.navbar').height();
        $("html, body").animate({scrollTop:position}, speed, "swing");
    });
}
$(document).ready(ready)
$(document).on('page:load', ready)

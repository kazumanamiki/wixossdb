var ready = function() {
	var box = $('#card-price');
	box.hide();

	$('a.card-p').click(function() {
		id = $(this).attr('data-id');
		$('#card-price .item').remove();
		$.getJSON("/cards/"+id+"/price", function(data){
			$.each(data, function(){
				$('#card-price .items').append('<div class="item"><h3><a href="'+this['url']+'" target="_blank">'+this['name']+'</a><span>'+this['price']+'円</span></h3></div>');
			});

			box.fadeIn();
		});
	});

	$('#card-price .close-btn').click(function(){
		box.fadeOut();
	});
}
$(document).ready(ready)
$(document).on('page:load', ready)

	
jQuery(document).ready(function ($) { 
	$('#send').click(function(){ 
		$('.error').fadeOut('slow'); 

		var error = false; 

		var name = $('input#name').val();
		if(name == "" || name == " ") {
			//$('#err-name').fadeIn('slow');
			alert("Забыли указать имя(")
			error = true; 
		}

		$.ajax({
			type: "POST",
			url: $('#ajax-form').attr('action'),
			data: $('#ajax-form').serialize(),
			timeout: 6000,
			error: function(request, error) {
				if (error == "timeout")
					alert("При отправки сообщения возникла ошибка");
				else
					alert("Ошибка: "+error);
			},
			success: function() {
			    $('#ajax-form')[0].reset();
					alert("Сообщение отправлено!");
			}
		});

		return false; 
	});
});

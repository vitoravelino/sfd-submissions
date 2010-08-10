$(document).ready(function() {

	$('.participant_check').click(function() {
		$.post('/admin/participant/' + $(this).id, {checked: $(this).val()});
	});

	$('.proposal_check').click(function() {
		alert('213');
		$.post('/admin/proposal/' + $(this).id, {checked: $(this).val()});
	});

});

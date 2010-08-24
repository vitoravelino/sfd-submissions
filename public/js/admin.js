$(document).ready(function() {
	
	$(".proposal_check").addClass("lala");

	$(".participant_check").change(function() {
		alert('1');
		//$.post('/admin/participant/' + $(this).id, {checked: $(this).val()})
	});

	$(".proposal_check").change(function() {
		alert('2');
		//$.post('/admin/proposal/' + $(this).id, {checked: $(this).val()})
	});

});

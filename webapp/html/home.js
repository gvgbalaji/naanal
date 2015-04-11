//Defaults
function selectall(group, select_btn) {

	var checkboxes = document.getElementsByName('group');
	var button = document.getElementById('selectall');

	if (group !== undefined && button !== undefined) {

		var checkboxes = document.getElementsByName(group);
		var button = document.getElementById(select_btn);

	}

	if (button.value == 'select') {
		for (var i in checkboxes) {
			checkboxes[i].checked = '';
		}
		button.value = 'deselect'
	} else {
		for (var i in checkboxes) {
			checkboxes[i].checked = 'FALSE';
		}
		button.value = 'select';
	}
}

function delconf(a, b, c, d, e, f) {
	$("#dialog-confirm").dialog({
		resizable : false,
		height : 250,
		width : 400,
		modal : true,
		buttons : {
			"OK" : function() {
				//$(this).dialog("close");
				a(b, c, d, e, f);
				$(this).dialog("close");
			},
			Cancel : function() {
				$(this).dialog("close");
			}
		}
	});

}




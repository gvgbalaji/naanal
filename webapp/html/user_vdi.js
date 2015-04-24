function user_action(fn) {

	if (window.XMLHttpRequest) {
		var xhr = new XMLHttpRequest();
	} else {
		var xhr = new ActiveXObject("Microsoft.XMLHTTP");
	}
	if (fn === 'start' || fn === 'stop' || "reboot") {
		ins = document.getElementById("ifr").src;
		uri = "user_action.php?fn=" + fn + "&ins=" + ins;
		xhr.onreadystatechange = function() {
			if (xhr.readyState == 4 && xhr.status == 200) {
				document.getElementById("in_table").innerHTML = xhr.responseText;
				if (fn === 'reboot') {
					setTimeout(ref, 10000);
				}

			}
		}
		xhr.open("GET", uri, true);
		xhr.send();
	}

}

function ref() {
	ifr = document.getElementById("ifr");
	ifr.src = ifr.src;

}

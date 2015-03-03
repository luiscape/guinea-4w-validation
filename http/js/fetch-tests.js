// fetch-tests.js
d3.json("test_results.json",
	function(error, json) {
	if (error) { console.log("There was an error."); }
	else {
		console.log(json);

		// For each test.
		for (i = 0; i < json["success"].length; i++) {
			var doc = document.getElementById('tests-container');
			var success_icon = "<div class='col-md-2' style='text-align:right;'><span class='fui-check-circle' style='color:green;'></span></div>";
			var failure_icon = "<div class='col-md-2' style='text-align:right;'><span class='fui-cross-circle' style='color:red;'></span></div>";

			// selecting icon
			if (json["success"][i]) {
			   doc.innerHTML += "<div class='col-md-10'><span>" + json["name"][i] + '</span>' + '</div>' + success_icon + '<br>';
			}
			else {
				doc.innerHTML += "<div class='col-md-10'><span>" + json["name"][i] + '</span>' + '</div>' + failure_icon + '<br>';
			};

		};
	};
});
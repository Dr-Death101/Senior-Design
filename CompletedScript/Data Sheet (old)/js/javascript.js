//Generate all of the tables using the addElement function
document.body.onload = addElement(versionData, "version-data", "Application Version", versionHighlight);
document.body.onload = addElement(driveData, "drive-data", "Drive Space", driveHighlight);
document.body.onload = addElement(ipData, "ip-data", "IP Addresses", noHighlight);
document.body.onload = addElement(osData, "os-data", "OS Version", noHighlight);
document.body.onload = addElement(memoryData, "memory-data", "Memory Usage", memoryHighlight);
document.body.onload = addElement(timeData, "time-data", "Server Time", timeHighlight);
document.body.onload = addElement(processData, "processes-data", "Server Processes", noHighlight);
document.body.onload = addElement(servicesData, "services-data", "Server Services", servicesHighlight);


function versionHighlight (data, keys) {
	//make an array for the table rows return
	var rows = [];
	//Get each row of the data
	data.forEach(function(d){
		//Make a table row element
		tableRow = document.createElement("tr");
		//Get each cell of the data
		keys.forEach(function(key){
			//Make a table data element
			var tableData = document.createElement("td");
			//Fill the table data element
			var dataText = document.createTextNode(d[key]);
			//Add text and cells
			tableData.appendChild(dataText);
			tableRow.appendChild(tableData);
		});
		//Add the row data to the array of rows
		rows.push(tableRow);
	});
	//Return the array of rows
	return rows;
}

function driveHighlight (data, keys) {
	//make an array for the table rows return
	var rows = [];
	//Get each row of the data
	data.forEach(function(d){
		//Make a table row element
		tableRow = document.createElement("tr");
		
		//Highlighting comparison
		if(+d["Free"] < 5){
			tableRow.className = "red-highlight";
		}
		
		//Get each cell of the data
		keys.forEach(function(key){
			//Make a table data element
			var tableData = document.createElement("td");
			//Fill the table data element
			var dataText = document.createTextNode(d[key]);
			//Add text and cells
			tableData.appendChild(dataText);
			tableRow.appendChild(tableData);
		});
		//Add the row data to the array of rows
		rows.push(tableRow);
	});
	//Return the array of rows
	return rows;
}

function memoryHighlight (data, keys) {
	//make an array for the table rows return
	var rows = [];
	//Get each row of the data
	data.forEach(function(d){
		//Make a table row element
		tableRow = document.createElement("tr");
		
		//Highlighting comparison
		if(+d["PctFree"] < 5){
			tableRow.className = "red-highlight";
		}
		
		//Get each cell of the data
		keys.forEach(function(key){
			//Make a table data element
			var tableData = document.createElement("td");
			//Fill the table data element
			var dataText = document.createTextNode(d[key]);
			//Add text and cells
			tableData.appendChild(dataText);
			tableRow.appendChild(tableData);
		});
		//Add the row data to the array of rows
		rows.push(tableRow);
	});
	//Return the array of rows
	return rows;
}

function timeHighlight (data, keys) {
	//make an array for the table rows return
	var rows = [];
	var serverData = data[0];
	//Get each row of the data
	data.forEach(function(d){
		//Make a table row element
		tableRow = document.createElement("tr");
		
		//Highlighting comparison
		if(serverData["StandardTimeZone"] != d["StandardTimeZone"]) {
			tableRow.className = "red-highlight";
		}
		if(serverData["DaylightTimeZone"] != d["DaylightTimeZone"]) {
			tableRow.className = "red-highlight";
		}
		if(Math.abs(serverData["UnixTime"] - d["UnixTime"]) > 120) {
			tableRow.className = "red-highlight";
		}
		
		//Get each cell of the data
		keys.forEach(function(key){
			//Make a table data element
			var tableData = document.createElement("td");
			//Fill the table data element
			var dataText = document.createTextNode(d[key]);
			//Add text and cells
			tableData.appendChild(dataText);
			tableRow.appendChild(tableData);
		});
		//Add the row data to the array of rows
		rows.push(tableRow);
	});
	//Return the array of rows
	return rows;
}

function servicesHighlight (data, keys) {
	//make an array for the table rows return
	var rows = [];
	//Get each row of the data
	data.forEach(function(d){
		//Make a table row element
		tableRow = document.createElement("tr");
		
		//Highlighting comparison
		if((d["StartMode"] == "Auto") && (d["State"] == "Stopped")){
			tableRow.className = "red-highlight";
		}
		
		//Get each cell of the data
		keys.forEach(function(key){
			//Make a table data element
			var tableData = document.createElement("td");
			//Fill the table data element
			var dataText = document.createTextNode(d[key]);
			//Add text and cells
			tableData.appendChild(dataText);
			tableRow.appendChild(tableData);
		});
		//Add the row data to the array of rows
		rows.push(tableRow);
	});
	//Return the array of rows
	return rows;
}

function noHighlight (data, keys){
	//make an array for the table rows return
	var rows = [];
	//Get each row of the data
	data.forEach(function(d){
		//Make a table row element
		tableRow = document.createElement("tr");
		//Get each cell of the data
		keys.forEach(function(key){
			//Make a table data element
			var tableData = document.createElement("td");
			//Fill the table data element
			var dataText = document.createTextNode(d[key]);
			//Add text and cells
			tableData.appendChild(dataText);
			tableRow.appendChild(tableData);
		});
		//Add the row data to the array of rows
		rows.push(tableRow);
	});
	//Return the array of rows
	return rows;
}

//Add the tables to the web page
function addElement (data, id, heading, func) {
	//Get data keys
	var keys = [];
	data.forEach(function(d){
		Object.keys(d).forEach(function(e){
			if(keys.indexOf(e) === -1){
				keys.push(e);
			}
		});
	});
	
	//Create table element
	var table = document.createElement("table");
	//Get the div to add the table into
	var div = document.getElementById(id);
	//Create a table row for the headers
	var tableRow = document.createElement("tr");
	//Add table row into the table
	table.appendChild(tableRow);
	
	//Create table header elements for each key
	keys.forEach(function(d){
		var tableHeader = document.createElement("th");
		var data = document.createTextNode(d);
		tableHeader.appendChild(data);
		tableRow.appendChild(tableHeader);
	});
	
	//Add highlights
	var tableData = func(data, keys);
	
	//Add table data
	tableData.forEach(function(d){
		table.appendChild(d);
	});
	
	//Add header above table
	var header = document.createElement("h2");
	header.appendChild(document.createTextNode(heading));
	
	div.appendChild(header);
	//Add the table into the div
	div.appendChild(table);
}

var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
var viewModel = {
	Workouts : {	
		workouts : ko.observableArray(),
		distance : ko.observable("0.0 km"),
		calories : ko.observable("0.0 kcal"),
		disciplines : ko.observableArray(),
		showDetails : function() {
			viewModel.setWorkoutDetails(this);
		}
	},	
	WorkoutDetails : {
		type : ko.observable(),
		distance : ko.observable(),
		calories : ko.observable(),
		seconds : ko.observable(),
		maxSpeed : ko.observable(),
		minSpeed : ko.observable(),
		geoPoints : ko.observableArray()
	},	
	DisciplineDetails : {
		disciplines : ko.observableArray(),
		monthsData : ko.observableArray(),
		selectedDisc : ko.observable(""),
		showDetails : function() {
			viewModel.toggleChartContainer(this);
			viewModel.setDisciplineDetails(this, viewModel.DisciplineDetails.monthsData);
		}
	},
	setWorkoutDetails : function(workout) {
		this.WorkoutDetails.type(workout.type);
		this.WorkoutDetails.distance(workout.distance);
		this.WorkoutDetails.calories(workout.calories);
		this.WorkoutDetails.seconds(workout.seconds);
		this.WorkoutDetails.maxSpeed(workout.maxSpd);
		this.WorkoutDetails.minSpeed(workout.minSpd);
		this.WorkoutDetails.geoPoints.push(workout.geoPoints);
		initializeMap(workout.locations);
	},
	setDisciplineDetails : function(discipline, monthsData) {
	
		var nowMonth = new Date().getMonth()+1;
		var monthsOffsetted = months.slice(nowMonth);
		monthsOffsetted = monthsOffsetted.concat(months.slice(0,nowMonth));
		
		
		var caloriesValues = [], distanceValues = [], timeValues = [];
		var arrSize = 12;
		while(arrSize--) {
			caloriesValues.push(0);
			distanceValues.push(0);
			timeValues.push(0);
		}
		for(var i = 0; i<monthsData().length; i++) {
			if(monthsData()[i].type==discipline) {
				caloriesValues[monthsData()[i].month] = monthsData()[i].calories;
				distanceValues[monthsData()[i].month] = monthsData()[i].distance;
				timeValues[monthsData()[i].month] = monthsData()[i].seconds;
			}
		}
		
		
		var calVals = caloriesValues.slice(nowMonth);
		calVals = calVals.concat(caloriesValues.slice(0,nowMonth));
		var distVals = distanceValues.slice(nowMonth);
		distVals = distVals.concat(distanceValues.slice(0,nowMonth));
		var timeVals = timeValues.slice(nowMonth);
		timeVals = timeVals.concat(timeValues.slice(0,nowMonth));
	
		var dataDist = {
			labels: monthsOffsetted,
			datasets: [
				{
					label: "Distance",
					fillColor: "rgba(220,220,220,0.5)",
					strokeColor: "rgba(220,220,220,0.8)",
					highlightFill: "rgba(220,220,220,0.75)",
					highlightStroke: "rgba(220,220,220,1)",
					data: distVals
				}
			]
		};
		var dataCal = {
			labels: monthsOffsetted,
			datasets: [
				{
					label: "Calories",
					fillColor: "rgba(151,187,205,0.5)",
					strokeColor: "rgba(151,187,205,0.8)",
					highlightFill: "rgba(151,187,205,0.75)",
					highlightStroke: "rgba(151,187,205,1)",
					data: calVals
				}
			]
		};
		var dataTime = {
			labels: monthsOffsetted,
			datasets: [
				{
					label: "Time",
					fillColor: "rgba(205,187,151,0.5)",
					strokeColor: "rgba(205,187,151,0.8)",
					highlightFill: "rgba(205,187,151,0.75)",
					highlightStroke: "rgba(205,187,151,1)",
					data: timeVals
				}
			]
		};
		loadBarChartData("barChart",dataDist);
		loadBarChartData("barChart2",dataCal);
		loadBarChartData("barChart3",dataTime);
	},
	
	toggleChartContainer : function (discipline) {
		if(viewModel.DisciplineDetails.selectedDisc().trim() == discipline.trim()) {
			$('#barchart-container').slideUp(300);
			viewModel.DisciplineDetails.selectedDisc("");
		} else {
			$('#barchart-container').slideUp(150, function() {
				$('#barchart-container').slideDown(150);
				viewModel.DisciplineDetails.selectedDisc(discipline);
			});
		}
	}
}
function dateDifInMonths(dateRecent, dateOld) {
	var yearDif = dateRecent.getYear()-dateOld.getYear();
	var monthsDif = dateRecent.getMonth() - dateOld.getMonth();
	return yearDif*12 + monthsDif;
}

function loadPieChartData(chart, data) {
	var canvas = document.getElementById(chart);
	var context = canvas.getContext("2d");
    var myPie = new Chart(context).Doughnut(data, {
        labelAlign: 'center'
    });
}

function loadBarChartData(chart, data) {
	var canvas = document.getElementById(chart);
	var context = canvas.getContext("2d");
	var myBarChart = new Chart(context).Bar(data, {
		barShowStroke: false
	});
}

function getRandomColor() {
    var letters = '789ABCDEF'.split('');
    var color = '#';
    for (var i = 0; i < 6; i++ ) {
        color += letters[Math.floor(Math.random() * 9)];
    }
    return color;
}

function initializeMap(geoPoints) {
  if(geoPoints!=null && geoPoints.length>0) {
	  var myLatlng = new google.maps.LatLng(geoPoints[0].latitude,geoPoints[0].longitude);
	  var mapOptions = {
		zoom: 14,
		center: myLatlng
	  }
	  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	  var route = [];
	  
	  for(var i=0;i<geoPoints.length;i++) {
		console.log(geoPoints[i].latitude+" "+geoPoints[i].longitude);
		var point = new google.maps.LatLng(geoPoints[i].latitude,geoPoints[i].longitude);
		route.push(point);
	  }
	  
	  var flightPath = new google.maps.Polyline({
		path: route,
		geodesic: true,
		strokeColor: '#FF0000',
		strokeOpacity: 1.0,
		strokeWeight: 2
	  });

	  flightPath.setMap(map);
	}
 }
 			
var tempData = {
	names : [],
	distances : [],
	calories: [],
	seconds: []
};

$(document).ready(function() {

	$("#workout-details-container").hide();
	$("#barchart-container").hide();
	
    var appId = "JWpJYt1aejnTI3KRdinlEvoMd4GW1Ntgawgjpzyk";
    var jsKey = "cIhobNrilTbLaM1iucB2S7FgO651HYLqDepW3zWT";
    Parse.initialize(appId, jsKey);
	
	var Run = Parse.Object.extend("Run", {
		initialize: function() {},
		toggle: function() {},
	});
		
	ko.applyBindings(viewModel);
	
	function getUserWorkoutsInfo() {
		var query = new Parse.Query(Run);
		query.equalTo("TrackedBy",Parse.User.current());
		query.find({
			success: function(results) {
				var dist=0.0, cal = 0.0;
				var date = new Date();
				for (var i = 0; i < results.length; i++) {
					var newRun = new Run();
					newRun.type = results[i].get("Type").charAt(0).toUpperCase()+results[i].get("Type").slice(1);
					if(results[i].has("Seconds"))
						newRun.seconds = parseFloat(results[i].get("Seconds")).toFixed(0);
					if(results[i].has("Distance"))
						newRun.distance = parseFloat(results[i].get("Distance")/1000).toFixed(3);
					if(results[i].has("Calories"))
						newRun.calories = parseFloat(results[i].get("Calories")).toFixed(0);
					if(results[i].has("Locations"))
						newRun.locations = results[i].get("Locations");
					if(results[i].has("maxSpeed"))
						newRun.maxSpd = parseFloat(results[i].get("maxSpeed")).toFixed(1);
					if(results[i].has("minSpeed"))
						newRun.minSpd = parseFloat(results[i].get("minSpeed")).toFixed(1);
					newRun.createdAt = results[i].createdAt;
					//alert("name:"+newRun.type+" id:"+results[i].id+"\ndistance:"+newRun.distance+" calories:"+newRun.calories+" seconds:"+newRun.seconds);
					viewModel.Workouts.workouts.push(newRun);
					if(viewModel.DisciplineDetails.disciplines().indexOf(newRun.type)<0) {
						viewModel.DisciplineDetails.disciplines.push(newRun.type);
						tempData.names.push(newRun.type);
						tempData.distances.push(newRun.distance);
						tempData.seconds.push(newRun.seconds);
						tempData.calories.push(newRun.calories);
					} else {
						tempData.distances[tempData.names.indexOf(newRun.type)] = parseFloat(tempData.distances[tempData.names.indexOf(newRun.type)]) + parseFloat(newRun.distance);
						tempData.calories[tempData.names.indexOf(newRun.type)] = parseFloat(tempData.calories[tempData.names.indexOf(newRun.type)]) + parseFloat(newRun.calories);
						tempData.seconds[tempData.names.indexOf(newRun.type)] = parseFloat(tempData.seconds[tempData.names.indexOf(newRun.type)]) + parseFloat(newRun.seconds);
					}
					
					if(dateDifInMonths(date,newRun.createdAt)<12) {
						for (var j = 0; j < viewModel.DisciplineDetails.monthsData().length; j++) {
							if (viewModel.DisciplineDetails.monthsData()[j].type === newRun.type && 
								viewModel.DisciplineDetails.monthsData()[j].month === newRun.createdAt.getMonth()) {
								viewModel.DisciplineDetails.monthsData()[j].calories = parseFloat(viewModel.DisciplineDetails.monthsData()[j].calories) + parseFloat(newRun.calories);
								viewModel.DisciplineDetails.monthsData()[j].seconds = parseFloat(viewModel.DisciplineDetails.monthsData()[j].seconds) + parseFloat(newRun.seconds);
								viewModel.DisciplineDetails.monthsData()[j].distance = parseFloat(viewModel.DisciplineDetails.monthsData()[j].distance) + parseFloat(newRun.distance);
								break;
							} 
							if(j==viewModel.DisciplineDetails.monthsData().length-1) {
								viewModel.DisciplineDetails.monthsData().push({
									type:	newRun.type,
									month:	newRun.createdAt.getMonth(),
									calories:	newRun.calories,
									seconds:	newRun.calories,
									distance:	newRun.distance,
								});
							}
						}
						
						if(viewModel.DisciplineDetails.monthsData().length==0) {
								viewModel.DisciplineDetails.monthsData().push({
									type:	newRun.type,
									month:	newRun.createdAt.getMonth(),
									calories:	parseFloat(newRun.calories),
									seconds:	parseFloat(newRun.calories),
									distance:	parseFloat(newRun.distance),
								});
							}
						
					};
					
					dist=parseFloat(dist)+parseFloat(newRun.distance);
					cal=parseFloat(cal)+parseFloat(newRun.calories);
				}
				viewModel.Workouts.distance(dist.toFixed(3)+" km");
				viewModel.Workouts.calories(cal.toFixed(0)+" kcal");
				$('#workouts-table').DataTable({responsive: true});
				
	
				$("tbody tr[role='row']").on('click', function(e) {
					var tr = $(this);
					if(tr.hasClass('active')) {
						$('#workout-details-container').slideUp(300);
					} else {
						tr.siblings('.active').toggleClass('active');
						$('#workout-details-container').slideUp(150, function() {
							$('#workout-details-container').slideDown(150);
						});
					}
					tr.toggleClass('active');
				});
				
				var distancePieData = [], caloriesPieData = [], timePieData = [];
				
				for(var i=0;i<tempData.names.length;i++) {
					distancePieData.push({
						value: parseFloat(tempData.distances[i]).toFixed(2),
						color: getRandomColor(),
						label: tempData.names[i] + " (km) ",
						labelColor: 'white',
						labelFontSize: '20'
					});
					caloriesPieData.push({					
						value: parseFloat(tempData.calories[i]).toFixed(0),
						color: getRandomColor(),
						label: tempData.names[i] + " (kcal) ",
						labelColor: 'white',
						labelFontSize: '20'
					});
					timePieData.push({
						value: parseFloat(tempData.seconds[i]/60).toFixed(0),					
						color: getRandomColor(),
						label: tempData.names[i] + " (min) ",
						labelColor: 'white',
						labelFontSize: '20'
					});
				}
				
				loadPieChartData("myChart",distancePieData);
				loadPieChartData("myChart2",caloriesPieData);
				loadPieChartData("myChart3",timePieData);
				
			},
			error: function(error) {
			}
		});
	}
	
    var loggedIn = false;
	function prepareUserData() {
			var user = Parse.User.current();
			$('#user_edit_form #inputUsername').val(user.get("username"));
			$('#user_edit_form #inputEmail').val(user.get("email"));
	}
		
	var user = Parse.User.current();
	
	if(user!=null) loggedIn = true; else loggedIn=false;
	if(loggedIn) {
		var path = window.location.href;
		var loc = path.substring(path.lastIndexOf('/')+1);
		if(loc==="login.html") {
			window.location.replace("index.html");
		} else {
			var usernameDropdown = document.getElementById('username_dropdown');
			usernameDropdown.innerHTML = "<i class=\"fa fa-user\"></i>  <b class=\"caret\"></b>";
			$("#user_logout").on('click', function(){
				Parse.User.logOut();
				window.location.replace("login.html");
			});
			prepareUserData();
			getUserWorkoutsInfo();
		}
	}
	else {
		var path = window.location.href;
		var loc = path.substring(path.lastIndexOf('/')+1);
		if(loc!=="login.html")
			window.location.replace("login.html");
	} 
    
	
	
    
	$('#login_form').on('submit', function(e) {
		if(!loggedIn) {
			e.preventDefault();
			var inputs = this.getElementsByTagName("input");
			var username = $(inputs[0]).val();
			var password = $(inputs[1]).val();
			user = Parse.User.logIn(username, password, {
				success: function(user) {
					location.reload(true);
				},
				error: function(user, error) {
					alert("Wrong login or password");
					console.log(error);
				}
			});
		}
 
	});
	
	$('#register_form').on('submit', function(e) {
		if(!loggedIn) {
			e.preventDefault();
			var inputs = this.getElementsByTagName("input");
			var username = $(inputs[0]).val();
			var email = $(inputs[1]).val();
			var password = $(inputs[2]).val();
			var password2 = $(inputs[3]).val();
			if(password===password2) {
				var user = new Parse.User();
				user.set("username",username);
				user.set("email",email);
				user.set("password",password);
				user.signUp(null, {
					success: function(user) {
						location.reload(true);
					},
					error: function(user, error) {
						console.log(error);
					}
				});
			} else {
				alert("Hasła nie są jednakowe");
			}
		}
 
	});
	
	$('#user_edit_form').on('submit', function(e) {
		var inputs = this.getElementsByTagName("input");
		var email = $(inputs[0]).val();
		Parse.User.current().set("email",email);
		Parse.User.current().save(null, {
			success: function(user) {
				location.reload(true);
				alert("ok");
			},
			error: function(user, error) {
				console.log(error);
			}
		});
				
	});
	
	$('#facebook-login-btn').on('click', function(e) {
		Parse.FacebookUtils.logIn(null, {
			success: function(user) {
				location.reload(true);
			},
			error: function(user, error) {
			}
		});
	});
	
	
	
	
});
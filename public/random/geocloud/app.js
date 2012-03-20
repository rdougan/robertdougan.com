var map;

var bufferFn = function(fn, interval, scope) {
    var lastCallTime, elapsed, lastArgs, timer, execute = function() {
        fn.apply(scope || this, lastArgs);
        lastCallTime = new Date().getTime();
    };

    return function() {
        elapsed = new Date().getTime() - lastCallTime;
        lastArgs = arguments;

        clearTimeout(timer);
        if (!lastCallTime || (elapsed >= interval)) {
            execute();
        } else {
            timer = setTimeout(execute, interval - elapsed);
        }
    };
};

function initialize() {
    var myOptions = {
        center: new google.maps.LatLng(37.47, -122.12),
        disableDefaultUI: true,
        disableDragging: true,
        zoom: 13,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

    var directionsRenderer = new google.maps.DirectionsRenderer();
    directionsRenderer.setMap(map);
    // directionsRenderer.setPanel(document.getElementById('directionsPanel'));

    // var directionsService = new google.maps.DirectionsService();
    // var request = {
    //     origin: "94063",
    //     destination: "Palo Alto, CA",
    //     travelMode: google.maps.DirectionsTravelMode.DRIVING,
    //     unitSystem: google.maps.DirectionsUnitSystem.METRIC
    //     // provideTripAlternatives: true
    // };
    // directionsService.route(request, function(response, status) {
    //     if (status == google.maps.DirectionsStatus.OK) {
    //         directionsRenderer.setDirections(response);
    //     } else {
    //         alert('Error: ' + status);
    //     }
    // });

    // var myLatlng = new google.maps.LatLng(37.47, -122.12);

    // var marker = new google.maps.Marker({
    //     position: myLatlng,
    //     map: map
    // });
    //
    var directionsService = new google.maps.DirectionsService(),
        directionsDisplay = new google.maps.DirectionsRenderer({
            preserveViewport: true
        });

    directionsDisplay.setMap(map);

    var firstLatLng;

    var getLatLngForAxis = function(x, y) {
        var bounds = map.getBounds(),
            ne = bounds.getNorthEast(),
            sw = bounds.getSouthWest(),
            left = ne.Va,
            right = sw.Va,
            top = ne.Ua,
            bottom = sw.Ua,
            maxX = right - left,
            maxY = bottom - top,
            windowWidth = window.innerWidth,
            windowHeight = window.innerHeight,
            percentX = (x / windowWidth),
            percentY = (y / windowHeight),
            newX = right - (maxX * percentX),
            newY = top + (maxY * percentY),
            latlng = new google.maps.LatLng(newY, newX);

        if (!firstLatLng) {
            firstLatLng = latlng;
        }



        // marker.setPosition(new google.maps.LatLng(newY, newX));
        //
        var request = {
            origin: firstLatLng,
            destination: new google.maps.LatLng(newY, newX),
            // waypoints: waypts,
            optimizeWaypoints: false,
            travelMode: google.maps.DirectionsTravelMode.DRIVING
        };
        directionsService.route(request, function(response, status) {
            if (status == google.maps.DirectionsStatus.OK) {
                directionsDisplay.setDirections(response);
                var route = response.routes[0];

                console.log(route);

                // For each route, display summary information.
                // for (var i = 0; i < route.legs.length; i++) {
                //     var routeSegment = i + 1;
                //     summaryPanel.innerHTML += "<b>Route Segment: " + routeSegment + "</b><br />";
                //     summaryPanel.innerHTML += route.legs[i].start_address + " to ";
                //     summaryPanel.innerHTML += route.legs[i].end_address + "<br />";
                //     summaryPanel.innerHTML += route.legs[i].distance.text + "<br /><br />";
                // }
            }
        });
    };

    var onDrag = function(event) {
        var x = event.pageX,
            y = event.pageY;

        getLatLngForAxis(x, y);
    };

    onDrag = bufferFn(onDrag, 300, this);

    // Touch events
    var dragging = false;
    document.addEventListener('mousedown', function(event) {
        dragging = true;
    }, false);
    document.addEventListener('mouseup', function(event) {
        dragging = false;
    }, false);
    document.addEventListener('mousemove', function(event) {
        if (dragging) {
            onDrag(event);
        }
    }, false);
}

window.onload = initialize;

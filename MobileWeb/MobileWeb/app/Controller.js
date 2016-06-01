var Conference = Conference || {};

Conference.controller = (function ($, dataContext, document) {
  "use strict";

  var position = null;
  var vlist = [];
  var mapDisplayed = false;
  var currentMapWidth = 0;
  var currentMapHeight = 0;
  var sessionsListSelector = "#sessions-list-content";
  var noSessionsCachedMsg = "<div>Your sessions list is empty.</div>";
  var databaseNotInitialisedMsg = "<div>Your browser does not support local databases.</div>";
  var mapScript = '<script src="http://maps.googleapis.com/maps/api/js"></script>';

  var TECHNICAL_SESSION = "Technical";
  var SESSIONS_LIST_PAGE_ID = "sessions";
  var MAP_PAGE = "map";

  // This changes the behaviour of the anchor <a> link
  // so that when we click an anchor link we change page without
  // updating the browser's history stack (changeHash: false).
  // We also don't want the usual page transition effect but
  // rather to have no transition (i.e. tabbed behaviour)
  var initialisePage = function (event) {
    change_page_back_history();
  };

  var onPageChange = function (event, data) {
    // Find the id of the page
    var toPageId = data.toPage.attr("id");

    // If we're about to display the map tab (page) then
    // if not already displayed then display, else if
    // displayed and window dimensions changed then redisplay
    // with new dimensions
    switch (toPageId) {
      case SESSIONS_LIST_PAGE_ID:
      dataContext.processSessionsList(renderSessionsList);
      break;
      case MAP_PAGE:
      dataContext.processVenuesList(renderVenuesList);
      if (!mapDisplayed || (currentMapWidth != get_map_width() ||
      currentMapHeight != get_map_height())) {
        deal_with_geolocation();
      }
      break;
    }
  };

  var renderVenuesList = function (tx, venuesList) {
    vlist = null;
    vlist = venuesList.rows;
  };

  var renderSessionsList = function (tx, sessionsList) {
    var d = $('#sessions-list-content');
    var list = [];

    if (sessionsList.rows.length > 0){
      $('#newList').remove();
      list = sessionsList;
      d.append( '<ul id="newList"'+ 'data-role="listview"' + 'class="ui-listview"' + 'data-filter="true"' + 'data-input="#myFilter">' + '</ul>');
      for (var cnt = 0; cnt < list.rows.length; cnt++) {
        $("#newList").append(
          '<li><a href="" class="ui-btn ui-btn-icon-right ui-icon-carat-r">' +
          '<div class="session-list-item">' +
          '<h3>' + list.rows.item(cnt).title +  '</h3>' +
          '<div>'+
          '<h6>' + list.rows.item(cnt).type + '</h6>' +
          '<h6>' + list.rows.item(cnt).starttime +
          ' - ' +  list.rows.item(cnt).endtime + '</h6>' +
          '</div></div></a></li>');
        }
      } else {
        d.append(noSessionsCachedMsg);
      }
      // This is where you do the work to build the HTML ul list
      // based on the data you've received from DataContext.js (it
      // calls this method with the list of data)
      // Here are some things you need to do:
      // o Obtain a reference to #sessions-list-content element
      // o If the sessionsList is empty append a div with an error message to the page
      // o Create the <ul> element using jQuery commands and append to the sessions section
      // o Loop through the sessionsList data building up an appropriate set of <li>
      // elements. See how we do this in the worksheet version that hard-codes the
      // session data in index.html
      // o Append the list items to the <ul> element created earlier. Hint: building
      // up an array and then converting to a string with join before appending
      // would help.
      // o You will need to refresh JQM by calling listview function
      // **ENTER CODE HERE**

    };

    var noDataDisplay = function (event, data) {
      var view = $(sessionsListSelector);
      view.empty();
      $(databaseNotInitialisedMsg).appendTo(view);
    }

    var change_page_back_history = function () {
      var tab = $('a[data-role="tab"]');
      tab.each(function () {
        var anchor = $(this);
        var clicks = 0;
        anchor.bind("plotclick", function (event, pos, item) {
          if(item) {
            clicks ++;
            if(clicks == 1)  {
              $.mobile.changePage(anchor.attr("href"), { // Go to the URL
                transition: null,
                changeHash: false
              });
              clicks = 0;
              return false;
            } else {
              clicks = 0;
              return false;
            }
          }
        });
      });
    };

    var deal_with_geolocation = function () {
      var phoneGapApp = (document.URL.indexOf('http://') === -1 && document.URL.indexOf('https://') === -1 );
      if (navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/)) {
        // Running on a mobile. Will have to add to this list for other mobiles.
        // We need the above because the deviceready event is a phonegap event and
        // if we have access to PhoneGap we want to wait until it is ready before
        // initialising geolocation services
        if (phoneGapApp) {
          //alert('Running as PhoneGapp app');
          document.addEventListener("deviceready", initiate_geolocation, false);
        }
        else {
          initiate_geolocation(); // Directly from the mobile browser
        }
      } else {
        //alert('Running as desktop browser app');
        initiate_geolocation(); // Directly from the browser
      }
    };

    var initiate_geolocation = function () {

      // Do we have built-in support for geolocation (either native browser or phonegap)?
      if (navigator.geolocation) {
        /*
        var script = document.createElement("script");
        script.type = "text/javascript";
        script.src = "https://maps.googleapis.com/maps/api/js";
        document.body.appendChild(script);
        */

        navigator.geolocation.getCurrentPosition(handle_geolocation_query, handle_errors);
      }
      else {
          // We don't so let's try a polyfill
          yqlgeo.get('visitor', normalize_yql_response);
        }
      };

      var handle_errors = function (error) {
        switch (error.code) {
          case error.PERMISSION_DENIED:
          alert("user did not share geolocation data");
          break;

          case error.POSITION_UNAVAILABLE:
          alert("could not detect current position");
          break;

          case error.TIMEOUT:
          alert("retrieving position timed out");
          break;

          default:
          alert("unknown error");
          break;
        }
      };

      var normalize_yql_response = function (response) {
        if (response.error) {
          var error = { code: 0 };
          handle_errors(error);
          return;
        }

        position = {
          coords: {
            latitude: response.place.centroid.latitude,
            longitude: response.place.centroid.longitude
          },
          address: {
            city: response.place.locality2.content,
            region: response.place.admin1.content,
            country: response.place.country.content
          }
        };

          handle_geolocation_query(position);
        };

      var get_map_height = function () {
        return $(window).height() - ($('#maptitle').height() + $('#mapfooter').height());
      }

      var get_map_width = function () {
        return $(window).width();
      }


      var handle_geolocation_query = function (pos) {

        position = pos;
        /*
                $('#mapPos').append(mapScript);
        var the_height = get_map_height();
        var the_width = get_map_width();

        var image_url = "http://maps.google.com/maps/api/staticmap?sensor=false&center=" + position.coords.latitude + "," +
        position.coords.longitude + "&zoom=14&size=" +
        the_width + "x" + the_height + "&markers=color:blue|label:S|" +
        position.coords.latitude + ',' + position.coords.longitude;

        $('#map-img').remove();

        jQuery('<img/>', {
        id: 'map-img',
        src: image_url,
        title: 'Google map of my location'
      }).appendTo('#mapPos');

      mapDisplayed = true;
      */
      google.maps.event.addDomListener(window, 'load', my_map_initialize(position));
    };


    function my_map_initialize(position) {

      //      alert(vlist.item(0).latitude);


      var w = get_map_width();
      var h = get_map_height();
      jQuery('<div/>', {
        id: 'googleMap',
        width: w,
        height: h,
      }).appendTo('#mapPos');

      var mapId = document.getElementById("googleMap");

      var myCenter = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
      var mapProp = {
        center: myCenter,
        zoom: 10,
        mapTypeId:google.maps.MapTypeId.ROADMAP
      };
      var marker = new google.maps.Marker({
        position:myCenter,
      });

      var map = new google.maps.Map(mapId,mapProp);
      marker.setMap(map);
      marker.setAnimation(google.maps.Animation.BOUNCE);

      var infowindow = new google.maps.InfoWindow({
        content:"Here you are!"
      });

      google.maps.event.addListener(marker, 'click', function() {
        infowindow.open(map,marker);
        map.setZoom(17);
        map.setCenter(marker.getPosition());
      });
      set_venues_Info(map);
    }

    var set_venues_Info = function (map) {
      var img = {
        url:"mapmaker.png",
        size: new google.maps.Size(20,32)
      }
      for (var i = 0; i < vlist.length; i ++) {
        var center=new google.maps.LatLng(vlist.item(i).latitude, vlist.item(i).longitude);
        var marker = new google.maps.Marker({
          position: center,
          icon: img
        });
        marker.setMap(map);

        var infowindow = new google.maps.InfoWindow({
          content: vlist.item(i).name,
          maxWidth: 75
        });

        infowindow.open(map, marker);
      }
    }

    var init = function () {
      // The pagechange event is fired every time we switch pages or display a page
      // for the first time.
      var d = $(document);
      var databaseInitialised = dataContext.init();
      if (!databaseInitialised) {
        d.on('pagechange', $(document), noDataDisplay);
      }

      // The pagechange event is fired every time we switch pages or display a page
    // for the first time.
      d.on('pagechange', $(document), onPageChange);
      // The pageinit event is fired when jQM loads a new page for the first time into the
      // Document Object Model (DOM). When this happens we want the initialisePage function
      // to be called.
      d.on('pageinit', $(document), initialisePage);
    };


    // Provides a hash of functions that we return to external code so that they
    // know which functions they can call. In this case just init.
    var pub = {
      init: init
    };

    return pub;
  }(jQuery, Conference.dataContext, document));

  // Called when jQuery Mobile is loaded and ready to use.
  $(document).on('mobileinit', $(document), function () {
    Conference.controller.init();
  }
);

<%@ page import="java.sql.*"%>
<%@ page import="java.util.Properties,java.io.InputStream,java.io.FileInputStream,java.util.Scanner,java.io.File" %>

<!DOCTYPE html>
<html lang="en">

<%
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
        response.sendRedirect("login.jsp");
        return;
    }

    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    Integer userID = (Integer) session.getAttribute("userID");

    String db = "team4";
    String user = "root";
    String password = "GymShare";
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../static/home.css">
    <link rel="stylesheet" type="text/css" href="../static/navbar.css">
    <link rel="stylesheet" type="text/css" href="../static/map_search.css">
    <title>Map Search - Gym Share</title>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="home.jsp">Gym Share</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="navbar-title">
                <h1>Map Search</h1>
            </div>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link">Welcome <%= firstName %>!</a></li>
                    <li class="nav-item"> <a class="nav-link" href="guest_settings.jsp"> <i class="fas fa-cog"></i> Settings </a> </li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <button class="back-button" onclick="location.href='guest_dashboard.jsp'">Back to Dashboard</button>
        
        <div class="map-container">
            <div id="map"></div>
        </div>
    </div>

    <script>
        var map;
        var infoWindow;
        
        console.log('Map script loading...');
        
        var gyms = [
            <%
                try {
                    java.sql.Connection con;
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                    String retrieveGyms = "SELECT g.Gym_ID, g.Gym_Name, g.Description, g.Address, g.Price, u.First_Name, u.Last_Name " +
                                         "FROM Gyms g " +
                                         "JOIN Owns o ON g.Gym_ID = o.Gym_ID " +
                                         "JOIN Users u ON o.User_ID = u.User_ID " +
                                         "JOIN Hosts h ON u.User_ID = h.User_ID";
                    
                    System.out.println("Executing query: " + retrieveGyms);
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(retrieveGyms);
                    
                    boolean first = true;
                    int count = 0;
                    while (rs.next()) {
                        count++;
                        if (!first) out.print(",");
                        first = false;
                        
                        int gymId = rs.getInt("Gym_ID");
                        String gymName = rs.getString("Gym_Name");
                        if (gymName != null) {
                            gymName = gymName.replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                        } else {
                            gymName = "";
                        }
                        
                        String description = rs.getString("Description");
                        if (description != null) {
                            description = description.replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                        } else {
                            description = "";
                        }
                        
                        String address = rs.getString("Address");
                        if (address != null) {
                            address = address.replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                        } else {
                            address = "";
                        }
                        
                        String price = rs.getString("Price");
                        if (price == null) price = "0";
                        
                        String hostFirstName = rs.getString("First_Name");
                        String hostLastName = rs.getString("Last_Name");
                        String hostName = "";
                        if (hostFirstName != null && hostLastName != null) {
                            hostName = (hostFirstName + " " + hostLastName).replace("'", "\\'").replace("\"", "\\\"");
                        }
                        
                        out.print("{");
                        out.print("id:" + gymId + ",");
                        out.print("name:\"" + gymName + "\",");
                        out.print("description:\"" + description + "\",");
                        out.print("address:\"" + address + "\",");
                        out.print("price:\"" + price + "\",");
                        out.print("host:\"" + hostName + "\"");
                        out.print("}");
                    }
                    
                    System.out.println("Found " + count + " gyms");
                    rs.close();
                    stmt.close();
                    con.close();
                } catch (SQLException e) {
                    System.out.println("Database error: " + e.getMessage());
                    e.printStackTrace();
                    out.println("/* Database error: " + e.getMessage() + " */");
                }
            %>
        ];

        console.log('Gyms loaded:', gyms);

        function initMap() {
            console.log('initMap called');
            
            var mapDiv = document.getElementById("map");
            if (!mapDiv) {
                console.error('Map div not found!');
                return;
            }
            
            try {
                map = new google.maps.Map(mapDiv, {
                    zoom: 7,
                    center: { lat: 39.8283, lng: -98.5795 },
                    mapTypeControl: true,
                    streetViewControl: false,
                    fullscreenControl: true,
                    zoomControl: true,
                    gestureHandling: 'auto',
                    styles: [
                        {
                            featureType: 'poi',
                            elementType: 'labels',
                            stylers: [{ visibility: 'simplified' }]
                        }
                    ]
                });
                
                console.log('Map created successfully');
                infoWindow = new google.maps.InfoWindow();
                var geocoder = new google.maps.Geocoder();
                
                if (gyms && gyms.length > 0) {
                    console.log('Processing', gyms.length, 'gyms for map markers');
                    var bounds = new google.maps.LatLngBounds();
                    var markersAdded = 0;
                    
                    for (var i = 0; i < gyms.length; i++) {
                        var gym = gyms[i];
                        if (gym && gym.name && gym.address) {
                            (function(currentGym) {
                                geocoder.geocode({ address: currentGym.address }, function(results, status) {
                                    console.log('Geocoding', currentGym.name, '- Status:', status);
                                    
                                    if (status === 'OK' && results[0]) {
                                        var position = results[0].geometry.location;
                                        console.log('Position found for', currentGym.name, ':', position.lat(), position.lng());
                                        
                                        var marker = new google.maps.Marker({
                                            position: position,
                                            map: map,
                                            title: currentGym.name
                                        });
                                        
                                        bounds.extend(position);
                                        markersAdded++;
                                        
                                        var contentString = '<div class="gym-info-window">' +
                                            '<h3>' + currentGym.name + '</h3>' +
                                            '<p><strong>Host:</strong> ' + currentGym.host + '</p>' +
                                            '<p><strong>Address:</strong> ' + currentGym.address + '</p>' +
                                            '<p><strong>Price:</strong> $' + currentGym.price + '/hour</p>' +
                                            '<p><strong>Description:</strong> ' + currentGym.description + '</p>' +
                                            '<button onclick="viewGymDetails(' + currentGym.id + ')" class="gym-details-button">View Details</button>' +
                                            '</div>';
                                        
                                        marker.addListener("click", function() {
                                            infoWindow.setContent(contentString);
                                            infoWindow.open(map, marker);
                                        });
                                        
                                        console.log('Marker added for', currentGym.name, 'Total markers:', markersAdded);
                                        
                                        if (markersAdded === gyms.length) {
                                            console.log('All markers added, fitting bounds');
                                            map.fitBounds(bounds);
                                        }
                                    } else {
                                        console.error('Geocoding failed for', currentGym.name, 'Status:', status);
                                        markersAdded++;
                                        if (markersAdded === gyms.length) {
                                            console.log('All geocoding attempts completed');
                                        }
                                    }
                                });
                            })(gym);
                        }
                    }
                } else {
                    console.log('No gyms to display on map');
                }
            } catch (error) {
                console.error('Error creating map:', error);
                mapDiv.innerHTML = '<div class="error-message">Error loading Google Maps. Falling back to list view.</div>';
                showGymList(mapDiv);
            }
        }
        
        function showGymList(mapDiv) {
            if (gyms && gyms.length > 0) {
                var gymListHtml = '<div class="gym-list-container"><h3>Gyms Found (' + gyms.length + '):</h3>';
                for (var i = 0; i < gyms.length; i++) {
                    var gym = gyms[i];
                    if (gym && gym.name) {
                        gymListHtml += '<div class="gym-card">';
                        gymListHtml += '<h4>' + gym.name + '</h4>';
                        gymListHtml += '<p><strong>Address:</strong> ' + gym.address + '</p>';
                        gymListHtml += '<p><strong>Host:</strong> ' + gym.host + '</p>';
                        gymListHtml += '<p><strong>Price:</strong> $' + gym.price + '/hour</p>';
                        gymListHtml += '<p><strong>Description:</strong> ' + gym.description + '</p>';
                        gymListHtml += '<button onclick="viewGymDetails(' + gym.id + ')" class="gym-details-button">View Details</button>';
                        gymListHtml += '</div>';
                    }
                }
                gymListHtml += '</div>';
                mapDiv.innerHTML = gymListHtml;
            } else {
                mapDiv.innerHTML = '<div class="no-gyms-message">No gyms found in database</div>';
            }
        }

        function viewGymDetails(gymId) {
            window.location.href = "gym_details.jsp?gymID=" + gymId;
        }

    </script>
    
    <%
    String apiKey = "";
    boolean configLoaded = false;
    StringBuilder debugOutput = new StringBuilder();
    
    try {
        String[] possiblePaths = {
            "../WEB-INF/config.properties",
            "WEB-INF/config.properties",
            "./WEB-INF/config.properties",
            "../../WEB-INF/config.properties",
            "../config.properties",
            "config.properties",
            "./config.properties"
        };
        
        debugOutput.append("=== CONFIG LOADING DEBUG ===\\n");
        debugOutput.append("Attempting to load config.properties...\\n");
        
        for (String path : possiblePaths) {
            try {
                File testFile = new File(path);
                debugOutput.append("Trying path: " + path + "\\n");
                debugOutput.append("  Absolute path: " + testFile.getAbsolutePath() + "\\n");
                debugOutput.append("  Exists: " + testFile.exists() + "\\n");
                debugOutput.append("  Can read: " + testFile.canRead() + "\\n");
                
                if (testFile.exists() && testFile.canRead()) {
                    debugOutput.append("  SUCCESS - File found and readable!\\n");
                    Scanner scanner = new Scanner(testFile);
                    while (scanner.hasNextLine()) {
                        String line = scanner.nextLine().trim();
                        if (line.startsWith("GOOGLE_API_KEY=")) {
                            apiKey = line.substring("GOOGLE_API_KEY=".length()).trim();
                            configLoaded = true;
                            debugOutput.append("  API key extracted: " + (apiKey.length() > 10 ? apiKey.substring(0, 10) + "..." : apiKey) + "\\n");
                            break;
                        }
                    }
                    scanner.close();
                    if (configLoaded) {
                        debugOutput.append("  Config loaded successfully from: " + path + "\\n");
                        break;
                    }
                } else {
                    debugOutput.append("  FAILED - File not found or not readable\\n");
                }
            } catch (Exception fileEx) {
                debugOutput.append("  ERROR - Exception: " + fileEx.getMessage() + "\\n");
                continue;
            }
        }
        
        if (!configLoaded || apiKey == null || apiKey.trim().isEmpty()) {
            debugOutput.append("Config file loading failed - using fallback API key\\n");
            apiKey = "AIzaSyA0p3sg1m_1WdxkfDQv9G-jV_OwKqMLeFk";
        }
        
        debugOutput.append("Final API key length: " + apiKey.length() + "\\n");
        debugOutput.append("=== CONFIG LOADING COMPLETE ===");
        
    } catch (Exception e) {
        debugOutput.append("Exception in config loading: " + e.getMessage() + "\\n");
        apiKey = "AIzaSyA0p3sg1m_1WdxkfDQv9G-jV_OwKqMLeFk";
    }
    %>

    <script>
        var apiKey = "<%= apiKey %>";
        var debugOutput = "<%= debugOutput.toString() %>";
        
        console.log('=== CONFIG DEBUG OUTPUT ===');
        console.log(debugOutput);
        
        console.log('API key loaded:', apiKey ? 'Yes (length: ' + apiKey.length + ')' : 'No');
        console.log('API key preview:', apiKey ? apiKey.substring(0, 10) + '...' : 'null');
    </script>
    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDoW7dj15Pfg0RK95HedLxJpBXh-v4rROs&libraries=geometry&callback=initMap">
    </script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, map div exists:', !!document.getElementById('map'));
        });
    </script>

</body>
</html>

<%@ page import="java.sql.*"%>

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
    String user = "root"; //assumes database name is the same as username
    String password = "GymShare"; //Replace with your MySQL password
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" type="image/x-icon" href="../assets/favicon.ico">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../static/home.css">
    <link rel="stylesheet" type="text/css" href="../static/navbar.css">
    <link rel="stylesheet" type="text/css" href="../static/edit_gym.css">
    <title>Edit Gym - Gym Share</title>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
        <div class="container px-5">
            <a class="navbar-brand" href="../home.jsp">Gym Share</a>
            <div class="navbar-title">
                <h1>Edit Gym Information</h1>
            </div>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link">Welcome <%= firstName %>!</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Log Out</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <button class="back-button" onclick="location.href='my_gyms.jsp'">Back</button>
        <div class="header-container">
        </div>

        <%
            String gymName = "";
            String description = "";
            String address = "";
            Double price = 0.0;
            
            String gymIDParam = request.getParameter("gymID");
            int gymID = 0;
            
            if (gymIDParam == null || gymIDParam.trim().isEmpty()) {
                response.sendRedirect("my_gyms.jsp");
                return;
            }
            
            try {
                gymID = Integer.parseInt(gymIDParam.trim());
            } 
            catch (NumberFormatException e) {
                out.println("Error parsing gymID: '" + gymIDParam + "'");
                response.sendRedirect("my_gyms.jsp");
                return;
            }

            try {
                java.sql.Connection con;
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                Statement stmt = con.createStatement();

                String retrieveGym = "SELECT Gym_Name, Description, Address, Price FROM Gyms WHERE Gym_ID = " + gymID;
                ResultSet rsGym = stmt.executeQuery(retrieveGym);

                if (rsGym.next()) {
                    gymName = rsGym.getString("Gym_Name");
                    description = rsGym.getString("Description");
                    address = rsGym.getString("Address");
                    price = rsGym.getDouble("Price");
                }

                rsGym.close();
                stmt.close();
                con.close();
            } 
            catch (SQLException e) {
                e.printStackTrace();
            }
        %>
        
        <div class="tab-container">
            <button class="tab-button active" onclick="showTab(event, 'details')">Details</button>
            <button class="tab-button" onclick="showTab(event, 'machines')">Machines</button>
            <button class="tab-button" onclick="showTab(event, 'photos')">Photos</button>
            <button class="tab-button" onclick="showTab(event, 'features')">Features</button>
        </div>

        <div class="tab-content-container">
            <form action="edit_gym.jsp" method="post">
                <input type="hidden" name="gymID" value="<%= gymID %>">
                <input type="hidden" name="action" value="updateGymDetails">

                <div id="details" class="tab-content active">
                    <h2>Basic Information</h2>

                    <label for="gymName">Gym Name:</label>
                    <input type="text" id="gymName" name="gymName" value="<%= gymName %>" required>

                    <label for="description">Description:</label>
                    <textarea id="description" name="description" required><%= description %></textarea>

                    <label for="address">Address:</label>
                    <input type="text" id="address" name="address" value="<%= address %>" required>

                    <label for="price">Price:</label>
                    <input type="number" id="price" name="price" value="<%= String.format("%.2f", price) %>" required>

                    <button type="submit" class="save-button">Save</button>
                </div>
            </form>

            <div id="machines" class="tab-content">
                <h2>Machines</h2>
                <form action="edit_gym.jsp" method="post">
                    <input type="hidden" name="gymID" value="<%= gymID %>">
                    <input type="hidden" name="action" value="addMachine">

                    <div class="add-machine">
                        <div class="machine-input-row">
                            <div class="input-group">
                                <label for="machineType">Type:</label>
                                <input type="text" id="machineType" name="machineType" required>
                            </div>
                            
                            <div class="input-group">
                                <label for="machineStatus">Status:</label>
                                <select id="machineStatus" name="machineStatus" required>
                                    <option value="Available">Available</option>
                                    <option value="Unavailable">Unavailable</option>
                                </select>
                            </div>

                            <div class="input-group">
                                <button type="submit" class="add-machine-btn" onclick="addMachine()">
                                    <i class="fas fa-plus"></i> Add Machine
                                </button>
                            </div>
                        </div>
                    </div>
                </form>

                <%
                    String machineTypeDisplay = "";
                    String machineStatusDisplay = "";
                    Integer machineNumber = 0;

                    try {
                        java.sql.Connection con;
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                        Statement stmt = con.createStatement();
                        String retrieveMachines = "SELECT Machine_Number, Type, Status FROM Machines WHERE Gym_ID = " + gymID;
                        ResultSet rsMachines = stmt.executeQuery(retrieveMachines);

                        while(rsMachines.next()) {
                            machineNumber = rsMachines.getInt("Machine_Number");
                            machineTypeDisplay = rsMachines.getString("Type");
                            machineStatusDisplay = rsMachines.getString("Status");

                %>

                <div class="edit-machine">
                    <div class="machine-input-row">
                        <div class="input-group">
                            <label for="machineType">Type:</label>
                            <input type="text" id="machineType" name="machineType" value="<%= machineTypeDisplay %>" required>
                        </div>
                        
                        <div class="input-group">
                            <label for="machineStatus">Status:</label>
                            <select id="machineStatus" name="machineStatus" required>
                                <option value="Available" <%= "Available".equals(machineStatusDisplay) ? "selected" : "" %>>Available</option>
                                <option value="Unavailable" <%= "Unavailable".equals(machineStatusDisplay) ? "selected" : "" %>>Unavailable</option>
                            </select>
                        </div>

                        <div class="input-group">
                            <form action="edit_gym.jsp" method="post">
                                <input type="hidden" name="gymID" value="<%= gymID %>">
                                <input type="hidden" name="action" value="deleteMachine">
                                <input type="hidden" name="machineNumber" value="<%= machineNumber %>">
                                <button type="button" class="delete-machine-btn" onclick="deleteMachine(this)">
                                    <i class="fas fa-trash"></i> Delete Machine
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                <%
                        }
                        rsMachines.close();
                        stmt.close();
                        con.close();
                    } 
                    catch (SQLException e) {
                        out.println("SQLException: " + e.getMessage());
                    }
                %>
                <form action="edit_gym.jsp" method="post">
                    <input type="hidden" name="gymID" value="<%= gymID %>">
                    <input type="hidden" name="action" value="saveMachines">
                    <button type="submit" class="save-button" onclick="saveMachines()">Save</button>
                </form>
            </div>

            <div id="photos" class="tab-content">
                <h2>Photos</h2>
                <form action="edit_gym.jsp" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="gymID" value="<%= gymID %>">
                    <input type="hidden" name="action" value="uploadPhotos">
                    <input type="file" name="photo" accept="image/*" required>
                    <button type="submit" class="upload-button" onclick="uploadPhotos()">Upload Photos</button>
                </form>

                <div class="uploaded-photos">
                    <h3>Uploaded Photos:</h3>
                    <div>
                        <%
                            try {
                                java.sql.Connection con;
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                                Statement stmt = con.createStatement();
                                String retrievePhotos = "SELECT Photo_Path " +
                                                            "FROM Photos JOIN Displays USING (Photo_ID) JOIN Gyms USING (Gym_ID) " +
                                                            "WHERE Gym_ID = " + gymID;
                                ResultSet rsPhotos = stmt.executeQuery(retrievePhotos);

                                while(rsPhotos.next()) {
                                    String photoPath = rsPhotos.getString("Photo_Path");
                        %>
                        <img src="../<%= photoPath %>" alt="Gym Photo" class="gym-photo">
                            <%
                                }
                                if (rsPhotos.isClosed()) {
                                    out.println("No photos found");
                                }
                                rsPhotos.close();
                                stmt.close();
                                con.close();
                            } 
                            catch (SQLException e) {
                                out.println("SQLException: " + e.getMessage());
                            }
                            %>
                    </div>
                </div>
            </div>

            <div id="features" class="tab-content">
                <h2>Features</h2>
                <form action="edit_gym.jsp" method="post">
                    <input type="hidden" name="gymID" value="<%= gymID %>">
                    <input type="hidden" name="action" value="addFeature">

                    <div class="add-feature">
                        <div class="machine-input-row">
                            <div class="input-group">
                                <label for="featureName">Feature Name:</label>
                                <input type="text" id="featureName" name="featureName" required>
                            </div>
                            `
                            <div class="input-group">
                                <button type="submit" class="add-feature-btn" onclick="addFeature()">
                                    <i class="fas fa-plus"></i> Add Feature
                                </button>
                            </div>
                        </div>
                    </div>
                </form>

                <%
                    String featureNameDisplay = "";

                    try {
                        java.sql.Connection con;
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                        Statement stmt = con.createStatement();
                        String retrieveFeatures = "SELECT Feature_Name " +
                                                    "FROM Features JOIN Possesses USING (Feature_ID) " +
                                                    "WHERE Gym_ID = " + gymID;
                        ResultSet rsFeatures = stmt.executeQuery(retrieveFeatures);

                        while(rsFeatures.next()) {
                            featureNameDisplay = rsFeatures.getString("Feature_Name");

                %>

                <div class="edit-feature">
                    <div class="feature-input-row">
                        <div class="input-group">
                            <label for="featureName">Name:</label>
                            <input type="text" id="featureName" name="featureName" value="<%= featureNameDisplay %>" required>
                        </div>

                        <div class="input-group">
                            <form action="edit_gym.jsp" method="post">
                                <input type="hidden" name="action" value="deleteFeature">
                                <input type="hidden" name="gymID" value="<%= gymID %>">
                                <input type="hidden" name="featureName" value="<%= featureNameDisplay %>">
                                <button type="submit" class="delete-feature-btn" onclick="deleteFeature(this)">
                                    <i class="fas fa-trash"></i> Delete Feature
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                <%
                        }
                        rsFeatures.close();
                        stmt.close();
                        con.close();
                    } 
                    catch (SQLException e) {
                        out.println("SQLException: " + e.getMessage());
                    }
                %>
            </div>
        </div>
    </div>

    <%
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String action = request.getParameter("action");

            try {
                java.sql.Connection con;
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                Statement stmt = con.createStatement();
                int postGymID = Integer.parseInt(request.getParameter("gymID"));

                if (action.equals("updateGymDetails")) {
                    String updatedGymName = request.getParameter("gymName");
                    String updatedDescription = request.getParameter("description");
                    String updatedAddress = request.getParameter("address");
                    String updatedPrice = request.getParameter("price");

                    String updateGym = "UPDATE Gyms SET Gym_Name = '" + updatedGymName + "', Description = '" + updatedDescription + "', Address = '" + updatedAddress + "', Price = '" + updatedPrice + "' WHERE Gym_ID = " + postGymID;

                    stmt.execute(updateGym);

                    response.sendRedirect("edit_gym.jsp?gymID=" + postGymID + "&tab=details");
                    return;
                } else if (action.equals("addMachine")) {
                    String machineType = request.getParameter("machineType");
                    String machineStatus = request.getParameter("machineStatus");

                    String getMachineNumber = "SELECT IFNULL(MAX(Machine_Number), 0) + 1 AS NextMachineNumber FROM Machines WHERE Gym_ID = " + postGymID;
                    ResultSet rsMachineNumber = stmt.executeQuery(getMachineNumber);
                    if (rsMachineNumber.next()) {
                        machineNumber = rsMachineNumber.getInt("NextMachineNumber");
                    }

                    rsMachineNumber.close();

                    String addMachine = "INSERT INTO Machines (Gym_ID, Machine_Number, Type, Status) VALUES (" + postGymID + ", " + machineNumber + ", '" + machineType + "', '" + machineStatus + "')";
                    stmt.execute(addMachine);
                    
                    response.sendRedirect("edit_gym.jsp?gymID=" + postGymID + "&tab=machines");
                    return;
                } else if (action.equals("deleteMachine")) {
                        int postMachineNumber = Integer.parseInt(request.getParameter("machineNumber"));

                        String deleteMachine = "DELETE FROM Machines WHERE Machine_Number = " + postMachineNumber + " AND Gym_ID = " + postGymID;
                        stmt.execute(deleteMachine);
                        
                        response.sendRedirect("edit_gym.jsp?gymID=" + postGymID + "&tab=machines");
                        return;
                } else if (action.equals("saveMachines")) {
                   

                    response.sendRedirect("edit_gym.jsp?gymID=" + postGymID + "&tab=machines");
                    return;
                } else if (action.equals("addFeature")) {
                    String featureName = request.getParameter("featureName");

                    String retrieveFeatures = "SELECT Feature_ID FROM Features WHERE Feature_Name = '" + featureName + "'";
                    ResultSet rsFeature = stmt.executeQuery(retrieveFeatures);

                    if (rsFeature.next()) {
                        String addPossesses = "INSERT INTO Possesses (Gym_ID, Feature_ID) VALUES (" + postGymID + ", " + rsFeature.getInt("Feature_ID") + ")";
                        stmt.execute(addPossesses);
                    } else {
                        String addFeature = "INSERT INTO Features (Feature_Name) VALUES ('" + featureName + "')";
                        stmt.execute(addFeature);

                        String addPossesses = "INSERT INTO Possesses (Gym_ID, Feature_ID) VALUES (" + postGymID + ", LAST_INSERT_ID())";
                        stmt.execute(addPossesses);
                    }

                    response.sendRedirect("edit_gym.jsp?gymID=" + postGymID + "&tab=features");
                    return;
                } else if (action.equals("deleteFeature")) {
                    String featureName = request.getParameter("featureName");

                    String getFeatureID = "SELECT Feature_ID FROM Features WHERE Feature_Name = '" + featureName + "'";
                    ResultSet rsFeatureID = stmt.executeQuery(getFeatureID);
                    
                    if (rsFeatureID.next()) {
                        int featureID = rsFeatureID.getInt("Feature_ID");
                        
                        String deletePossesses = "DELETE FROM Possesses WHERE Gym_ID = " + postGymID + " AND Feature_ID = " + featureID;
                        stmt.execute(deletePossesses);
                    }
                    rsFeatureID.close();

                    response.sendRedirect("edit_gym.jsp?gymID=" + postGymID + "&tab=features");
                    return;
                } else if (action.equals("uploadPhotos")) {
                    String photoPath = request.getParameter("photos");

                    String retrievePriority = "SELECT Priority FROM Photos WHERE Gym_ID = " + postGymID;
                    ResultSet rsPriority = stmt.executeQuery(retrievePriority);

                    int nextPriority = 1;
                    while (rsPriority.next()) {
                        int priority = rsPriority.getInt("Priority");
                        if (priority >= nextPriority) {
                            nextPriority = priority + 1;
                        }
                    }

                    rsPriority.close();

                    String uploadPhoto = "INSERT INTO Photos (Priority, Photo_Path) VALUES (" + nextPriority + ", '" + photoPath + "')";
                    stmt.execute(uploadPhoto);

                    String uploadDisplays = "INSERT INTO Displays (Gym_ID, Photo_ID) VALUES (" + postGymID + ", LAST_INSERT_ID())";
                    stmt.execute(uploadDisplays);

                    response.sendRedirect("edit_gym.jsp?gymID=" + postGymID + "&tab=photos");
                    return;
                }

                stmt.close();
                con.close();
            }
            catch (SQLException e) {
                out.println("SQLException:" + e.getMessage());
            }
        }
    %>
</body>

<script>
    function showTab(event, tabName) {
        var tabContents = document.getElementsByClassName("tab-content");
        for (var i = 0; i < tabContents.length; i++) {
            tabContents[i].classList.remove("active");
        }

        var tabs = document.getElementsByClassName("tab-button");
        for (var i = 0; i < tabs.length; i++) {
            tabs[i].classList.remove("active");
        }

        document.getElementById(tabName).classList.add("active");
        event.currentTarget.classList.add("active");
    }

    function addMachine() {
        var machineType = document.getElementById("machineType").value;
        var machineStatus = document.getElementById("machineStatus").value;

        if (machineType && machineStatus) {
            alert("Machine added successfully.");
        } else {
            alert("Please fill in all fields.");
        }
    }

    function deleteMachine(machine) {
        if (confirm("Are you sure you want to delete this machine?")) {
            const form = machine.closest('form');
            if (form) {
                form.submit();
            } else {
                alert("Error: Could not find form to submit");
            }
        }
    }

    function updateMachine() {
        var machineType = document.getElementById("machineType").value;
        var machineStatus = document.getElementById("machineStatus").value;

        if (machineType && machineStatus) {
            alert("Machine updated successfully.");
        } else {
            alert("Please fill in all fields.");
        }
    }

    function addFeature() {
        var featureName = document.getElementById("featureName").value;

        if (featureName) {
            alert("Feature added successfully.");
        } else {
            alert("Please fill in the feature name.");
        }
    }

    function deleteFeature(feature) {
        if (confirm("Are you sure you want to delete this feature?")) {
            const form = feature.closest('form');
            if (form) {
                form.submit();
            } else {
                alert("Error: Could not find form to submit");
            }
        }
    }

    function updateFeature() {
        var featureName = document.getElementById("featureName").value;

        if (featureName) {
            alert("Feature updated successfully.");
        } else {
            alert("Please fill in the feature name.");
        }
    }

    function uploadPhotos() {
        const form = document.querySelector('form[enctype="multipart/form-data"]');
        const formData = new FormData(form);

        fetch('upload', {
            method: 'POST',
            body: formData
        })
        .then(response => response.text())
        .then(text => console.log(text))
        .catch(error => console.error(error));
        alert("Photos uploaded successfully.");
    }

    function initializeTabFromURL() {
        const urlParams = new URLSearchParams(window.location.search);
        const tabParam = urlParams.get('tab');
        
        if (tabParam) {
            const tabContents = document.getElementsByClassName("tab-content");
            for (let i = 0; i < tabContents.length; i++) {
                tabContents[i].classList.remove("active");
            }
            
            const tabs = document.getElementsByClassName("tab-button");
            for (let i = 0; i < tabs.length; i++) {
                tabs[i].classList.remove("active");
            }
            
            const targetTab = document.getElementById(tabParam);
            if (targetTab) {
                targetTab.classList.add("active");
                
                const tabButtons = document.querySelectorAll('.tab-button');
                tabButtons.forEach(button => {
                    const onclick = button.getAttribute('onclick');
                    if (onclick && onclick.includes("'" + tabParam + "'")) {
                        button.classList.add('active');
                    }
                });
            }
        }
    }

    window.addEventListener('DOMContentLoaded', function() {
        initializeTabFromURL();
    });

    
</script>
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
            <h1>Edit Gym Information</h1>
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
                                    <option value="Maintenance">Maintenance</option>
                                    <option value="Shipping">Shipping</option>
                                </select>
                            </div>

                            <div class="input-group">
                                <button type="submit" class="add-machine-btn">
                                    <i class="fas fa-plus"></i> Add Machine
                                </button>
                            </div>
                        </div>
                    </div>
                </form>

                <%
                    String machineTypeDisplay = "";
                    String machineStatusDisplay = "";

                    try {
                        java.sql.Connection con;
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                        Statement stmt = con.createStatement();
                        String retrieveMachines = "SELECT Type, Status FROM Machines WHERE Gym_ID = " + gymID;
                        ResultSet rsMachines = stmt.executeQuery(retrieveMachines);

                        while(rsMachines.next()) {
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
                                <option value="Maintenance" <%= "Maintenance".equals(machineStatusDisplay) ? "selected" : "" %>>Maintenance</option>
                                <option value="Shipping" <%= "Shipping".equals(machineStatusDisplay) ? "selected" : "" %>>Shipping</option>
                            </select>
                        </div>

                        <div class="input-group">
                            <button type="button" class="delete-machine-btn" onclick="deleteMachine()">
                                <i class="fas fa-trash"></i> Delete Machine
                            </button>
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
            <button type="submit" class="save-button">Save</button>
            </div>

            <div id="photos" class="tab-content">
                <h2>Photos</h2>
                <p>Upload and manage gym photos here.</p>
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
                                <button type="submit" class="add-feature-btn">
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
                        String retrieveFeatures = "SELECT Feature_Name" +
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
                            <button type="button" class="delete-feature-btn" onclick="deleteFeature()">
                                <i class="fas fa-trash"></i> Delete Feature
                            </button>
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
        if(request.getMethod().equalsIgnoreCase("POST")) {
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

                    stmt.executeUpdate(updateGym);
                    
                    stmt.close();
                    con.close();

                    response.sendRedirect("my_gyms.jsp");
                    return;
                }
                else if (action.equals("addMachine")) {
                    String machineType = request.getParameter("machineType");
                    String machineStatus = request.getParameter("machineStatus");

                    int machineNumber = 1;

                    String getMachineNumber = "SELECT IFNULL(MAX(Machine_Number), 0) + 1 AS NextMachineNumber FROM Machines WHERE Gym_ID = " + postGymID;
                    ResultSet rsMachineNumber = stmt.executeQuery(getMachineNumber);
                    if (rsMachineNumber.next()) {
                        machineNumber = rsMachineNumber.getInt("NextMachineNumber");
                    }

                    rsMachineNumber.close();

                    String addMachine = "INSERT INTO Machines (Gym_ID, Machine_Number, Type, Status) VALUES (" + postGymID + ", " + machineNumber + ", '" + machineType + "', '" + machineStatus + "')";
                    stmt.executeUpdate(addMachine);
                    
                    stmt.close();
                    con.close();
                    
                    response.sendRedirect("edit_gym.jsp?gymID=" + postGymID);
                    return;
                }
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
</script>
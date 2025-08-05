<%@ page import="java.sql.*, java.io.*, java.util.UUID, java.util.List" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
private String getFieldValue(List<FileItem> items, String fieldName) {
    for (FileItem item : items) {
        if (item.isFormField() && fieldName.equals(item.getFieldName())) {
            return item.getString();
        }
    }
    return null;
}

private FileItem getFileItem(List<FileItem> items, String fieldName) {
    for (FileItem item : items) {
        if (!item.isFormField() && fieldName.equals(item.getFieldName())) {
            return item;
        }
    }
    return null;
}
%>

<%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        Connection con = null;
        String redirectURL = "edit_gym.jsp?gymID=1"; 
        
        String user_db = "root";
        String password_db = "GymShare";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user_db, password_db);
            
            String action = null;
            String gymIDStr = null;
            int gymID = 0;
            FileItem photoFile = null;
            
            String contentType = request.getContentType();
            
            if (ServletFileUpload.isMultipartContent(request)) {
                try {
                    DiskFileItemFactory factory = new DiskFileItemFactory();
                    factory.setSizeThreshold(1024 * 1024); 
                    ServletFileUpload upload = new ServletFileUpload(factory);
                    upload.setFileSizeMax(50 * 1024 * 1024); 
                    upload.setSizeMax(50 * 1024 * 1024); 
                    
                    List<FileItem> items = upload.parseRequest(request);
                    
                    action = getFieldValue(items, "action");
                    gymIDStr = getFieldValue(items, "gymID");
                    photoFile = getFileItem(items, "photo");
                    
                    
                } catch (Exception e) {
                    System.out.println("Error parsing multipart form: " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                action = request.getParameter("action");
                gymIDStr = request.getParameter("gymID");
            }
            
            String queryString = request.getQueryString();
            if (queryString != null) {
                if (action == null && queryString.contains("action=")) {
                    int start = queryString.indexOf("action=") + 7;
                    int end = queryString.indexOf("&", start);
                    if (end == -1) end = queryString.length();
                    action = queryString.substring(start, end);
                }
                if (gymIDStr == null && queryString.contains("gymID=")) {
                    int start = queryString.indexOf("gymID=") + 6;
                    int end = queryString.indexOf("&", start);
                    if (end == -1) end = queryString.length();
                    gymIDStr = queryString.substring(start, end);
                }
            }
            
            if (gymIDStr == null || gymIDStr.isEmpty()) {
                String referer = request.getHeader("Referer");
                if (referer != null && referer.contains("gymID=")) {
                    int start = referer.indexOf("gymID=") + 6;
                    int end = referer.indexOf("&", start);
                    if (end == -1) end = referer.length();
                    gymIDStr = referer.substring(start, end);
                }
            }


            if (gymIDStr != null && !gymIDStr.isEmpty()) {
                try {
                    gymID = Integer.parseInt(gymIDStr.trim());
                    redirectURL = "edit_gym.jsp?gymID=" + gymID;
                } catch (NumberFormatException e) {
                    System.out.println("Error parsing gymID: " + gymIDStr);
                    response.sendRedirect("my_gyms.jsp?error=invalid_gym_id&debug=parse_error&value=" + gymIDStr);
                    return;
                }
            } else {
                java.util.Enumeration<String> paramNames = request.getParameterNames();
                while (paramNames.hasMoreElements()) {
                    String paramName = paramNames.nextElement();
                }
                response.sendRedirect("upload_status.jsp?error=missing_gym_id&debug=all_methods_failed");
                return;
            }
            
            if (action.equals("uploadPhotos")) {
                try {
                    if (photoFile != null && photoFile.getSize() > 0) {
                        String submittedFileName = photoFile.getName();
                        
                        if (submittedFileName == null || submittedFileName.trim().isEmpty()) {
                            redirectURL = "edit_gym.jsp?gymID=" + gymID + "&tab=photos&uploadError=true";
                        } else {
                            String extension = "";
                            int dotIndex = submittedFileName.lastIndexOf('.');
                            if (dotIndex > 0) {
                                extension = submittedFileName.substring(dotIndex);
                            }

                            String uniqueName = "gym_" + gymID + "_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().replaceAll("-", "") + extension;
                            
                            String appRoot = application.getRealPath("/");
                            String uploadDir = appRoot + "gym_photos" + File.separator + "img";
                            
                            File dir = new File(uploadDir);
                            if (!dir.exists()) {
                                boolean created = dir.mkdirs();
                            }
                            String savePath = uploadDir + File.separator + uniqueName;
                            String dbPath = "gym_photos/img/" + uniqueName;

                            File uploadedFile = new File(savePath);
                            photoFile.write(uploadedFile);

                            String retrievePrioritySQL = "SELECT IFNULL(MAX(p.Priority), 0) + 1 AS NextPriority FROM Photos p JOIN Displays d ON p.Photo_ID = d.Photo_ID WHERE d.Gym_ID = ?";
                            PreparedStatement pstmtPriority = con.prepareStatement(retrievePrioritySQL);
                            pstmtPriority.setInt(1, gymID);
                            ResultSet rsPriority = pstmtPriority.executeQuery();
                            int nextPriority = 1;
                            if (rsPriority.next()) {
                                nextPriority = rsPriority.getInt("NextPriority");
                            }
                            rsPriority.close();
                            pstmtPriority.close();

                            String uploadPhotoSQL = "INSERT INTO Photos (Priority, Photo_Path) VALUES (?, ?)";
                            PreparedStatement pstmtPhoto = con.prepareStatement(uploadPhotoSQL, Statement.RETURN_GENERATED_KEYS);
                            pstmtPhoto.setInt(1, nextPriority);
                            pstmtPhoto.setString(2, dbPath);
                            int rowsInserted = pstmtPhoto.executeUpdate();
                            
                            ResultSet generatedKeys = pstmtPhoto.getGeneratedKeys();
                            if (generatedKeys.next()) {
                                int photoID = generatedKeys.getInt(1);
                                String uploadDisplaysSQL = "INSERT INTO Displays (Gym_ID, Photo_ID) VALUES (?, ?)";
                                PreparedStatement pstmtDisplay = con.prepareStatement(uploadDisplaysSQL);
                                pstmtDisplay.setInt(1, gymID);
                                pstmtDisplay.setInt(2, photoID);
                                int displaysRows = pstmtDisplay.executeUpdate();
                                pstmtDisplay.close();
                            } 
                            generatedKeys.close();
                            pstmtPhoto.close();
                        }
                    } else {
                        redirectURL = "edit_gym.jsp?gymID=" + gymID + "&tab=photos&uploadError=true";
                    }
                } catch (Exception uploadException) {
                    uploadException.printStackTrace();
                    redirectURL = "edit_gym.jsp?gymID=" + gymID + "&tab=photos&uploadError=true";
                }
                
                if (!redirectURL.contains("uploadError")) {
                    redirectURL = "edit_gym.jsp?gymID=" + gymID + "&tab=photos&success=true";
                } 
            } else if (action.equals("updateGymDetails")) {
                String updatedGymName = request.getParameter("gymName");
                String updatedDescription = request.getParameter("description");
                String updatedAddress = request.getParameter("address");
                String updatedPrice = request.getParameter("price");
                String updateGym = "UPDATE Gyms SET Gym_Name = ?, Description = ?, Address = ?, Price = ? WHERE Gym_ID = ?";
                PreparedStatement pstmt = con.prepareStatement(updateGym);
                pstmt.setString(1, updatedGymName);
                pstmt.setString(2, updatedDescription);
                pstmt.setString(3, updatedAddress);
                pstmt.setDouble(4, Double.parseDouble(updatedPrice));
                pstmt.setInt(5, gymID);
                pstmt.executeUpdate();
                pstmt.close();
                redirectURL = "edit_gym.jsp?gymID=" + gymID + "&tab=details";
            } else if (action.equals("addMachine")) {
                String machineType = request.getParameter("machineType");
                String machineStatus = request.getParameter("machineStatus");
                Statement stmt = con.createStatement();
                String getMachineNumber = "SELECT IFNULL(MAX(Machine_Number), 0) + 1 AS NextMachineNumber FROM Machines WHERE Gym_ID = " + gymID;
                ResultSet rsMachineNumber = stmt.executeQuery(getMachineNumber);
                int machineNumber = 1;
                if (rsMachineNumber.next()) {
                    machineNumber = rsMachineNumber.getInt("NextMachineNumber");
                }
                String addMachine = "INSERT INTO Machines (Gym_ID, Machine_Number, Type, Status) VALUES (?, ?, ?, ?)";
                PreparedStatement pstmt = con.prepareStatement(addMachine);
                pstmt.setInt(1, gymID);
                pstmt.setInt(2, machineNumber);
                pstmt.setString(3, machineType);
                pstmt.setString(4, machineStatus);
                pstmt.executeUpdate();
                pstmt.close();
                stmt.close();
                redirectURL = "edit_gym.jsp?gymID=" + gymID + "&tab=machines";
            } else if (action.equals("saveMachines")) {
                String[] machineNumbers = request.getParameterValues("machineNumber");

                if (machineNumbers != null) {
                    for (String num: machineNumbers) {
                        int machineNumber = Integer.parseInt(num);

                        String type = "machineType_" + machineNumber;
                        String status = "machineStatus_" + machineNumber;

                        String updatedType = request.getParameter(type);
                        String updatedStatus = request.getParameter(status);

                        String updateMachines = "UPDATE Machines SET Type = '" + updatedType + "', Status = '" + updatedStatus + "' WHERE Machine_Number = " + machineNumber + " AND Gym_ID = " + gymID;
                        Statement updateMachineStmt = con.createStatement();

                        updateMachineStmt.execute(updateMachines);
                        updateMachineStmt.close();
                    }
                }
                redirectURL = "edit_gym.jsp?gymID=" + gymID + "&tab=machines";
            } else if (action.equals("deleteMachine")) {
                int machineNumber = Integer.parseInt(request.getParameter("machineNumber"));
                String deleteMachine = "DELETE FROM Machines WHERE Machine_Number = ? AND Gym_ID = ?";
                PreparedStatement pstmt = con.prepareStatement(deleteMachine);
                pstmt.setInt(1, machineNumber);
                pstmt.setInt(2, gymID);
                pstmt.executeUpdate();
                pstmt.close();
                redirectURL = "edit_gym.jsp?gymID=" + gymID + "&tab=machines";
            } else if (action.equals("addFeature")) {
                String featureName = request.getParameter("featureName");
                String getFeatureID = "SELECT Feature_ID FROM Features WHERE Feature_Name = ?";
                PreparedStatement pstmt_get = con.prepareStatement(getFeatureID);
                pstmt_get.setString(1, featureName);
                ResultSet rsFeature = pstmt_get.executeQuery();
                int featureID;
                if (rsFeature.next()) {
                    featureID = rsFeature.getInt("Feature_ID");
                } else {
                    String addFeature = "INSERT INTO Features (Feature_Name) VALUES (?)";
                    PreparedStatement pstmt_add = con.prepareStatement(addFeature, Statement.RETURN_GENERATED_KEYS);
                    pstmt_add.setString(1, featureName);
                    pstmt_add.executeUpdate();
                    ResultSet generatedKeys = pstmt_add.getGeneratedKeys();
                    generatedKeys.next();
                    featureID = generatedKeys.getInt(1);
                    pstmt_add.close();
                }
                String addPossesses = "INSERT INTO Possesses (Gym_ID, Feature_ID) VALUES (?, ?)";
                PreparedStatement pstmt_possess = con.prepareStatement(addPossesses);
                pstmt_possess.setInt(1, gymID);
                pstmt_possess.setInt(2, featureID);
                pstmt_possess.executeUpdate();
                pstmt_get.close();
                pstmt_possess.close();
                redirectURL = "edit_gym.jsp?gymID=" + gymID + "&tab=features";
            } else if (action.equals("saveFeatures")) {
                String[] originalFeatureNames = request.getParameterValues("originalFeatureName");

                if (originalFeatureNames != null) {
                    for (String originalName : originalFeatureNames) {
                        String safeFeatureName = originalName.replaceAll("[^a-zA-Z0-9]", "_");
                        String newName = request.getParameter("featureName_" + safeFeatureName);

                        if (newName != null && !newName.equals(originalName)) {
                            String updateFeature = "UPDATE Features SET Feature_Name = ? WHERE Feature_Name = ?";
                            PreparedStatement updateFeatureStmt = con.prepareStatement(updateFeature);
                            updateFeatureStmt.setString(1, newName);
                            updateFeatureStmt.setString(2, originalName);
                            updateFeatureStmt.executeUpdate();
                            updateFeatureStmt.close();
                        }
                    }
                }
                redirectURL = "edit_gym.jsp?gymID=" + gymID + "&tab=features";
            } else if (action.equals("deleteFeature")) {
                String featureName = request.getParameter("featureName");
                System.out.println("DEBUG: deleteFeature action called with featureName: " + featureName);
                String getFeatureID = "SELECT Feature_ID FROM Features WHERE Feature_Name = ?";
                PreparedStatement pstmt_get = con.prepareStatement(getFeatureID);
                pstmt_get.setString(1, featureName);
                ResultSet rsFeatureID = pstmt_get.executeQuery();
                if (rsFeatureID.next()) {
                    int featureID = rsFeatureID.getInt("Feature_ID");
                    System.out.println("DEBUG: Found feature ID: " + featureID + " for gym: " + gymID);
                    String deletePossesses = "DELETE FROM Possesses WHERE Gym_ID = ? AND Feature_ID = ?";
                    PreparedStatement pstmt_delete = con.prepareStatement(deletePossesses);
                    pstmt_delete.setInt(1, gymID);
                    pstmt_delete.setInt(2, featureID);
                    int rowsDeleted = pstmt_delete.executeUpdate();
                    System.out.println("DEBUG: Deleted " + rowsDeleted + " rows from Possesses table");
                    pstmt_delete.close();
                } else {
                    System.out.println("DEBUG: No feature found with name: " + featureName);
                }
                pstmt_get.close();
                redirectURL = "edit_gym.jsp?gymID=" + gymID + "&tab=features";
            } else {
                redirectURL = "edit_gym.jsp?gymID=" + gymID + "&error=unknown_action&action=" + action;
            }
            
            response.sendRedirect(redirectURL);
            return; 
        } catch (Exception e) {
            System.out.println("Exception in edit_gym.jsp: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("my_gyms.jsp?error=true&exception=" + e.getClass().getSimpleName());
        } finally {
            if (con != null) { 
                con.close(); 
            }
        }
        return; 
    }
%>

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
            <a class="navbar-brand" href="home.jsp">Gym Share</a>
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
            
            if (request.getMethod().equalsIgnoreCase("GET") && (gymIDParam == null || gymIDParam.trim().isEmpty())) {
                response.sendRedirect("my_gyms.jsp");
                return;
            }
            
            if (request.getMethod().equalsIgnoreCase("GET")) {
                try {
                    gymID = Integer.parseInt(gymIDParam.trim());
                } 
                catch (NumberFormatException e) {
                    out.println("Error parsing gymID: '" + gymIDParam + "'");
                    response.sendRedirect("my_gyms.jsp");
                    return;
                }
            } else {
                gymID = 1;
            }

            if (request.getMethod().equalsIgnoreCase("GET")) {
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

                <form action="edit_gym.jsp" method="post">
                    <input type="hidden" name="gymID" value="<%= gymID %>">
                    <input type="hidden" name="action" value="saveMachines">

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
                    <input type="hidden" name="machineNumber" value="<%= machineNumber %>">

                <div class="edit-machine">
                    <div class="machine-input-row">
                        <div class="input-group">
                            <label for="machineType_<%= machineNumber %>">Type:</label>
                            <input type="text" id="machineType_<%= machineNumber %>" name="machineType_<%= machineNumber %>" value="<%= machineTypeDisplay %>" required>
                        </div>
                        
                        <div class="input-group">
                            <label for="machineStatus_<%= machineNumber %>">Status:</label>
                            <select id="machineStatus_<%= machineNumber %>" name="machineStatus_<%= machineNumber %>" required>
                                <option value="Available" <%= "Available".equals(machineStatusDisplay) ? "selected" : "" %>>Available</option>
                                <option value="Unavailable" <%= "Unavailable".equals(machineStatusDisplay) ? "selected" : "" %>>Unavailable</option>
                            </select>
                        </div>

                        <div class="input-group">
                            <button type="button" class="delete-machine-btn" onclick="deleteMachineById('<%= machineNumber %>', '<%= gymID %>')">
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
                
                    <button type="submit" class="save-button">Save All Changes</button>
                </form>
            </div>

            <div id="photos" class="tab-content">
                <h2>Photos</h2>
                
                <%
                    String uploadError = request.getParameter("uploadError");
                    if (uploadError != null) {
                %>
                <div class="alert-error">
                    <strong>Error!</strong> Could not upload photo. Please ensure your server configuration is correct.
                </div>
                <%
                    }
                    String successParam = request.getParameter("success");
                    if ("true".equals(successParam)) {
                %>
                <div class="alert-success">
                    <strong>Success!</strong> Photo uploaded successfully.
                </div>
                <%
                    }
                %>
                
                <form action="edit_gym.jsp" method="post" enctype="multipart/form-data" class="photo-upload-form">
                    <input type="hidden" name="gymID" value="<%= gymID %>">
                    <input type="hidden" name="action" value="uploadPhotos">
                    <div class="form-group">
                        <label for="photo" class="form-label">Select Photo to Upload:</label>
                        <input type="file" id="photo" name="photo" accept="image/*" required>
                    </div>
                    <button type="submit" class="save-button">Upload Photo</button>
                </form>
                <div class="uploaded-photos">
                    <h3>Uploaded Photos:</h3>
                    <div class="photos-grid">
                        <%
                            try {
                                java.sql.Connection con;
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", user, password);

                                String retrievePhotosSQL = "SELECT p.Photo_Path, p.Priority " +
                                                           "FROM Photos p " +
                                                           "JOIN Displays d ON p.Photo_ID = d.Photo_ID " +
                                                           "WHERE d.Gym_ID = ? " +
                                                           "ORDER BY p.Priority ASC";
                                PreparedStatement pstmtPhotos = con.prepareStatement(retrievePhotosSQL);
                                pstmtPhotos.setInt(1, gymID);
                                ResultSet rsPhotos = pstmtPhotos.executeQuery();

                                boolean hasPhotos = false;
                                while(rsPhotos.next()) {
                                    hasPhotos = true;
                                    String photoPath = rsPhotos.getString("Photo_Path");
                                    if (photoPath != null && !photoPath.isEmpty()) {
                        %>
                        <div class="photo-container">
                            <img src="<%= request.getContextPath() %>/<%= photoPath %>" alt="Gym Photo" class="gym-photo">
                        </div>
                        <%
                                    }
                                }
                                if (!hasPhotos) {
                                    out.println("<p>No photos uploaded yet. Upload your first photo above!</p>");
                                }
                                rsPhotos.close();
                                pstmtPhotos.close();
                                con.close();
                            } 
                            catch (SQLException e) {
                                out.println("Error loading photos: " + e.getMessage());
                                e.printStackTrace();
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
                            
                            <div class="input-group">
                                <button type="submit" class="add-feature-btn" onclick="addFeature()">
                                    <i class="fas fa-plus"></i> Add Feature
                                </button>
                            </div>
                        </div>
                    </div>
                </form>

                <form action="edit_gym.jsp" method="post">
                    <input type="hidden" name="gymID" value="<%= gymID %>">
                    <input type="hidden" name="action" value="saveFeatures">

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
                            String safeFeatureName = featureNameDisplay.replaceAll("[^a-zA-Z0-9]", "_");

                %>
                    <input type="hidden" name="originalFeatureName" value="<%= featureNameDisplay %>">

                <div class="edit-feature">
                    <div class="feature-input-row">
                        <div class="input-group">
                            <label for="featureName_<%= safeFeatureName %>">Name:</label>
                            <input type="text" id="featureName_<%= safeFeatureName %>" name="featureName_<%= safeFeatureName %>" value="<%= featureNameDisplay %>" required>
                        </div>

                        <div class="input-group">
                            <button type="button" class="delete-feature-btn" onclick="deleteFeatureById('<%= featureNameDisplay %>', '<%= gymID %>')">
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
                
                    <button type="submit" class="save-button">Save All Changes</button>
                </form>
            </div>
        </div>
    </div>

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

    function saveMachines() {
        return true;
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

    function deleteMachineById(machineNumber, gymId) {
        if (confirm("Are you sure you want to delete this machine?")) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'edit_gym.jsp';
            
            const gymIdInput = document.createElement('input');
            gymIdInput.type = 'hidden';
            gymIdInput.name = 'gymID';
            gymIdInput.value = gymId;
            form.appendChild(gymIdInput);
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'deleteMachine';
            form.appendChild(actionInput);
            
            const machineInput = document.createElement('input');
            machineInput.type = 'hidden';
            machineInput.name = 'machineNumber';
            machineInput.value = machineNumber;
            form.appendChild(machineInput);
            
            document.body.appendChild(form);
            form.submit();
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

    function deleteFeatureById(featureName, gymId) {
        console.log("deleteFeatureById called with:", featureName, gymId);
        if (confirm("Are you sure you want to delete this feature?")) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'edit_gym.jsp';
            
            const gymIdInput = document.createElement('input');
            gymIdInput.type = 'hidden';
            gymIdInput.name = 'gymID';
            gymIdInput.value = gymId;
            form.appendChild(gymIdInput);
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'deleteFeature';
            form.appendChild(actionInput);
            
            const featureInput = document.createElement('input');
            featureInput.type = 'hidden';
            featureInput.name = 'featureName';
            featureInput.value = featureName;
            form.appendChild(featureInput);
            
            console.log("Form created with gymID:", gymId, "featureName:", featureName);
            document.body.appendChild(form);
            console.log("About to submit form");
            form.submit();
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

</html>

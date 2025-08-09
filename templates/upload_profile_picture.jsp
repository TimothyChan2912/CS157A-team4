<%@ page import="java.io.*, java.sql.*, javax.servlet.*, javax.servlet.http.*, javax.servlet.annotation.*" %>
<%@ page import="javax.servlet.http.Part" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Session check
    Integer userID = (Integer) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ page isELIgnored="false" %>
<%@ page session="true" %>

<%@ page import="java.nio.file.*" %>

<%
    // File upload setup
    String uploadPath = application.getRealPath("/") + "uploads";
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) {
        uploadDir.mkdirs();
    }

    // Ensure we're using multipart form data
    if (request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/")) {
        try {
            Part filePart = request.getPart("profilePicture");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String extension = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();

                // Sanitize and customize filename (e.g., user123.jpg)
                String newFileName = "user" + userID + "." + extension;
                String filePath = uploadPath + File.separator + newFileName;

                // Save file
                filePart.write(filePath);

                // Save file path in Users table
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4?autoReconnect=true&useSSL=false", "root", "GymShare");
                String sql = "UPDATE Users SET Profile_Pic=? WHERE User_ID=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, "uploads/" + newFileName); // relative path
                ps.setInt(2, userID);
                ps.executeUpdate();
                ps.close();
                con.close();

                // Success – redirect
                response.sendRedirect("guest_settings.jsp");
                return;
            } else {
                out.println("<p>No file selected.</p>");
            }
        } catch (Exception ex) {
            out.println("<p>Error uploading file: " + ex.getMessage() + "</p>");
        }
    } else {
        out.println("<p>Invalid request type. Must be multipart/form-data.</p>");
    }
%>

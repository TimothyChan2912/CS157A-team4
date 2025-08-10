<%@ page import="java.sql.*, java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    Integer senderID = Integer.parseInt(request.getParameter("senderID"));
    Integer recipientID = Integer.parseInt(request.getParameter("recipientID"));
    String content = request.getParameter("content");

    try {
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/team4", "root", "GymShare");

        PreparedStatement insertMsg = con.prepareStatement(
            "INSERT INTO Messages (Content) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
        insertMsg.setString(1, content);
        insertMsg.executeUpdate();

        ResultSet rs = insertMsg.getGeneratedKeys();
        int messageID = -1;
        if (rs.next()) {
            messageID = rs.getInt(1);
        }

        PreparedStatement insertAsk = con.prepareStatement("INSERT INTO Asks (User_ID, Message_ID) VALUES (?, ?)");
        insertAsk.setInt(1, senderID);
        insertAsk.setInt(2, messageID);
        insertAsk.executeUpdate();

        PreparedStatement insertAnswer = con.prepareStatement("INSERT INTO Answers (User_ID, Message_ID) VALUES (?, ?)");
        insertAnswer.setInt(1, recipientID);
        insertAnswer.setInt(2, messageID);
        insertAnswer.executeUpdate();

        rs.close();
        insertMsg.close();
        insertAsk.close();
        insertAnswer.close();
        con.close();

        response.sendRedirect("host_messages.jsp?recipientID=" + recipientID);

    } catch (Exception e) {
        out.println("Error sending message: " + e.getMessage());
    }
%>

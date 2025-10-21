package com.inventory.servlet;

import com.inventory.utils.DBConnection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static com.inventory.utils.DBConnection.closeConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        // GET USER RESPONSE
        String username = request.getParameter("txtUsername");
        String password = request.getParameter("txtPassword");
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");

        if (username.isEmpty() || password.isEmpty()) {
            request.setAttribute("error-message", "Username or Password is incorrect");
            dispatcher.forward(request, response);
        } else if (!username.matches("[a-zA-Z0-9]{1,15}") && !password.matches("[a-zA-Z0-9]{1,15}")) {
            request.setAttribute("error-message", "Username or Password is incorrect");
            dispatcher.forward(request, response);
        } else {
            try {
                // GET CONNECTION
                connection = DBConnection.getConnection();
                String selectQuery = "SELECT * FROM user WHERE userName = ? AND password = ?";
                statement = connection.prepareStatement(selectQuery);
                statement.setString(1, username);
                statement.setString(2, password);
                resultSet = statement.executeQuery();

                // IF RESULT FOUND REDIRECT TO DASHBOARD ELSE LOGIN
                if (resultSet.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("userId", resultSet.getInt("userId"));
                    session.setAttribute("medicalStoreName", resultSet.getString("medicalStoreName"));
                    session.setAttribute("medicalStoreLogo", resultSet.getString("medicalStoreLogo"));
                    response.sendRedirect("DashboardServlet");
                } else {
                    request.setAttribute("error-message", "Username or Password is incorrect");
                    dispatcher.forward(request, response);
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            } finally {
                closeConnection(connection);
            }
        }
    }
}

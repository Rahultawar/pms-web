package com.inventory.servlet;

import com.inventory.dao.UserDAO;
import com.inventory.models.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET USER RESPONSE
        String username = request.getParameter("txtUsername");
        String password = request.getParameter("txtPassword");
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");

        if (username.isEmpty() || password.isEmpty()) {
            request.setAttribute("error-message", "Username or Password is empty");
            dispatcher.forward(request, response);
            return;
        }

        if (!username.matches("^[a-z][a-z0-9]{5,19}$")) {
            request.setAttribute("error-message", "Invalid username format");
            dispatcher.forward(request, response);
            return;
        }

        // FETCH USER FROM DB
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByUsername(username);

        if (user == null) {
            request.setAttribute("error-message", "Login failed — your credentials don’t match our records.");
            dispatcher.forward(request, response);
            return;
        }

        // CHECK HASHED PASSWORD USING BCRYPT
        boolean passwordMatch = BCrypt.checkpw(password, user.getPassword());

        if (!passwordMatch) {
            request.setAttribute("error-message", "Login failed — your credentials don’t match our records.");
            dispatcher.forward(request, response);
            return;
        }

        // SUCCESS — CREATE SESSION
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("username", user.getUserName());
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("medicalStoreName", user.getMedicalStoreName());
        session.setAttribute("medicalStoreLogo", user.getMedicalStoreLogo());

        request.getRequestDispatcher("DashboardServlet").forward(request, response);
    }
}

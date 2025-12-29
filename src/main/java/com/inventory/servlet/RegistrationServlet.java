package com.inventory.servlet;

import com.inventory.dao.UserDAO;
import com.inventory.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;

@WebServlet("/RegistrationServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,   // 1MB
        maxFileSize = 1024 * 1024 * 5,          // 5MB - Increased limit
        maxRequestSize = 1024 * 1024 * 10       // 10MB
)
public class RegistrationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // SET REQUEST ENCODING TO UTF-8
            request.setCharacterEncoding("UTF-8");
            
            // EXTRACT FORM PARAMETERS FROM MULTIPART REQUEST
            String userName = getPartValue(request, "userName");
            String password = getPartValue(request, "password");
            String confirmPassword = getPartValue(request, "confirmPassword");
            String medicalStoreName = getPartValue(request, "medicalStoreName");

            // DEBUG LOGGING
            System.out.println("DEBUG - userName: " + userName);
            System.out.println("DEBUG - password: " + (password != null ? "***" : "null"));
            System.out.println("DEBUG - medicalStoreName: " + medicalStoreName);

            // BASIC VALIDATION
            if (userName == null || userName.trim().isEmpty() ||
                    password == null || password.trim().isEmpty() ||
                    medicalStoreName == null || medicalStoreName.trim().isEmpty()) {

                request.setAttribute("error-message", "All required fields must be filled");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
                return;
            }

            // PASSWORD MATCH VALIDATION
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error-message", "Passwords do not match");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
                return;
            }

            // REGEX VALIDATION
            boolean validUsername = userName.matches("^[a-z][a-z0-9]{5,19}$");
            boolean validPassword = password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_\\-+=\\{}\\[\\]|\\\\]).{8,}$");
            boolean validStoreName = medicalStoreName.matches("^[a-zA-Z0-9 ]{3,50}$");

            if (!validUsername || !validPassword || !validStoreName) {
                request.setAttribute("error-message", "Please check your username, password, or store name format");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
                return;
            }

            // CHECK USER EXISTS
            UserDAO userDAO = new UserDAO();
            if (userDAO.usernameExists(userName)) {
                request.setAttribute("error-message", "Username already exists. Please choose a different username.");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
                return;
            }

            // FILE UPLOAD HANDLING - NOW OPTIONAL AND STORED AS BASE64
            String logoBase64 = "";  // EMPTY STRING FOR NO LOGO
            Part filePart = request.getPart("medicalStoreLogo");

            if (filePart != null && filePart.getSize() > 0) {
                // VALIDATE FILE TYPE
                String contentType = filePart.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    request.setAttribute("error-message", "Invalid file type. Only image files allowed.");
                    request.getRequestDispatcher("registration.jsp").forward(request, response);
                    return;
                }

                // VALIDATE FILE SIZE (5MB max)
                if (filePart.getSize() > 5242880) { // 5MB
                    request.setAttribute("error-message", "File size should be less than 5MB.");
                    request.getRequestDispatcher("registration.jsp").forward(request, response);
                    return;
                }

                // CONVERT TO BASE64
                try (InputStream fileContent = filePart.getInputStream()) {
                    byte[] bytes = fileContent.readAllBytes();
                    logoBase64 = Base64.getEncoder().encodeToString(bytes);
                } catch (Exception e) {
                    request.setAttribute("error-message", "Error uploading logo: " + e.getMessage());
                    request.getRequestDispatcher("registration.jsp").forward(request, response);
                    return;
                }
            }

            // CREATE USER OBJECT
            User user = new User();
            user.setUserName(userName.trim());
            user.setPassword(password);
            user.setMedicalStoreName(medicalStoreName.trim());
            user.setMedicalStoreLogo(logoBase64);

            // SAVE USER
            boolean isRegistered = userDAO.registerUser(user);

            if (isRegistered) {
                request.setAttribute("success-message", "Registration successful! Please login.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            } else {
                request.setAttribute("error-message", "Registration failed. Please try again.");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error-message", "Server error: " + e.getMessage());
            request.getRequestDispatcher("registration.jsp").forward(request, response);
        }
    }

    private String getPartValue(HttpServletRequest request, String partName) {
        try {
            Part part = request.getPart(partName);
            if (part == null) {
                return null;
            }
            try (InputStream is = part.getInputStream()) {
                byte[] bytes = is.readAllBytes();
                return new String(bytes, "UTF-8").trim();
            }
        } catch (Exception e) {
            System.err.println("Error getting part value for: " + partName);
            e.printStackTrace();
            return null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("registration.jsp");
    }
}
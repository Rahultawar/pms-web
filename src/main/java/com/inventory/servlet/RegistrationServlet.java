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
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/RegistrationServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 2,         // 2MB
        maxRequestSize = 1024 * 1024 * 10      // 10MB
)
public class RegistrationServlet extends HttpServlet {

    private static final String UPLOAD_DIRECTORY = "assets/images/logos";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {

        try {
            // FORM PARAMETERS
            String userName = request.getParameter("userName");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String medicalStoreName = request.getParameter("medicalStoreName");

            // BASIC VALIDATION
            if (userName == null || userName.isEmpty() ||
                    password == null || password.isEmpty() ||
                    medicalStoreName == null || medicalStoreName.isEmpty()) {

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

            // FILE UPLOAD HANDLING
            String logoFileName = "assets/images/default-logo.png";  // DEFAULT LOGO
            Part filePart = request.getPart("medicalStoreLogo");

            if (filePart != null && filePart.getSize() > 0) {

                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();

                // VALIDATE EXTENSION
                if (!fileExtension.matches("\\.(png|jpg|jpeg|svg)")) {
                    request.setAttribute("error-message", "Invalid file type. Only PNG, JPG, JPEG, SVG allowed.");
                    request.getRequestDispatcher("registration.jsp").forward(request, response);
                    return;
                }

                logoFileName = userName + "_" + System.currentTimeMillis() + fileExtension;

                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                filePart.write(uploadPath + File.separator + logoFileName);

                logoFileName = UPLOAD_DIRECTORY + "/" + logoFileName;
            }

            // CREATE USER OBJECT
            User user = new User();
            user.setUserName(userName);
            user.setPassword(password);
            user.setMedicalStoreName(medicalStoreName);
            user.setMedicalStoreLogo(logoFileName);

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
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("registration.jsp");
    }
}

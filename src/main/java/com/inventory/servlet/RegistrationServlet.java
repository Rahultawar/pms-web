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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // GET FORM PARAMETERS
            String userName = request.getParameter("userName");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String medicalStoreName = request.getParameter("medicalStoreName");
            
            // VALIDATE INPUT
            if (userName == null || userName.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                medicalStoreName == null || medicalStoreName.trim().isEmpty()) {
                
                request.setAttribute("error-message", "All required fields must be filled");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
                return;
            }
            
            // VALIDATE PASSWORD MATCH
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error-message", "Passwords do not match");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
                return;
            }
            
            // VALIDATE PASSWORD LENGTH
            if (password.length() < 8) {
                request.setAttribute("error-message", "Password must be at least 8 characters");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
                return;
            }
            
            // CHECK IF USERNAME ALREADY EXISTS
            UserDAO userDAO = new UserDAO();
            if (userDAO.usernameExists(userName)) {
                request.setAttribute("error-message", "Username already exists. Please choose a different username");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
                return;
            }
            
            // HANDLE FILE UPLOAD
            String logoFileName = "default-logo.png";
            Part filePart = request.getPart("medicalStoreLogo");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                
                // VALIDATE FILE TYPE
                if (!fileExtension.matches("\\.(png|jpg|jpeg|svg)")) {
                    request.setAttribute("error-message", "Invalid file type. Only PNG, JPG, JPEG, and SVG are allowed");
                    request.getRequestDispatcher("registration.jsp").forward(request, response);
                    return;
                }
                
                // GENERATE UNIQUE FILE NAME
                logoFileName = userName + "_" + System.currentTimeMillis() + fileExtension;
                
                // GET UPLOAD PATH
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // SAVE FILE
                String filePath = uploadPath + File.separator + logoFileName;
                filePart.write(filePath);
                
                // SET RELATIVE PATH FOR DATABASE
                logoFileName = UPLOAD_DIRECTORY + "/" + logoFileName;
            } else {
                // USE DEFAULT LOGO PATH
                logoFileName = "assets/images/default-logo.png";
            }
            
            // CREATE USER OBJECT
            User user = new User();
            user.setUserName(userName);
            user.setPassword(password);  // Note: In production, hash the password!
            user.setMedicalStoreName(medicalStoreName);
            user.setMedicalStoreLogo(logoFileName);
            
            // REGISTER USER
            boolean isRegistered = userDAO.registerUser(user);
            
            if (isRegistered) {
                request.setAttribute("success-message", "Registration successful! Please login with your credentials");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            } else {
                request.setAttribute("error-message", "Registration failed. Please try again");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error-message", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("registration.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("registration.jsp");
    }
}

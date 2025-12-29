package com.inventory.servlet;

import com.inventory.dao.UserDAO;
import com.inventory.models.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;

@WebServlet("/ProfileServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,   // 1MB
        maxFileSize = 1024 * 1024 * 5,          // 5MB
        maxRequestSize = 1024 * 1024 * 10       // 10MB
)
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION VALIDATION
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        UserDAO userDAO = new UserDAO();

        try {
            User userProfile = userDAO.getUserByUsername(username);
            if (userProfile != null) {
                request.setAttribute("userProfile", userProfile);
            } else {
                request.setAttribute("errorMessage", "Profile not found.");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading profile: " + e.getMessage());
            e.printStackTrace();
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // SESSION VALIDATION
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String actionType = getPartValue(request, "actionType");

        if ("update".equals(actionType)) {
            updateProfile(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        Integer userId = (Integer) session.getAttribute("userId");

        // SET REQUEST ENCODING
        request.setCharacterEncoding("UTF-8");

        // GET FORM DATA FROM MULTIPART REQUEST
        String medicalStoreName = getPartValue(request, "txtMedicalStoreName");
        String currentPassword = getPartValue(request, "txtCurrentPassword");
        String newPassword = getPartValue(request, "txtNewPassword");
        String confirmPassword = getPartValue(request, "txtConfirmPassword");

        // DEBUG LOGGING
        System.out.println("DEBUG Profile - medicalStoreName: " + medicalStoreName);
        System.out.println("DEBUG Profile - currentPassword: " + (currentPassword != null ? "***" : "null"));
        System.out.println("DEBUG Profile - newPassword: " + (newPassword != null ? "***" : "null"));

        UserDAO userDAO = new UserDAO();

        try {
            // GET CURRENT USER
            User currentUser = userDAO.getUserByUsername(username);
            if (currentUser == null) {
                request.setAttribute("errorMessage", "User not found.");
                doGet(request, response);
                return;
            }

            // MEDICAL STORE NAME VALIDATION
            if (medicalStoreName == null || medicalStoreName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Medical store name is required.");
                request.setAttribute("userProfile", currentUser);
                RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Validate medical store name format (3-50 characters, alphanumeric and spaces)
            if (!medicalStoreName.matches("^[a-zA-Z0-9 ]{3,50}$")) {
                request.setAttribute("errorMessage", "Store name must be 3–50 characters and can include spaces.");
                request.setAttribute("userProfile", currentUser);
                RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // PASSWORD VALIDATION
            if (newPassword != null && !newPassword.isEmpty()) {
                if (currentPassword == null || currentPassword.isEmpty()) {
                    request.setAttribute("errorMessage", "Current password is required to change password.");
                    request.setAttribute("userProfile", currentUser);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                    dispatcher.forward(request, response);
                    return;
                }

                // VERIFY CURRENT PASSWORD
                boolean passwordMatch = false;
                try {
                    if (currentUser.getPassword().startsWith("$2a$") || currentUser.getPassword().startsWith("$2b$")) {
                        passwordMatch = BCrypt.checkpw(currentPassword, currentUser.getPassword());
                    } else {
                        passwordMatch = currentPassword.equals(currentUser.getPassword());
                    }
                } catch (Exception e) {
                    passwordMatch = currentPassword.equals(currentUser.getPassword());
                }

                if (!passwordMatch) {
                    request.setAttribute("errorMessage", "Current password is incorrect.");
                    request.setAttribute("userProfile", currentUser);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                    dispatcher.forward(request, response);
                    return;
                }

                // VALIDATE NEW PASSWORD FORMAT
                if (!newPassword
                        .matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_\\-+={}\\[\\]|\\\\]).{8,}$")) {
                    request.setAttribute("errorMessage",
                            "Password must contain uppercase, lowercase, number & symbol (8+ chars).");
                    request.setAttribute("userProfile", currentUser);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                    dispatcher.forward(request, response);
                    return;
                }

                if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("errorMessage", "Passwords must match.");
                    request.setAttribute("userProfile", currentUser);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            }

            // HANDLE FILE UPLOAD
            String logoBase64 = currentUser.getMedicalStoreLogo(); // Keep existing logo by default
            Part filePart = request.getPart("storeLogoFile");

            if (filePart != null && filePart.getSize() > 0) {
                // VALIDATE FILE SIZE (5MB)
                if (filePart.getSize() > 5242880) { // 5MB
                    request.setAttribute("errorMessage", "Logo file size should be less than 5MB.");
                    request.setAttribute("userProfile", currentUser);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                    dispatcher.forward(request, response);
                    return;
                }

                String contentType = filePart.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    request.setAttribute("errorMessage", "Please upload a valid image file.");
                    request.setAttribute("userProfile", currentUser);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                    dispatcher.forward(request, response);
                    return;
                }

                try (InputStream fileContent = filePart.getInputStream()) {
                    byte[] bytes = fileContent.readAllBytes();
                    logoBase64 = Base64.getEncoder().encodeToString(bytes);
                    System.out.println("DEBUG - Logo uploaded, Base64 length: " + logoBase64.length());
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Error uploading logo: " + e.getMessage());
                    request.setAttribute("userProfile", currentUser);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            }

            // UPDATE USER
            User updatedUser = new User();
            updatedUser.setUserId(userId);
            updatedUser.setUserName(username); // Username cannot be changed
            updatedUser.setMedicalStoreName(medicalStoreName.trim());
            updatedUser.setMedicalStoreLogo(logoBase64);

            // SET PASSWORD (HASH NEW PASSWORD IF PROVIDED)
            if (newPassword != null && !newPassword.isEmpty()) {
                String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
                updatedUser.setPassword(hashedPassword);
            } else {
                updatedUser.setPassword(currentUser.getPassword()); // Keep existing password
            }

            // SAVE TO DATABASE
            boolean updateSuccess = userDAO.updateUser(updatedUser);

            if (updateSuccess) {
                // UPDATE SESSION ATTRIBUTES
                session.setAttribute("medicalStoreName", medicalStoreName.trim());
                session.setAttribute("medicalStoreLogo", logoBase64);

                request.setAttribute("successMessage", "Profile updated successfully!");

                // RELOAD USER DATA
                User reloadedUser = userDAO.getUserByUsername(username);
                request.setAttribute("userProfile", reloadedUser);

            } else {
                request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
                request.setAttribute("userProfile", currentUser);
            }

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error updating profile: " + e.getMessage());
            e.printStackTrace();

            try {
                User currentUser = userDAO.getUserByUsername(username);
                request.setAttribute("userProfile", currentUser);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Helper method to extract text values from multipart form data
     */
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
}
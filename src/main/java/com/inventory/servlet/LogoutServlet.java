package com.inventory.servlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private String domain;
    private String clientId;
    private String postLogoutRedirect;

    @Override
    public void init() {
        try (InputStream in = getClass().getClassLoader().getResourceAsStream("cognito.properties")) {
            if (in == null) {
                throw new RuntimeException("cognito.properties file not found in classpath");
            }
            Properties p = new Properties(); 
            p.load(in);
            domain = p.getProperty("cognito.domain");
            clientId = p.getProperty("cognito.clientId");
            postLogoutRedirect = p.getProperty("cognito.postLogoutRedirect", "http://localhost:8080/PMS/index.jsp");
            
            if (domain == null || clientId == null) {
                throw new RuntimeException("Missing required Cognito configuration properties");
            }
            
            // Add https:// prefix if not present
            if (!domain.startsWith("http")) {
                domain = "https://" + domain;
            }
            
            // Remove trailing slash if present
            if (domain.endsWith("/")) {
                domain = domain.substring(0, domain.length() - 1);
            }
            
            System.out.println("[LogoutServlet] Initialized successfully");
            System.out.println("[LogoutServlet] Domain: " + domain);
            System.out.println("[LogoutServlet] Client ID: " + clientId);
            System.out.println("[LogoutServlet] Post-logout redirect: " + postLogoutRedirect);
            
        } catch (Exception e) {
            System.err.println("[LogoutServlet] INITIALIZATION FAILED: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to load cognito.properties", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            System.out.println("[LogoutServlet] Processing logout request");
            
            HttpSession s = req.getSession(false);
            if (s != null) {
                System.out.println("[LogoutServlet] Invalidating session for user: " + s.getAttribute("username"));
                s.invalidate();
            }
            
            String logoutUrl = domain + "/logout?client_id=" + URLEncoder.encode(clientId, StandardCharsets.UTF_8)
                    + "&logout_uri=" + URLEncoder.encode(postLogoutRedirect, StandardCharsets.UTF_8);
            
            System.out.println("[LogoutServlet] Redirecting to Cognito logout: " + logoutUrl);
            resp.sendRedirect(logoutUrl);
            
        } catch (Exception e) {
            System.err.println("[LogoutServlet] Error during logout: " + e.getMessage());
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Logout failed: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }
}
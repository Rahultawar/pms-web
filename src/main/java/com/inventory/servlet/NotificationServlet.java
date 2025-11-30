package com.inventory.servlet;

import com.inventory.dao.ProductDAO;
import com.inventory.dao.UserNotificationDAO;
import com.inventory.models.Product;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // SESSION VALIDATION
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // OBJECTS OF DAOs
        ProductDAO productDAO = new ProductDAO();
        UserNotificationDAO userNotificationDAO = new UserNotificationDAO();

        int userId = (Integer) session.getAttribute("userId");

        // FETCH NOTIFICATIONS
        List<Product> lowStockProducts = productDAO.getLowStockProducts(userId);
        List<Product> expiringProducts = productDAO.getExpiringProducts(userId);

        // Get read notification IDs from database
        List<Integer> readLowStockIds = userNotificationDAO.getReadNotificationIds(userId, "low_stock");
        List<Integer> readExpiryIds = userNotificationDAO.getReadNotificationIds(userId, "expiry");

        // Filter out read notifications
        List<Product> unreadLowStock = new ArrayList<>();
        for (Product p : lowStockProducts) {
            if (!readLowStockIds.contains(p.getProductId())) {
                unreadLowStock.add(p);
            }
        }

        List<Product> unreadExpiring = new ArrayList<>();
        for (Product p : expiringProducts) {
            if (!readExpiryIds.contains(p.getProductId())) {
                unreadExpiring.add(p);
            }
        }

        request.setAttribute("lowStockProducts", unreadLowStock);
        request.setAttribute("expiringProducts", unreadExpiring);

        RequestDispatcher dispatcher = request.getRequestDispatcher("notifications.jsp");
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

        UserNotificationDAO userNotificationDAO = new UserNotificationDAO();
        int userId = (Integer) session.getAttribute("userId");

        String action = request.getParameter("action");

        if ("markAsRead".equals(action)) {
            String type = request.getParameter("type"); // "lowStock" or "expiry"
            String productIdStr = request.getParameter("productId");

            if (productIdStr != null && type != null) {
                int productId = Integer.parseInt(productIdStr);

                // Convert frontend type to database type
                String dbType = "lowStock".equals(type) ? "low_stock" : "expiry";
                userNotificationDAO.markAsRead(userId, productId, dbType);
            }
        } else if ("markAllAsRead".equals(action)) {
            String type = request.getParameter("type");

            if ("lowStock".equals(type)) {
                userNotificationDAO.markAllAsRead(userId, "low_stock");
            } else if ("expiry".equals(type)) {
                userNotificationDAO.markAllAsRead(userId, "expiry");
            } else if ("all".equals(type)) {
                userNotificationDAO.markAllAsRead(userId);
            }
        } else if ("clearRead".equals(action)) {
            // Clear all read notifications (show all again)
            userNotificationDAO.clearAllReadNotifications(userId);
        }

        // Redirect back to notifications page
        response.sendRedirect("NotificationServlet");
    }
}

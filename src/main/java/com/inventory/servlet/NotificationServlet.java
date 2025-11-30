package com.inventory.servlet;

import com.inventory.dao.ProductDAO;
import com.inventory.models.Product;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
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

        int userId = (Integer) session.getAttribute("userId");

        // FETCH NOTIFICATIONS
        List<Product> lowStockProducts = productDAO.getLowStockProducts(userId);
        List<Product> expiringProducts = productDAO.getExpiringProducts(userId);

        request.setAttribute("lowStockProducts", lowStockProducts);
        request.setAttribute("expiringProducts", expiringProducts);

        RequestDispatcher dispatcher = request.getRequestDispatcher("notifications.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

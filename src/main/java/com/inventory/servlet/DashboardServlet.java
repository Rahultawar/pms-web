package com.inventory.servlet;

import com.inventory.dao.ProductDAO;
import com.inventory.dao.DistributorDAO;
import com.inventory.dao.SaleDAO;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // SESSION VALIDATION
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            // OBJECTS OF DAOs
            ProductDAO productDAO = new ProductDAO();
            DistributorDAO distributorDAO = new DistributorDAO();
            SaleDAO saleDAO = new SaleDAO();

            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                response.sendRedirect("index.jsp");
                return;
            }

            // FETCH COUNTS AND AMOUNTS
            double todaySaleAmount = saleDAO.getTodaySalesAmount(userId);
            double monthlySaleAmount = saleDAO.getMonthlySalesAmount(userId);
            int productCount = productDAO.countProduct(userId);
            int distributorCount = distributorDAO.countDistributor(userId);

            request.setAttribute("productCount", productCount);
            request.setAttribute("distributorCount", distributorCount);
            request.setAttribute("todaySaleAmount", todaySaleAmount);
            request.setAttribute("monthlySaleAmount", monthlySaleAmount);

            RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

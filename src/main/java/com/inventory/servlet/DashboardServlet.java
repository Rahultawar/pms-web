package com.inventory.servlet;

import com.inventory.dao.ProductDAO;
import com.google.gson.Gson;
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
import java.util.Map;

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
            double yearlySaleAmount = saleDAO.getYearlySalesAmount(userId);
            double pendingPaymentsAmount = saleDAO.getPendingPaymentsAmount(userId);
            int pendingPaymentsCount = saleDAO.getPendingPaymentsCount(userId);
            int productCount = productDAO.countProduct(userId);
            int distributorCount = distributorDAO.countDistributor(userId);

            // FETCH NOTIFICATION COUNTS
            int lowStockCount = productDAO.getLowStockProducts(userId).size();
            int expiringCount = productDAO.getExpiringProducts(userId).size();
            int totalNotifications = lowStockCount + expiringCount;

            // GET SALES TREND DATA (DEFAULT TO DAILY)
            String trendType = request.getParameter("trend");
            if (trendType == null || trendType.isEmpty()) {
                trendType = "day";
            }

            Map<String, Double> salesTrendData;
            switch (trendType.toLowerCase()) {
                case "month":
                    salesTrendData = saleDAO.getMonthlySalesTrend(userId);
                    break;
                case "year":
                    salesTrendData = saleDAO.getYearlySalesTrend(userId);
                    break;
                default:
                    salesTrendData = saleDAO.getDailySalesTrend(userId);
                    trendType = "day";
                    break;
            }

            // GET PRODUCT CATEGORY DISTRIBUTION
            Map<String, Integer> categoryData = productDAO.getProductCategoryDistribution(userId);

            // GET PAYMENT METHOD DISTRIBUTION
            Map<String, Integer> paymentMethodData = saleDAO.getPaymentMethodDistribution(userId);

            // CONVERT TO JSON FOR JAVASCRIPT
            Gson gson = new Gson();
            String salesTrendJson = gson.toJson(salesTrendData);
            String categoryDataJson = gson.toJson(categoryData);
            String paymentMethodJson = gson.toJson(paymentMethodData);

            request.setAttribute("productCount", productCount);
            request.setAttribute("distributorCount", distributorCount);
            request.setAttribute("todaySaleAmount", todaySaleAmount);
            request.setAttribute("monthlySaleAmount", monthlySaleAmount);
            request.setAttribute("yearlySaleAmount", yearlySaleAmount);
            request.setAttribute("pendingPaymentsAmount", pendingPaymentsAmount);
            request.setAttribute("pendingPaymentsCount", pendingPaymentsCount);
            request.setAttribute("salesTrendData", salesTrendJson);
            request.setAttribute("categoryData", categoryDataJson);
            request.setAttribute("paymentMethodData", paymentMethodJson);
            request.setAttribute("trendType", trendType);
            request.setAttribute("totalNotifications", totalNotifications);

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

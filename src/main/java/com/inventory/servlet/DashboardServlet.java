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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        ProductDAO productDAO = new ProductDAO();
        DistributorDAO distributorDAO = new DistributorDAO();
        SaleDAO saleDAO = new SaleDAO();
        int saleCount = saleDAO.countSale();
        int productCount = productDAO.countProduct();
        int distributorCount = distributorDAO.countDistributor();

        request.setAttribute("productCount", productCount);
        request.setAttribute("distributorCount", distributorCount);
        request.setAttribute("saleCount", saleCount);

        RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}

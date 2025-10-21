package com.inventory.servlet;

import com.inventory.dao.ProductDAO;
import com.inventory.dao.DistributorDAO;
import com.inventory.models.Product;
import com.inventory.utils.BigDecimalUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Product product = new Product();
        String actionType = request.getParameter("actionType");

        if (actionType == null || actionType.isEmpty()) {
            actionType = "add";
        }

        if (actionType.equalsIgnoreCase("add")) {
            // ADD PRODUCT
            String productName = request.getParameter("txtProductName");
            String category = request.getParameter("selCategory");
            String manufacturer = request.getParameter("txtManufacturer");
            String batchNumber = request.getParameter("txtBatchNumber");
            String strength = request.getParameter("txtStrength");
            String location = request.getParameter("txtLocation");
            String distributorId = request.getParameter("txtDistributorId");
            String userId = request.getParameter("txtUserId");
            String manufacturingDate = request.getParameter("manufacturingDate");
            String expiryDate = request.getParameter("expiryDate");
            String quantity = request.getParameter("txtQuantity");
            String subQuantity = request.getParameter("txtSubQuantity");
            String reorderLevel = request.getParameter("txtReorderLevel");
            String purchasingPrice = request.getParameter("txtPurchasingPrice");
            String sellingPrice = request.getParameter("txtSellingPrice");
            String unit = request.getParameter("selUnit");

            try {
                product.setProductName(productName);
                product.setDistributorId(Integer.parseInt(distributorId));
                if (userId != null && !userId.isEmpty()) {
                    product.setUserId(Integer.parseInt(userId));
                }
                product.setQuantity(Integer.parseInt(quantity));
                if (subQuantity != null && !subQuantity.isEmpty()) {
                    product.setSubQuantity(Integer.parseInt(subQuantity));
                }
                product.setUnit(unit);
                product.setLocation(location);
                product.setStrength(strength);
                product.setCategory(category);
                product.setManufacturer(manufacturer);
                product.setManufacturingDate(Date.valueOf(manufacturingDate));
                product.setExpiryDate(Date.valueOf(expiryDate));
                product.setPurchasingPrice(BigDecimalUtil.parseBigDecimal(purchasingPrice));
                product.setBatchNumber(batchNumber);
                product.setSellingPrice(BigDecimalUtil.parseBigDecimal(sellingPrice));
                product.setReorderLevel(Integer.parseInt(reorderLevel));

                // ADD PRODUCT METHOD FROM PRODUCT DAO
                productDAO.addProduct(product);

                // REDIRECT AFTER SUCCESS
                response.sendRedirect("ProductServlet?status=success");
                return;

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Something went wrong: " + e.getMessage());
                RequestDispatcher dispatcher = request.getRequestDispatcher("product.jsp");
                dispatcher.forward(request, response);
            }
        } else {
            // EDIT PRODUCT
            int prodId = Integer.parseInt(request.getParameter("productId"));

            String productName = request.getParameter("txtProductName");
            String category = request.getParameter("selCategory");
            String manufacturer = request.getParameter("txtManufacturer");
            String batchNumber = request.getParameter("txtBatchNumber");
            String strength = request.getParameter("txtStrength");
            String location = request.getParameter("txtLocation");
            String distributorId = request.getParameter("txtDistributorId");
            String userId = request.getParameter("txtUserId");
            String manufacturingDate = request.getParameter("manufacturingDate");
            String expiryDate = request.getParameter("expiryDate");
            String quantity = request.getParameter("txtQuantity");
            String subQuantity = request.getParameter("txtSubQuantity");
            String reorderLevel = request.getParameter("txtReorderLevel");
            String purchasingPrice = request.getParameter("txtPurchasingPrice");
            String sellingPrice = request.getParameter("txtSellingPrice");
            String unit = request.getParameter("selUnit");

            try {
                product.setProductId(prodId);
                product.setProductName(productName);
                product.setDistributorId(Integer.parseInt(distributorId));
                if (userId != null && !userId.isEmpty()) {
                    product.setUserId(Integer.parseInt(userId));
                }
                product.setQuantity(Integer.parseInt(quantity));
                if (subQuantity != null && !subQuantity.isEmpty()) {
                    product.setSubQuantity(Integer.parseInt(subQuantity));
                }
                product.setUnit(unit);
                product.setLocation(location);
                product.setStrength(strength);
                product.setCategory(category);
                product.setManufacturer(manufacturer);
                product.setManufacturingDate(Date.valueOf(manufacturingDate));
                product.setExpiryDate(Date.valueOf(expiryDate));
                product.setPurchasingPrice(BigDecimalUtil.parseBigDecimal(purchasingPrice));
                product.setBatchNumber(batchNumber);
                product.setSellingPrice(BigDecimalUtil.parseBigDecimal(sellingPrice));
                product.setReorderLevel(Integer.parseInt(reorderLevel));

                // UPDATE PRODUCT METHOD FROM PRODUCT DAO
                productDAO.updateProduct(product);

                // REDIRECT AFTER SUCCESS
                response.sendRedirect("ProductServlet?status=success");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Something went wrong: " + e.getMessage());
                RequestDispatcher dispatcher = request.getRequestDispatcher("product.jsp");
                dispatcher.forward(request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get userId from session
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        String deleteIdParam = request.getParameter("deleteId");

        // IF EDITING A PRODUCT
        if (idParam != null && !idParam.isEmpty()) {
            int prodId = Integer.parseInt(idParam);
            Product product = productDAO.getProductById(prodId, userId);
            request.setAttribute("productDetails", product);
        }

        // IF DELETING A PRODUCT
        if (deleteIdParam != null && !deleteIdParam.isEmpty()) {
            int deleteId = Integer.parseInt(deleteIdParam);
            productDAO.deleteProduct(deleteId, userId);
        }

        // PAGINATION LOGIC
        int page = 1;
        int recordsPerPage = 5;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        List<Product> productList = productDAO.getProductsPaginated((page - 1) * recordsPerPage, recordsPerPage, userId);
        int totalRecords = productDAO.countProduct(userId);
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

        request.setAttribute("productList", productList);
        request.setAttribute("noOfPages", totalPages);
        request.setAttribute("currentPage", page);

        // PROVIDE DISTRIBUTOR LIST FOR SELECT DROPDOWN
        DistributorDAO distributorDAO = new DistributorDAO();
        request.setAttribute("distributorList", distributorDAO.getAllDistributor(userId));
        RequestDispatcher dispatcher = request.getRequestDispatcher("product.jsp");
        dispatcher.forward(request, response);
    }
}

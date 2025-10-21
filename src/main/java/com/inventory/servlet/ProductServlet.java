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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Product product = new Product();
        String actionType = request.getParameter("actionType");

        if (actionType == null || actionType.isEmpty()) {
            actionType = "add";
        }

        if (actionType.equalsIgnoreCase("add")) {

            // Corrected parameter name
            String productName = request.getParameter("txtProductName");
            String category = request.getParameter("selCategory");
            String manufacturer = request.getParameter("txtManufacturer");
            String batchNumber = request.getParameter("txtBatchNumber");
            String strength = request.getParameter("txtStrength");
            String shelfLocation = request.getParameter("txtShelfLocation");
            String distributorId = request.getParameter("txtDistributorId");
            String manufacturingDate = request.getParameter("manufacturingDate");
            String expiryDate = request.getParameter("expiryDate");
            String quantityInStock = request.getParameter("txtQuantityInStock");
            String reorderLevel = request.getParameter("txtReorderLevel");
            String purchasePrice = request.getParameter("txtPurchasePrice");
            String sellingPrice = request.getParameter("txtSellingPrice");
            String unit = request.getParameter("selUnit");
            String stripType = request.getParameter("stripType");
            String unitsPerStrip = request.getParameter("unitsPerStrip");
            boolean isStrip = unit != null && unit.equalsIgnoreCase("strip");

            if (!isStrip) {
                stripType = null;
                unitsPerStrip = null;
            }

            // Field validation
            if (productName.isEmpty() || batchNumber.isEmpty() || strength.isEmpty() || manufacturingDate.isEmpty() || expiryDate.isEmpty() || purchasePrice.isEmpty() || sellingPrice.isEmpty() || unit.isEmpty() || quantityInStock.isEmpty()) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("product.jsp");
                request.setAttribute("emptyField", "Required fields can't be empty.");
                dispatcher.forward(request, response);
                return;
            }

            if (isStrip) {
                if (stripType == null || stripType.isEmpty() || unitsPerStrip == null || unitsPerStrip.isEmpty()) {
                    RequestDispatcher dispatcher = request.getRequestDispatcher("product.jsp");
                    request.setAttribute("emptyField", "Strip Type and Units per Strip are required when Unit is Strip.");
                    dispatcher.forward(request, response);
                    return;
                }
            }

            try {
                // Setting data
                product.setProductName(productName);
                product.setCategory(category);
                product.setManufacturer(manufacturer);
                product.setBatchNumber(batchNumber);
                product.setStrength(strength);
                product.setShelfLocation(shelfLocation);
                if (distributorId != null && !distributorId.isEmpty()) {
                    product.setDistributorId(Integer.parseInt(distributorId));
                } else {
                    product.setDistributorId(0);
                }
                product.setUnit(unit);
                product.setManufacturingDate(Date.valueOf(manufacturingDate));
                product.setExpiryDate(Date.valueOf(expiryDate));
                product.setQuantityInStock(Integer.parseInt(quantityInStock));
                product.setReorderLevel(reorderLevel != null && !reorderLevel.isEmpty() ? Integer.parseInt(reorderLevel) : 0);
                product.setPurchasePrice(BigDecimalUtil.parseBigDecimal(purchasePrice));
                product.setSellingPrice(BigDecimalUtil.parseBigDecimal(sellingPrice));
                product.setStripType(stripType != null && !stripType.isEmpty() ? stripType : null);
                product.setUnitsPerStrip(unitsPerStrip != null && !unitsPerStrip.isEmpty() ? Integer.parseInt(unitsPerStrip) : 0);

                // Save product
                productDAO.addProduct(product);

                // Redirect or forward after success
                response.sendRedirect("ProductServlet?status=success");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Something went wrong: " + e.getMessage());
                RequestDispatcher dispatcher = request.getRequestDispatcher("product.jsp");
                dispatcher.forward(request, response);
            }
        } else {
            int prodId = Integer.parseInt(request.getParameter("productId"));

            // Corrected parameter name
            String productName = request.getParameter("txtProductName");
            String category = request.getParameter("selCategory");
            String manufacturer = request.getParameter("txtManufacturer");
            String batchNumber = request.getParameter("txtBatchNumber");
            String strength = request.getParameter("txtStrength");
            String shelfLocation = request.getParameter("txtShelfLocation");
            String distributorId = request.getParameter("txtDistributorId");
            String manufacturingDate = request.getParameter("manufacturingDate");
            String expiryDate = request.getParameter("expiryDate");
            String quantityInStock = request.getParameter("txtQuantityInStock");
            String reorderLevel = request.getParameter("txtReorderLevel");
            String purchasePrice = request.getParameter("txtPurchasePrice");
            String sellingPrice = request.getParameter("txtSellingPrice");
            String unit = request.getParameter("selUnit");
            String unitsPerStrip = request.getParameter("unitsPerStrip");
            String stripType = request.getParameter("stripType");
            boolean isStrip = unit != null && unit.equalsIgnoreCase("strip");

            if (!isStrip) {
                stripType = null;
                unitsPerStrip = null;
            }

            // Field validation
            if (productName.isEmpty() || batchNumber.isEmpty() || strength.isEmpty() || manufacturingDate.isEmpty() || expiryDate.isEmpty() || purchasePrice.isEmpty() || sellingPrice.isEmpty() || unit.isEmpty() || quantityInStock.isEmpty()) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("product.jsp");
                request.setAttribute("emptyField", "Required fields can't be empty.");
                dispatcher.forward(request, response);
                return;
            }

            if (isStrip) {
                if (stripType == null || stripType.isEmpty() || unitsPerStrip == null || unitsPerStrip.isEmpty()) {
                    RequestDispatcher dispatcher = request.getRequestDispatcher("product.jsp");
                    request.setAttribute("emptyField", "Strip Type and Units per Strip are required when Unit is Strip.");
                    dispatcher.forward(request, response);
                    return;
                }
            }

            try {
                // Setting data
                product.setProductId(prodId);
                product.setProductName(productName);
                product.setCategory(category);
                product.setManufacturer(manufacturer);
                product.setBatchNumber(batchNumber);
                product.setStrength(strength);
                product.setShelfLocation(shelfLocation);
                if (distributorId != null && !distributorId.isEmpty()) {
                    product.setDistributorId(Integer.parseInt(distributorId));
                } else {
                    product.setDistributorId(0);
                }
                product.setUnit(unit);
                product.setManufacturingDate(Date.valueOf(manufacturingDate));
                product.setExpiryDate(Date.valueOf(expiryDate));
                product.setQuantityInStock(Integer.parseInt(quantityInStock));
                product.setReorderLevel(reorderLevel != null && !reorderLevel.isEmpty() ? Integer.parseInt(reorderLevel) : 0);
                product.setPurchasePrice(BigDecimalUtil.parseBigDecimal(purchasePrice));
                product.setSellingPrice(BigDecimalUtil.parseBigDecimal(sellingPrice));
                product.setUnitsPerStrip(unitsPerStrip != null && !unitsPerStrip.isEmpty() ? Integer.parseInt(unitsPerStrip) : 0);
                product.setStripType(stripType != null && !stripType.isEmpty() ? stripType : null);

                // Save product
                productDAO.updateProduct(product);

                // Redirect or forward after success
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String deleteIdParam = request.getParameter("deleteId");

        // If editing a product
        if (idParam != null && !idParam.isEmpty()) {
            int prodId = Integer.parseInt(idParam);
            Product product = productDAO.getProductById(prodId);
            request.setAttribute("productDetails", product);
        }

        // If deleting a product
        if (deleteIdParam != null && !deleteIdParam.isEmpty()) {
            int deleteId = Integer.parseInt(deleteIdParam);
            productDAO.deleteProduct(deleteId);
        }

        // Pagination logic
        int page = 1;
        int recordsPerPage = 5;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Product> productList = productDAO.getProductsPaginated((page - 1) * recordsPerPage, recordsPerPage);
        int totalRecords = productDAO.countProduct();
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

        request.setAttribute("productList", productList);
        request.setAttribute("noOfPages", totalPages);
        request.setAttribute("currentPage", page);

    // Provide distributor list for product.jsp select dropdown
    DistributorDAO distributorDAO = new DistributorDAO();
    request.setAttribute("distributorList", distributorDAO.getAllDistributor());

        RequestDispatcher dispatcher = request.getRequestDispatcher("product.jsp");
        dispatcher.forward(request, response);
    }
}

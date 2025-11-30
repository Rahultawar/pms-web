package com.inventory.servlet;

import com.inventory.dao.DistributorDAO;
import com.inventory.dao.ProductDAO;
import com.inventory.dao.SaleDAO;
import com.inventory.models.Product;
import com.inventory.models.Sale;
import com.inventory.utils.BigDecimalUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@WebServlet("/SaleServlet")
public class SaleServlet extends HttpServlet {
    SaleDAO saleDAO = new SaleDAO();
    ProductDAO productDAO = new ProductDAO();
    DistributorDAO distributorDAO = new DistributorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String actionType = request.getParameter("actionType");
        if (actionType == null || actionType.isEmpty()) {
            actionType = "add";
        }

        if ("add".equalsIgnoreCase(actionType)) {
            handleAddSale(request, response);
        } else if ("update".equalsIgnoreCase(actionType)) {
            handleUpdateSale(request, response);
        } else {
            response.sendRedirect("SaleServlet");
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

        String deleteIdParam = request.getParameter("deleteId");
        if (deleteIdParam != null && !deleteIdParam.isEmpty()) {
            try {
                int deleteId = Integer.parseInt(deleteIdParam);
                Sale existingSale = saleDAO.getSaleById(deleteId);
                if (existingSale != null) {
                    // Restore product quantity before deleting sale
                    // productDAO.addProductQuantity(existingSale.getProductId(),
                    // existingSale.getQuantity());
                }
//                saleDAO.deleteSale(deleteId);
                response.sendRedirect("SaleServlet?status=deleted");
                return;
            } catch (NumberFormatException ignored) {
                // fall through and render page with error message
                request.setAttribute("errorMessage", "Invalid sale id for deletion.");
            }
        }

        String editIdParam = request.getParameter("editId");
        if (editIdParam != null && !editIdParam.isEmpty()) {
            try {
                int editId = Integer.parseInt(editIdParam);
                Sale sale = saleDAO.getSaleById(editId);
                request.setAttribute("saleDetails", sale);
            } catch (NumberFormatException ignored) {
                request.setAttribute("errorMessage", "Invalid sale id for edit.");
            }
        }

        int page = 1;
        int recordsPerPage = 5;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {
                page = 1;
            }
        }

        int offset = (page - 1) * recordsPerPage;
        request.setAttribute("saleList", saleDAO.getSalesPaginated(offset, recordsPerPage));
        int totalRecords = saleDAO.countSale();
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
        request.setAttribute("noOfPages", totalPages);
        request.setAttribute("currentPage", page);

        request.setAttribute("productList", productDAO.getProductsPaginated(0, 1000, userId));
        request.setAttribute("distributorList", distributorDAO.getAllDistributor(userId));

        // FETCH NOTIFICATION COUNTS FOR SIDEBAR
        int lowStockCount = productDAO.getLowStockProducts(userId).size();
        int expiringCount = productDAO.getExpiringProducts(userId).size();
        int totalNotifications = lowStockCount + expiringCount;
        request.setAttribute("totalNotifications", totalNotifications);

        RequestDispatcher dispatcher = request.getRequestDispatcher("sale.jsp");
        dispatcher.forward(request, response);
    }

    private void handleAddSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get userId from session
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        Sale sale = new Sale();
        try {
            Product product = null;
            String productParam = request.getParameter("selProduct");
            if (productParam != null && !productParam.isEmpty()) {
                int productId = Integer.parseInt(productParam);
                product = productDAO.getProductById(productId, userId);
            }

            populateSaleFromRequest(request, sale, product);
            sale.setSaleDate(LocalDateTime.now());

            if (product == null) {
                request.setAttribute("saleDetails", sale);
                request.setAttribute("errorMessage", "Product not found.");
                forwardToSaleJsp(request, response);
                return;
            }

            // Check if sufficient stock is available
            int quantityToSell = sale.getQuantity();
            if (product.getQuantity() < quantityToSell) {
                request.setAttribute("saleDetails", sale);
                request.setAttribute("errorMessage", "Insufficient stock. Available: " + product.getQuantity()
                        + ", Required: " + quantityToSell);
                forwardToSaleJsp(request, response);
                return;
            }

            // Deduct product quantity from inventory
            boolean deducted = productDAO.deductProductQuantity(product.getProductId(), quantityToSell);
            if (!deducted) {
                request.setAttribute("saleDetails", sale);
                request.setAttribute("errorMessage", "Failed to update product inventory. Please try again.");
                forwardToSaleJsp(request, response);
                return;
            }

            saleDAO.addSale(sale);
            response.sendRedirect("SaleServlet?status=success");
        } catch (Exception e) {
            request.setAttribute("saleDetails", sale);
            request.setAttribute("errorMessage", "Unable to add sale: " + e.getMessage());
            forwardToSaleJsp(request, response);
        }
    }

    private void handleUpdateSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get userId from session
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        Sale sale = new Sale();
        try {
            int saleId = Integer.parseInt(request.getParameter("saleId"));
            Sale existing = saleDAO.getSaleById(saleId);
            if (existing == null) {
                request.setAttribute("errorMessage", "Sale not found.");
                request.setAttribute("saleDetails", sale);
                forwardToSaleJsp(request, response);
                return;
            }

            sale.setSaleId(saleId);
            sale.setSaleDate(existing.getSaleDate());

            Product product = null;
            String productParam = request.getParameter("selProduct");
            if (productParam != null && !productParam.isEmpty()) {
                int productId = Integer.parseInt(productParam);
                product = productDAO.getProductById(productId, userId);
            }

            populateSaleFromRequest(request, sale, product);

            if (productParam != null && !productParam.isEmpty() && product == null) {
                request.setAttribute("saleDetails", sale);
                request.setAttribute("errorMessage", "Product not found for sale update.");
                forwardToSaleJsp(request, response);
                return;
            }

            // Handle inventory adjustment when updating sale
            int oldQuantity = existing.getQuantity();
            int newQuantity = sale.getQuantity();
            int oldProductId = existing.getProductId();
            int newProductId = sale.getProductId();

            // If product changed or quantity changed, adjust inventory
            if (oldProductId != newProductId) {
                // Restore old product quantity
                // productDAO.addProductQuantity(oldProductId, oldQuantity);
                // Deduct from new product
                if (product != null) {
                    if (product.getQuantity() < newQuantity) {
                        request.setAttribute("saleDetails", sale);
                        request.setAttribute("errorMessage",
                                "Insufficient stock for new product. Available: " + product.getQuantity());
                        forwardToSaleJsp(request, response);
                        return;
                    }
                    boolean deducted = productDAO.deductProductQuantity(newProductId, newQuantity);
                    if (!deducted) {
                        // Rollback the addition
                        productDAO.deductProductQuantity(oldProductId, oldQuantity);
                        request.setAttribute("saleDetails", sale);
                        request.setAttribute("errorMessage", "Failed to update product inventory.");
                        forwardToSaleJsp(request, response);
                        return;
                    }
                }
            } else if (oldQuantity != newQuantity) {
                // Same product, different quantity
                int difference = newQuantity - oldQuantity;
                if (difference > 0) {
                    // Need to deduct more
                    if (product != null && product.getQuantity() < difference) {
                        request.setAttribute("saleDetails", sale);
                        request.setAttribute("errorMessage", "Insufficient stock. Available: "
                                + product.getQuantity() + ", Additional needed: " + difference);
                        forwardToSaleJsp(request, response);
                        return;
                    }
                    boolean deducted = productDAO.deductProductQuantity(newProductId, difference);
                    if (!deducted) {
                        request.setAttribute("saleDetails", sale);
                        request.setAttribute("errorMessage", "Failed to update product inventory.");
                        forwardToSaleJsp(request, response);
                        return;
                    }
                } else if (difference < 0) {
                    // Return some quantity
                    // productDAO.addProductQuantity(newProductId, Math.abs(difference));
                }
            }

//            saleDAO.updateSale(sale);

            response.sendRedirect("SaleServlet?status=success");
        } catch (Exception e) {
            request.setAttribute("saleDetails", sale);
            request.setAttribute("errorMessage", "Unable to update sale: " + e.getMessage());
            forwardToSaleJsp(request, response);
        }
    }

    private void populateSaleFromRequest(HttpServletRequest request, Sale sale, Product product) {
        int productId = product != null ? product.getProductId() : Integer.parseInt(request.getParameter("selProduct"));
        sale.setProductId(productId);

        String distributorParam = request.getParameter("selDistributor");
        Integer distributorId = null;
        if (distributorParam != null && !distributorParam.isEmpty()) {
            distributorId = Integer.parseInt(distributorParam);
        } else if (product != null) {
            distributorId = product.getDistributorId();
        }
        sale.setDistributorId(distributorId);

        sale.setQuantity(Integer.parseInt(request.getParameter("txtQuantity")));
        sale.setCustomerName(request.getParameter("txtCustomerName"));
        sale.setMobileNumber(request.getParameter("txtMobileNumber"));
        sale.setPaymentMethod(request.getParameter("selPaymentMethod"));

        BigDecimal unitPrice = BigDecimalUtil.parseBigDecimal(request.getParameter("txtUnitPrice"));
        if (unitPrice == null && product != null) {
            unitPrice = product.getSellingPrice();
        }
//        sale.setUnitPrice(unitPrice);

        String unit = request.getParameter("txtUnit");
        if ((unit == null || unit.isEmpty()) && product != null) {
            unit = product.getUnit();
        }
//        sale.setUnit(unit);

        String unitsPerStripParam = request.getParameter("txtUnitPerStrip");
        if ((unitsPerStripParam == null || unitsPerStripParam.isEmpty()) && product != null) {
//            sale.setUnitsPerStrip(product.getUnitsPerStrip());
        } else if (unitsPerStripParam != null && !unitsPerStripParam.isEmpty()) {
//            sale.setUnitsPerStrip(Integer.parseInt(unitsPerStripParam));
        } else {
//            sale.setUnitsPerStrip(null);
        }

        BigDecimal discountAmount = BigDecimalUtil.parseBigDecimal(request.getParameter("txtDiscountAmount"));
        sale.setDiscountAmount(discountAmount == null ? BigDecimal.ZERO : discountAmount);

        BigDecimal amountGiven = BigDecimalUtil.parseBigDecimal(request.getParameter("txtAmountGiven"));
        sale.setAmountGiven(amountGiven == null ? BigDecimal.ZERO : amountGiven);

        BigDecimal total = sale.computeExpectedTotal();
        BigDecimal given = sale.getAmountGiven() == null ? BigDecimal.ZERO : sale.getAmountGiven();
        sale.setStatus(given.compareTo(total) >= 0 ? Sale.SaleStatus.completed : Sale.SaleStatus.pending);
    }

    private void forwardToSaleJsp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get userId from session
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        request.setAttribute("productList", productDAO.getProductsPaginated(0, 1000, userId));
        request.setAttribute("distributorList", distributorDAO.getAllDistributor(userId));
        request.setAttribute("saleList", saleDAO.getSalesPaginated(0, 5));
        request.setAttribute("noOfPages", (int) Math.ceil(saleDAO.countSale() / 5.0));
        request.setAttribute("currentPage", 1);
        RequestDispatcher dispatcher = request.getRequestDispatcher("sale.jsp");
        dispatcher.forward(request, response);
    }
}

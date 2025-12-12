package com.inventory.servlet;

import com.inventory.dao.CustomerDAO;
import com.inventory.dao.DistributorDAO;
import com.inventory.dao.ProductDAO;
import com.inventory.dao.SaleDAO;
import com.inventory.models.Customer;
import com.inventory.models.Distributor;
import com.inventory.models.Product;
import com.inventory.models.Sale;
import com.inventory.models.Sale.PaymentMethod;
import com.inventory.models.Sale.SaleStatus;
import com.inventory.utils.BigDecimalUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/SaleServlet")
public class SaleServlet extends HttpServlet {
    SaleDAO saleDAO = new SaleDAO();
    ProductDAO productDAO = new ProductDAO();
    DistributorDAO distributorDAO = new DistributorDAO();
    CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String actionType = request.getParameter("actionType");
        if (actionType == null || actionType.isEmpty())
            actionType = "add";

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

        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        
        if (session == null || userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            // HANDLE EDIT REQUEST
            String idParam = request.getParameter("id");
            if (idParam != null) {
                int saleId = Integer.parseInt(idParam);
                Sale sale = saleDAO.getSaleById(saleId);
                if (sale != null && sale.getUserId().equals(userId)) {
                    request.setAttribute("saleDetails", sale);
                } else {
                    request.setAttribute("errorMessage", "Sale not found or unauthorized access.");
                }
            }

            // HANDLE DELETE REQUEST
            String deleteIdParam = request.getParameter("deleteId");
            if (deleteIdParam != null) {
                int saleId = Integer.parseInt(deleteIdParam);
                Sale sale = saleDAO.getSaleById(saleId);
                if (sale != null && sale.getUserId().equals(userId)) {
                    boolean deleted = saleDAO.deleteSale(saleId);
                    if (deleted) {
                        String currentPage = request.getParameter("page");
                        if (currentPage != null && !currentPage.isEmpty()) {
                            response.sendRedirect("SaleServlet?msg=Sale deleted successfully&page=" + currentPage);
                        } else {
                            response.sendRedirect("SaleServlet?msg=Sale deleted successfully");
                        }
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Failed to delete sale.");
                    }
                } else {
                    request.setAttribute("errorMessage", "Sale not found or unauthorized access.");
                }
            }

            // LOAD PRODUCTS FOR THE LOGGED-IN USER
            List<Product> productList = productDAO.getProductsByUserId(userId);
            request.setAttribute("productList", productList);

            // LOAD DISTRIBUTORS FOR THE LOGGED-IN USER
            List<Distributor> distributorList = distributorDAO.getAllDistributor(userId);
            request.setAttribute("distributorList", distributorList);

            // LOAD CUSTOMERS FOR THE LOGGED-IN USER
            List<Customer> customerList = customerDAO.getCustomersByUserId(userId);
            request.setAttribute("customerList", customerList);

            // LOAD SALES WITH PAGINATION
            int page = 1;
            int recordsPerPage = 10;

            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            List<Sale> saleList = saleDAO.getSalesByUserId(userId, page, recordsPerPage);
            int totalRecords = saleDAO.getTotalSalesByUserId(userId);
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            request.setAttribute("saleList", saleList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("noOfPages", totalPages);

        // FETCH NOTIFICATION COUNTS FOR SIDEBAR
        int lowStockCount = productDAO.getLowStockProducts(userId).size();
        int expiringCount = productDAO.getExpiringProducts(userId).size();
        int totalNotifications = lowStockCount + expiringCount;
        request.setAttribute("totalNotifications", totalNotifications);

        RequestDispatcher dispatcher = request.getRequestDispatcher("sale.jsp");
        dispatcher.forward(request, response);
        }catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading sales: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("sale.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void handleAddSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("selProduct"));
            Product product = productDAO.getProductByIdAndUserId(productId, userId);

            if (product == null) {
                throw new IllegalArgumentException("Product not found or unauthorized");
            }

            Sale sale = new Sale();
            populateSaleFromRequest(request, sale, product, userId);

            // VALIDATE QUANTITY AVAILABILITY BEFORE DEDUCTING
            int quantity = sale.getQuantity();
            int subQuantity = sale.getSubQuantity() != null ? sale.getSubQuantity() : 0;

            // CHECK IF SUFFICIENT QUANTITY AVAILABLE
            if (product.getQuantity() < quantity) {
                throw new IllegalArgumentException("Insufficient quantity available. You have requested " +
                        quantity + " but only " + product.getQuantity() + " available.");
            }

            // CHECK IF SUFFICIENT SUBQUANTITY AVAILABLE
            if (subQuantity > 0) {
                Integer productSubQty = product.getSubQuantity();
                if (productSubQty == null || productSubQty < subQuantity) {
                    throw new IllegalArgumentException("Insufficient sub-quantity available. You have requested " +
                            subQuantity + " but only " + (productSubQty != null ? productSubQty : 0) + " available.");
                }
            }

            // DEDUCT INVENTORY AFTER VALIDATION
            if (!productDAO.deductProductQuantity(productId, quantity)) {
                throw new IllegalArgumentException("Failed to deduct quantity from inventory");
            }

            if (subQuantity > 0 && !productDAO.deductProductSubQuantity(productId, subQuantity)) {
                throw new IllegalArgumentException("Failed to deduct sub-quantity from inventory");
            }

            saleDAO.addSale(sale);
            String currentPage = request.getParameter("currentPage");
            if (currentPage != null && !currentPage.isEmpty()) {
                response.sendRedirect("SaleServlet?msg=Sale added successfully&page=" + currentPage);
            } else {
                response.sendRedirect("SaleServlet?msg=Sale added successfully");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            forwardToSaleJsp(request, response);
        }
    }

    private void handleUpdateSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            int saleId = Integer.parseInt(request.getParameter("saleId"));
            Sale existing = saleDAO.getSaleById(saleId);
            
            if (existing == null || !existing.getUserId().equals(userId)) {
                request.setAttribute("errorMessage", "Sale not found or unauthorized access.");
                forwardToSaleJsp(request, response);
                return;
            }

            Sale sale = new Sale();
            sale.setSaleId(saleId);
            sale.setSaleDate(existing.getSaleDate());

            int productId = Integer.parseInt(request.getParameter("selProduct"));
            Product product = productDAO.getProductByIdAndUserId(productId, userId);

            if (product == null) {
                request.setAttribute("errorMessage", "Product not found.");
                request.setAttribute("saleDetails", sale);
                forwardToSaleJsp(request, response);
                return;
            }

            populateSaleFromRequest(request, sale, product, userId);

            // UPDATE THE SALE
            Sale updatedSale = saleDAO.updateSale(sale);
            if (updatedSale != null) {
                String currentPage = request.getParameter("currentPage");
                if (currentPage != null && !currentPage.isEmpty()) {
                    response.sendRedirect("SaleServlet?msg=Sale updated successfully&page=" + currentPage);
                } else {
                    response.sendRedirect("SaleServlet?msg=Sale updated successfully");
                }
            } else {
                request.setAttribute("saleDetails", sale);
                request.setAttribute("errorMessage", "Failed to update sale.");
                forwardToSaleJsp(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to update sale: " + e.getMessage());
            forwardToSaleJsp(request, response);
        }
    }

    private void populateSaleFromRequest(HttpServletRequest request, Sale sale, Product product, Integer userId) {
        int productId = product != null ? product.getProductId() : Integer.parseInt(request.getParameter("selProduct"));
        sale.setProductId(productId);
        sale.setUserId(userId);

        // AUTO-SELECT DISTRIBUTOR IF PRODUCT HAS ONLY ONE DISTRIBUTOR
        String distributorParam = request.getParameter("selDistributor");
        if (distributorParam != null && !distributorParam.isEmpty()) {
            sale.setDistributorId(Integer.parseInt(distributorParam));
        } else if (product != null) {
            // AUTOMATICALLY SET DISTRIBUTOR FROM PRODUCT
            sale.setDistributorId(product.getDistributorId());
        } else {
            throw new IllegalArgumentException("Distributor ID is required.");
        }

        // VALIDATE AND SET QUANTITY
        String quantityParam = request.getParameter("txtQuantity");
        if (quantityParam == null || quantityParam.trim().isEmpty()) {
            throw new IllegalArgumentException("Quantity is required");
        }
        int quantity = Integer.parseInt(quantityParam);
        if (quantity < 0) {
            throw new IllegalArgumentException("Quantity cannot be negative");
        }
        sale.setQuantity(quantity);

        // VALIDATE AND SET SUBQUANTITY (ONLY IF PRODUCT HAS SUBQUANTITY)
        String subQtyParam = request.getParameter("txtSubQuantity");
        if (subQtyParam != null && !subQtyParam.trim().isEmpty()) {
            int subQty = Integer.parseInt(subQtyParam);
            if (subQty < 0) {
                throw new IllegalArgumentException("Sub-quantity cannot be negative");
            }
            // CHECK IF PRODUCT SUPPORTS SUBQUANTITY
            if (product != null) {
                sale.setSubQuantity(subQty);
            } else if (subQty > 0) {
                throw new IllegalArgumentException("This product does not have sub-quantity available");
            }
        }

        // REQUIRE AT LEAST ONE OF QUANTITY OR SUBQUANTITY
        int subQtyVal = sale.getSubQuantity() != null ? sale.getSubQuantity() : 0;
        if (quantity == 0 && subQtyVal == 0) {
            throw new IllegalArgumentException("Enter quantity or sub-quantity (at least one must be > 0)");
        }

        // SET CUSTOMER (OPTIONAL)
        String customerIdParam = request.getParameter("selCustomer");
        if (customerIdParam != null && !customerIdParam.isEmpty()) {
            sale.setCustomerId(Integer.parseInt(customerIdParam));
        }

        // SET PAYMENT METHOD
        String paymentMethodStr = request.getParameter("selPaymentMethod");
        if (paymentMethodStr != null && !paymentMethodStr.isEmpty()) {
            sale.setPaymentMethod(PaymentMethod.valueOf(paymentMethodStr.toUpperCase()));
        } else {
            throw new IllegalArgumentException("Payment method is required");
        }

        // CALCULATE TOTAL AMOUNT WITH DISCOUNT AS PERCENTAGE
        if (product != null) {
                BigDecimal unitPrice = product.getSellingPrice();
                    BigDecimal quantityBD = new BigDecimal(sale.getQuantity());
                    BigDecimal subQuantityBD = new BigDecimal(sale.getSubQuantity() != null ? sale.getSubQuantity() : 0);

                    // Per-subunit price = main unit price divided by number of subunits per unit (when provided)
            Integer subQtyPerUnit = product.getSubQuantity();
            BigDecimal subUnitsPerUnit = (subQtyPerUnit != null && subQtyPerUnit > 0)
                    ? BigDecimal.valueOf(subQtyPerUnit)
                    : BigDecimal.ZERO;
                    BigDecimal subUnitPrice = subUnitsPerUnit.compareTo(BigDecimal.ZERO) > 0
                        ? unitPrice.divide(subUnitsPerUnit, 4, java.math.RoundingMode.HALF_UP)
                        : unitPrice;

                    BigDecimal subtotal = unitPrice.multiply(quantityBD)
                        .add(subUnitPrice.multiply(subQuantityBD));

            // DISCOUNT IS IN PERCENTAGE (0-100)
            String discountParam = request.getParameter("txtDiscount");
            BigDecimal discountPercentage = BigDecimalUtil.parseBigDecimal(discountParam);
            if (discountPercentage == null) {
                discountPercentage = BigDecimal.ZERO;
            }

            // VALIDATE DISCOUNT PERCENTAGE
            if (discountPercentage.compareTo(BigDecimal.ZERO) < 0 ||
                    discountPercentage.compareTo(new BigDecimal("100")) > 0) {
                throw new IllegalArgumentException("Discount must be between 0 and 100");
            }

            // CALCULATE DISCOUNT AMOUNT FROM PERCENTAGE
            BigDecimal discountAmount = subtotal.multiply(discountPercentage)
                    .divide(new BigDecimal("100"), 2, java.math.RoundingMode.HALF_UP);
            sale.setDiscount(discountAmount);

            // CALCULATE FINAL TOTAL AMOUNT
            BigDecimal total = subtotal.subtract(discountAmount);
            sale.setTotalAmount(total.setScale(2, java.math.RoundingMode.HALF_UP));
        }

        // SET AMOUNT GIVEN BY CUSTOMER
        BigDecimal amountGiven = BigDecimalUtil.parseBigDecimal(request.getParameter("txtAmountGivenByCustomer"));
        sale.setAmountGivenByCustomer(amountGiven == null ? BigDecimal.ZERO : amountGiven);

        // SET STATUS MANUALLY FROM USER SELECTION
        String statusParam = request.getParameter("selStatus");
        if (statusParam != null && !statusParam.isEmpty()) {
            sale.setStatus(SaleStatus.valueOf(statusParam.toLowerCase()));
        } else {
            throw new IllegalArgumentException("Payment status is required");
        }
    }

    private void forwardToSaleJsp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        request.setAttribute("productList", productDAO.getProductsByUserId(userId));
        request.setAttribute("distributorList", distributorDAO.getAllDistributor(userId));
        request.setAttribute("customerList", customerDAO.getCustomersByUserId(userId));

        // LOAD SALES WITH PAGINATION FOR DISPLAY
        int page = 1;
        int recordsPerPage = 10;
        List<Sale> saleList = saleDAO.getSalesByUserId(userId, page, recordsPerPage);
        int totalRecords = saleDAO.getTotalSalesByUserId(userId);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        request.setAttribute("saleList", saleList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("noOfPages", totalPages);

        RequestDispatcher dispatcher = request.getRequestDispatcher("sale.jsp");
        dispatcher.forward(request, response);
    }
}
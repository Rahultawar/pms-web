package com.inventory.servlet;

import com.inventory.dao.CustomerDAO;
import com.inventory.models.Customer;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/CustomerServlet")
public class CustomerServlet extends HttpServlet {
    CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Customer customer = new Customer();
        String actionType = request.getParameter("actionType");

        if (actionType == null || actionType.isEmpty()) {
            actionType = "add";
        }

        if (actionType.equalsIgnoreCase("add")) {
            // ADD CUSTOMER
            String customerName = request.getParameter("txtCustomerName");
            String contactNumber = request.getParameter("txtContactNumber");
            String userId = request.getParameter("txtUserId");

            try {
                customer.setCustomerName(customerName);
                customer.setContactNumber(contactNumber);
                customer.setUserId(Integer.parseInt(userId));

                // ADD CUSTOMER METHOD FROM CUSTOMER DAO
                customerDAO.addCustomer(customer);

                // REDIRECT AFTER SUCCESS
                response.sendRedirect("CustomerServlet?status=success");
                return;

            } catch (Exception e) {
                e.printStackTrace();
                String errorMessage = getCustomErrorMessage(e);
                request.setAttribute("errorMessage", errorMessage);
                request.setAttribute("customerDetails", customer); // KEEP FORM DATA FOR ADDING
                request.setAttribute("actionTypeValue", "add");
                // LOAD REQUIRED ATTRIBUTES FOR JSP
                loadAttributesForJSP(request, null, null);
                RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
                dispatcher.forward(request, response);
            }
        } else {
            // EDIT CUSTOMER
            int custId = Integer.parseInt(request.getParameter("customerId"));

            String customerName = request.getParameter("txtCustomerName");
            String contactNumber = request.getParameter("txtContactNumber");
            String userId = request.getParameter("txtUserId");

            try {
                customer.setCustomerId(custId);
                customer.setCustomerName(customerName);
                customer.setContactNumber(contactNumber);
                customer.setUserId(Integer.parseInt(userId));

                // UPDATE CUSTOMER METHOD FROM CUSTOMER DAO
                customerDAO.updateCustomer(customer);

                // REDIRECT AFTER SUCCESS
                response.sendRedirect("CustomerServlet?status=success");

            } catch (Exception e) {
                e.printStackTrace();
                String errorMessage = getCustomErrorMessage(e);
                request.setAttribute("errorMessage", errorMessage);
                request.setAttribute("customerDetails", customer); // KEEP FORM DATA FOR EDITING
                // LOAD REQUIRED ATTRIBUTES FOR JSP
                loadAttributesForJSP(request, null, null);
                RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
                dispatcher.forward(request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET USERID FROM SESSION
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String idParam = request.getParameter("id");
        String deleteIdParam = request.getParameter("deleteId");

        // IF EDITING A CUSTOMER
        if (idParam != null && !idParam.isEmpty()) {
            int custId = Integer.parseInt(idParam);
            Customer customer = customerDAO.getCustomerById(custId, userId);
            request.setAttribute("customerDetails", customer);
        }

        // IF DELETING A CUSTOMER
        if (deleteIdParam != null && !deleteIdParam.isEmpty()) {
            int deleteId = Integer.parseInt(deleteIdParam);
            customerDAO.deleteCustomer(deleteId, userId);
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
        List<Customer> customerList = customerDAO.getCustomersPaginated((page - 1) * recordsPerPage, recordsPerPage, userId);
        int totalRecords = customerDAO.countCustomers(userId);
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

        request.setAttribute("customerList", customerList);
        request.setAttribute("noOfPages", totalPages);
        request.setAttribute("currentPage", page);

        RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
        dispatcher.forward(request, response);
    }

    private void loadAttributesForJSP(HttpServletRequest request, String pageParam, String deleteIdParam) {
        // GET USERID FROM SESSION
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) return; // THOUGH WE ALREADY CHECK IN DOGET

        // PAGINATION LOGIC - DEFAULT TO PAGE 1 IF NOT PROVIDED
        int page = 1;
        int recordsPerPage = 5;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        List<Customer> customerList = customerDAO.getCustomersPaginated((page - 1) * recordsPerPage, recordsPerPage, userId);
        int totalRecords = customerDAO.countCustomers(userId);
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

        // DELETE IF REQUESTED
        if (deleteIdParam != null && !deleteIdParam.isEmpty()) {
            try {
                int deleteId = Integer.parseInt(deleteIdParam);
                customerDAO.deleteCustomer(deleteId, userId);
            } catch (NumberFormatException e) {
                // IGNORE INVALID DELETEID
            }
        }

        request.setAttribute("customerList", customerList);
        request.setAttribute("noOfPages", totalPages);
        request.setAttribute("currentPage", page);
    }

    private String getCustomErrorMessage(Exception e) {
        String message = e.getMessage();
        if (message == null) message = "";
        message = message.toLowerCase();

        if (message.contains("duplicate entry")) {
            return "Customer already exists. Please check customer name or contact number.";
        } else if (message.contains("foreign key constraint") || message.contains("cannot add or update")) {
            return "Invalid data provided.";
        } else {
            return "Failed to save customer. Please check your data and try again.";
        }
    }
}

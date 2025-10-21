package com.inventory.servlet;

import com.inventory.dao.DistributorDAO;
import com.inventory.models.Distributor;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

@WebServlet("/DistributorServlet")
public class DistributorServlet extends HttpServlet {
    DistributorDAO distributorDAO = new DistributorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String actionType = request.getParameter("actionType");
        Distributor distributor = new Distributor();

        if ("add".equalsIgnoreCase(actionType)) {
            String distributorName = request.getParameter("txtDistributorName");
            String contactPerson = request.getParameter("txtContactPerson");
            String contactNumber = request.getParameter("txtContactNumber");
            String email = request.getParameter("txtEmail");
            String address = request.getParameter("txtAddress");
            String city = request.getParameter("txtCity");
            String state = request.getParameter("txtState");
            String pinCode = request.getParameter("txtPinCode");

            // Field validation
            if (distributorName.isEmpty() || contactNumber.isEmpty() || address.isEmpty()) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("distributor.jsp");
                request.setAttribute("emptyField", "Required fields can't be empty.");
                dispatcher.forward(request, response);
                return;
            }

            try {
                // Setting data
                distributor.setDistributorName(distributorName);
                distributor.setContactPerson(contactPerson != null && !contactPerson.isEmpty() ? contactPerson : null);
                distributor.setContactNumber(contactNumber);
                distributor.setAddress(address);
                distributor.setEmail(email != null && !email.isEmpty() ? email : null);
                distributor.setCity(city != null && !city.isEmpty() ? city : null);
                distributor.setState(state != null && !state.isEmpty() ? state : null);
                distributor.setPincode(pinCode != null && !pinCode.isEmpty() ? pinCode : null);
                distributor.setCreatedAt(new Timestamp(new Date().getTime()));

                // Save distributor
                distributorDAO.addDistributor(distributor);

                // Redirect or forward after success
                response.sendRedirect("DistributorServlet?status=success");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Something went wrong: " + e.getMessage());
                RequestDispatcher dispatcher = request.getRequestDispatcher("distributor.jsp");
                dispatcher.forward(request, response);
            }
        } else {
            int distributorId = Integer.parseInt(request.getParameter("distributorId"));

            String distributorName = request.getParameter("txtDistributorName");
            String contactPerson = request.getParameter("txtContactPerson");
            String contactNumber = request.getParameter("txtContactNumber");
            String email = request.getParameter("txtEmail");
            String address = request.getParameter("txtAddress");
            String city = request.getParameter("txtCity");
            String state = request.getParameter("txtState");
            String pinCode = request.getParameter("txtPinCode");

            // Field validation
            if (distributorName.isEmpty() || contactNumber.isEmpty() || address.isEmpty()) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("distributor.jsp");
                request.setAttribute("emptyField", "Required fields can't be empty.");
                dispatcher.forward(request, response);
                return;
            }

            try {
                // Setting data
                distributor.setDistributorId(distributorId);
                distributor.setDistributorName(distributorName);
                distributor.setContactPerson(contactPerson != null && !contactPerson.isEmpty() ? contactPerson : null);
                distributor.setContactNumber(contactNumber);
                distributor.setAddress(address);
                distributor.setEmail(email != null && !email.isEmpty() ? email : null);
                distributor.setCity(city != null && !city.isEmpty() ? city : null);
                distributor.setState(state != null && !state.isEmpty() ? state : null);
                distributor.setPincode(pinCode != null && !pinCode.isEmpty() ? pinCode : null);

                // Save distributor
                distributorDAO.updateDistributor(distributor);

                // Redirect or forward after success
                response.sendRedirect("DistributorServlet?status=success");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Something went wrong: " + e.getMessage());
                RequestDispatcher dispatcher = request.getRequestDispatcher("distributor.jsp");
                dispatcher.forward(request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("editId");
        String deleteIdParam = request.getParameter("deleteId");

        // If editing a product
        if (idParam != null && !idParam.isEmpty()) {
            int distId = Integer.parseInt(idParam);
            Distributor distributor = distributorDAO.getDistributorById(distId);
            request.setAttribute("distributorDetails", distributor);
        }

        // If deleting a product
        if (deleteIdParam != null && !deleteIdParam.isEmpty()) {
            int deleteId = Integer.parseInt(deleteIdParam);
            distributorDAO.deleteDistributor(deleteId);
        }

        //PAGINATION LOGIC
        int recordsPerPage = 5;
        int page = 1;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Distributor> distributorList = distributorDAO.getDistributorsPaginated((page - 1) * recordsPerPage, recordsPerPage);
        int totalRecords = distributorDAO.countDistributor();
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

        request.setAttribute("distributorList", distributorList);
        request.setAttribute("noOfPages", totalPages);
        request.setAttribute("currentPage", page);

        RequestDispatcher dispatcher = request.getRequestDispatcher("distributor.jsp");
        dispatcher.forward(request, response);
    }
}

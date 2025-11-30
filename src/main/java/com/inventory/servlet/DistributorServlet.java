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
import java.util.List;

@WebServlet("/DistributorServlet")
public class DistributorServlet extends HttpServlet {
	DistributorDAO distributorDAO = new DistributorDAO();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Get userId from session
		Integer userId = (Integer) request.getSession().getAttribute("userId");
		if (userId == null) {
			response.sendRedirect("index.jsp");
			return;
		}

		Distributor distributor = new Distributor();
		String actionType = request.getParameter("actionType");

		if (actionType == null || actionType.isEmpty()) {
			actionType = "add";
		}

		if (actionType.equalsIgnoreCase("add")) {
			// ADDING FIELDS IN DISTRIBUTOR
			String distributorName = request.getParameter("txtDistributorName");
			String contactPerson = request.getParameter("txtContactPerson");
			String phone = request.getParameter("txtPhone");
			String email = request.getParameter("txtEmail");
			String address = request.getParameter("txtAddress");
			String city = request.getParameter("txtCity");
			String state = request.getParameter("txtState");
			String pinCode = request.getParameter("txtPinCode");

			try {

				// REQUIRED FIELD VALIDATION
				if (distributorName == null || distributorName.trim().isEmpty() || phone == null
						|| phone.trim().isEmpty() || address == null || address.trim().isEmpty()) {

					request.setAttribute("error-message", "Please fill all required fields.");
					request.getRequestDispatcher("distributor.jsp").forward(request, response);
					return;
				}

				// PATTERN VALIDATION
				boolean validDistributorName = distributorName.matches("^[A-Za-z0-9 ]{1,50}$");
				boolean validContactPerson = contactPerson == null || contactPerson.matches("^[A-Za-z ]{0,50}$");
				boolean validPhone = phone.matches("^[0-9]{10}$");
				boolean validEmail = email == null || email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
				boolean validAddress = address.matches("^[A-Za-z0-9 ]{1,50}$");
				boolean validCity = city == null || city.matches("^[A-Za-z ]{0,30}$");
				boolean validState = state == null || state.matches("^[A-Za-z ]{0,30}$");
				boolean validPinCode = pinCode == null || pinCode.matches("^[0-9]{6}$");

				if (!validDistributorName || !validContactPerson || !validPhone || !validEmail || !validAddress
						|| !validCity || !validState || !validPinCode) {

					request.setAttribute("error-message", "Please check your input fields.");
					request.getRequestDispatcher("distributor.jsp").forward(request, response);
					return;
				}

				distributor.setDistributorName(distributorName);
				distributor.setContactPerson(contactPerson);
				distributor.setPhone(phone);
				distributor.setEmail(email);
				distributor.setAddress(address);
				distributor.setCity(city);
				distributor.setState(state);
				distributor.setPinCode(pinCode);
				distributor.setUserId(userId);

				// ADD DISTRIBUTOR METHOD FROM DISTRIBUTOR DAO
				distributorDAO.addDistributor(distributor);

				// REDIRECT AFTER SUCCESS
				response.sendRedirect("DistributorServlet?status=success");
				return;


			} catch (Exception e) {
				e.printStackTrace();
				request.setAttribute("errorMessage", "Something went wrong: " + e.getMessage());
				RequestDispatcher dispatcher = request.getRequestDispatcher("distributor.jsp");
				dispatcher.forward(request, response);
			}
		} else {

			// EDIT DISTRIBUTOR
			int distributorId = Integer.parseInt(request.getParameter("distributorId"));

			String distributorName = request.getParameter("txtDistributorName");
			String contactPerson = request.getParameter("txtContactPerson");
			String phone = request.getParameter("txtPhone");
			String email = request.getParameter("txtEmail");
			String address = request.getParameter("txtAddress");
			String city = request.getParameter("txtCity");
			String state = request.getParameter("txtState");
			String pinCode = request.getParameter("txtPinCode");

			try {
				distributor.setDistributorId(distributorId);
				distributor.setDistributorName(distributorName);
				distributor.setContactPerson(contactPerson);
				distributor.setPhone(phone);
				distributor.setEmail(email);
				distributor.setAddress(address);
				distributor.setCity(city);
				distributor.setState(state);
				distributor.setPinCode(pinCode);
				distributor.setUserId(userId);

				// UPDATE DISTRIBUTOR METHOD FROM DISTRIBUTOR DAO
				distributorDAO.updateDistributor(distributor);

				// REDIRECT AFTER SUCCESS
				response.sendRedirect("DistributorServlet?status=success");
				return;

			} catch (Exception e) {
				e.printStackTrace();
				request.setAttribute("errorMessage", "Something went wrong: " + e.getMessage());
				RequestDispatcher dispatcher = request.getRequestDispatcher("distributor.jsp");
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

		String idParam = request.getParameter("editId");
		String deleteIdParam = request.getParameter("deleteId");

		// IF EDITING A DISTRIBUTOR
		if (idParam != null && !idParam.isEmpty()) {
			int distId = Integer.parseInt(idParam);
			Distributor distributor = distributorDAO.getDistributorById(distId, userId);
			request.setAttribute("distributorDetails", distributor);
		}
		
		if (request.getParameter("status") != null && request.getParameter("status").equals("success")) {
		    request.setAttribute("success-message", "Distributor added successfully!");
		}

		// IF DELETING A DISTRIBUTOR
		if (deleteIdParam != null && !deleteIdParam.isEmpty()) {
			int deleteId = Integer.parseInt(deleteIdParam);
			distributorDAO.deleteDistributor(deleteId, userId);
		}

		// PAGINATION LOGIC
		int recordsPerPage = 5;
		int page = 1;
		if (request.getParameter("page") != null) {
			try {
				page = Integer.parseInt(request.getParameter("page"));
			} catch (NumberFormatException e) {
				page = 1;
			}
		}

		List<Distributor> distributorList = distributorDAO.getDistributorsPaginated((page - 1) * recordsPerPage,
				recordsPerPage, userId);
		int totalRecords = distributorDAO.countDistributor(userId);
		int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

		request.setAttribute("distributorList", distributorList);
		request.setAttribute("noOfPages", totalPages);
		request.setAttribute("currentPage", page);

		RequestDispatcher dispatcher = request.getRequestDispatcher("distributor.jsp");
		dispatcher.forward(request, response);
	}
}

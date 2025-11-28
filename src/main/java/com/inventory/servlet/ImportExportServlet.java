
package com.inventory.servlet;
import com.inventory.dao.DistributorDAO;
import com.inventory.dao.ProductDAO;
import com.inventory.models.Distributor;
import com.inventory.models.Product;
import com.inventory.utils.BigDecimalUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ImportExportServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1MB
    maxFileSize = 1024 * 1024 * 10,     // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class ImportExportServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private DistributorDAO distributorDAO = new DistributorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get userId from session
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("downloadTemplate".equals(action)) {
            String type = request.getParameter("type");
            if ("products".equals(type)) {
                downloadProductTemplate(response, userId);
            } else if ("distributors".equals(type)) {
                downloadDistributorTemplate(response, userId);
            }
        } else {
            RequestDispatcher dispatcher = request.getRequestDispatcher("import-export.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get userId from session
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String actionType = request.getParameter("actionType");

        if ("upload".equals(actionType)) {
            String importType = request.getParameter("importType");
            Part filePart = request.getPart("csvFile");

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();

                if (!fileName.toLowerCase().endsWith(".csv")) {
                    request.setAttribute("errorMessage", "Only CSV files are allowed.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("import-export.jsp");
                    dispatcher.forward(request, response);
                    return;
                }

                try {
                    String result;
                    if ("products".equals(importType)) {
                        result = importProducts(filePart.getInputStream(), userId);
                    } else if ("distributors".equals(importType)) {
                        result = importDistributors(filePart.getInputStream(), userId);
                    } else {
                        result = "Invalid import type.";
                    }

                    // Check if there were any successful imports
                    int successCount = 0;
                    if ("products".equals(importType) || "distributors".equals(importType)) {
                        // Extract success count from result message
                        try {
                            String countStr = result.split(" ")[0];
                            successCount = Integer.parseInt(countStr);
                        } catch (Exception e) {
                            successCount = 0;
                        }
                    }

                    if (successCount > 0) {
                        request.setAttribute("successMessage", result);
                    } else {
                        request.setAttribute("errorMessage", result);
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("errorMessage", "Error processing file: " + e.getMessage());
                }
            } else {
                request.setAttribute("errorMessage", "Please select a file to upload.");
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("import-export.jsp");
        dispatcher.forward(request, response);
    }

    private void downloadProductTemplate(HttpServletResponse response, int userId) throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"products_template.csv\"");

        PrintWriter writer = response.getWriter();
        writer.println("productName,category,manufacturer,batchNumber,strength,location,distributorId,manufacturingDate,expiryDate,quantity,subQuantity,reorderLevel,purchasingPrice,sellingPrice,unit");

        // Add multiple sample rows with clear examples
        writer.println("Paracetamol 500mg,Analgesic,ABC Pharmaceuticals,BATCH2025001,500mg,Rack A1,ABC Pharma Distributors,2025-01-15,2027-01-15,150,,20,25.50,35.75,strip");
        writer.println("Amoxicillin 250mg,Antibiotic,XYZ Labs,BATCH2025002,250mg,Rack B2,HealthCare Supplies,2025-02-01,2026-02-01,75,5,15,12.25,18.99,bottle");
        writer.println("Ibuprofen 200mg,Pain Relief,CareMed Corp,BATCH2025003,200mg,Rack C3,Medical Distributors Inc,2025-03-10,2027-03-10,200,20,25,8.75,12.50,strip");

        writer.flush();
    }

    private void downloadDistributorTemplate(HttpServletResponse response, int userId) throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"distributors_template.csv\"");

        PrintWriter writer = response.getWriter();
        writer.println("distributorName,contactPerson,email,phone,address,city,state,pinCode");

        // Add multiple sample rows with clear examples
        writer.println("ABC Pharma Distributors,Sarah Johnson,sarah@abcpharma.com,9876543210,\"456 Business Park, Sector 5\",Mumbai,Maharashtra,400001");
        writer.println("HealthCare Supplies,Mike Chen,mike@healthcaresupplies.com,8765432109,\"789 Medical Plaza, Block A\",Delhi,Delhi,110001");
        writer.println("Medical Distributors Inc,Emma Wilson,emma@medicadist.com,7654321098,\"321 Pharma Street, Suite 100\",Bangalore,Karnataka,560001");

        writer.flush();
    }

    private String importProducts(java.io.InputStream inputStream, int userId) throws IOException {
        List<String> errors = new ArrayList<>();
        int successCount = 0;

        try (java.util.Scanner scanner = new java.util.Scanner(inputStream)) {
            boolean isFirstLine = true;

            while (scanner.hasNextLine()) {
                String line = scanner.nextLine().trim();
                if (line.isEmpty()) continue;

                if (isFirstLine) {
                    isFirstLine = false;
                    if (line.startsWith("productName")) continue; // Skip header
                }

                String[] fields = parseCSVLine(line);
                if (fields.length < 15) {
                    errors.add("Invalid row format: " + line);
                    continue;
                }

                try {
                    Product product = new Product();
                    product.setProductName(fields[0].trim());
                    product.setCategory(fields[1].trim());
                    product.setManufacturer(fields[2].trim());
                    product.setBatchNumber(fields[3].trim());
                    product.setStrength(fields[4].trim());
                    product.setLocation(fields[5].trim());

                    // For distributorId, we might need to handle by name instead of ID
                    // For simplicity, assume ID is provided in CSV
                    try {
                        product.setDistributorId(Integer.parseInt(fields[6].trim()));
                    } catch (NumberFormatException e) {
                        // Try to find distributor by name
                        List<Distributor> distributors = distributorDAO.getAllDistributor(userId);
                        boolean found = false;
                        for (Distributor d : distributors) {
                            if (d.getDistributorName().equals(fields[6].trim())) {
                                product.setDistributorId(d.getDistributorId());
                                found = true;
                                break;
                            }
                        }
                        if (!found) {
                            errors.add("Distributor not found: " + fields[6]);
                            continue;
                        }
                    }

                    product.setUserId(userId);
                    product.setManufacturingDate(java.sql.Date.valueOf(parseDate(fields[7].trim())));
                    product.setExpiryDate(java.sql.Date.valueOf(parseDate(fields[8].trim())));
                    product.setQuantity(Integer.parseInt(fields[9].trim()));

                    if (!fields[10].trim().isEmpty()) {
                        product.setSubQuantity(Integer.parseInt(fields[10].trim()));
                    }

                    product.setReorderLevel(Integer.parseInt(fields[11].trim()));
                    product.setPurchasingPrice(BigDecimalUtil.parseBigDecimal(fields[12].trim()));
                    product.setSellingPrice(BigDecimalUtil.parseBigDecimal(fields[13].trim()));
                    product.setUnit(fields[14].trim());

                    productDAO.addProduct(product);
                    successCount++;

                } catch (Exception e) {
                    errors.add(generateUserFriendlyMessage(e, line, "product"));
                }
            }
        }

        String result = successCount + " products imported successfully.";
        if (!errors.isEmpty()) {
            result += " Errors: " + String.join("; ", errors);
        }
        return result;
    }

    private String importDistributors(java.io.InputStream inputStream, int userId) throws IOException {
        List<String> errors = new ArrayList<>();
        int successCount = 0;

        try (java.util.Scanner scanner = new java.util.Scanner(inputStream)) {
            boolean isFirstLine = true;

            while (scanner.hasNextLine()) {
                String line = scanner.nextLine().trim();
                if (line.isEmpty()) continue;

                if (isFirstLine) {
                    isFirstLine = false;
                    if (line.startsWith("distributorName")) continue; // Skip header
                }

                String[] fields = parseCSVLine(line);
                if (fields.length < 8) {
                    errors.add("Invalid row format: " + line);
                    continue;
                }

                try {
                    Distributor distributor = new Distributor();
                    distributor.setDistributorName(fields[0].trim());
                    distributor.setContactPerson(fields[1].trim());
                    distributor.setEmail(fields[2].trim());
                    distributor.setPhone(fields[3].trim());
                    distributor.setAddress(fields[4].trim());
                    distributor.setCity(fields[5].trim());
                    distributor.setState(fields[6].trim());
                    distributor.setPinCode(fields[7].trim());
                    distributor.setUserId(userId);

                    distributorDAO.addDistributor(distributor);
                    successCount++;

                } catch (Exception e) {
                    errors.add(generateUserFriendlyMessage(e, line, "distributor"));
                }
            }
        }

        String result = successCount + " distributors imported successfully.";
        if (!errors.isEmpty()) {
            result += " Errors: " + String.join("; ", errors);
        }
        return result;
    }

    private String[] parseCSVLine(String line) {
        // Simple CSV parsing - handles quoted fields
        List<String> fields = new ArrayList<>();
        boolean inQuotes = false;
        StringBuilder currentField = new StringBuilder();

        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == '"') {
                inQuotes = !inQuotes;
            } else if (c == ',' && !inQuotes) {
                fields.add(currentField.toString());
                currentField = new StringBuilder();
            } else {
                currentField.append(c);
            }
        }
        fields.add(currentField.toString());

        return fields.toArray(new String[0]);
    }

    private String parseDate(String dateStr) throws Exception {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Date cannot be empty");
        }

        dateStr = dateStr.trim();
        SimpleDateFormat[] formats = {
            new SimpleDateFormat("yyyy-MM-dd"),  // 2025-01-01 (standard)
            new SimpleDateFormat("MM/dd/yyyy"),  // 01/01/2025
            new SimpleDateFormat("dd/MM/yyyy"),  // 01/01/2025
            new SimpleDateFormat("MM-dd-yyyy"),  // 01-01-2025 (from error)
            new SimpleDateFormat("dd-MM-yyyy"),  // 01-01-2025
            new SimpleDateFormat("yyyy/MM/dd"),  // 2025/01/01
            new SimpleDateFormat("yyyy-dd-MM")   // 2025-01-01
        };

        for (SimpleDateFormat format : formats) {
            try {
                format.setLenient(false);
                java.util.Date date = format.parse(dateStr);
                // Convert back to standard format for Date.valueOf
                SimpleDateFormat standard = new SimpleDateFormat("yyyy-MM-dd");
                return standard.format(date);
            } catch (ParseException e) {
                // Try next format
            }
        }

        throw new IllegalArgumentException("Invalid date format: " + dateStr + ". Supported formats: YYYY-MM-DD, MM/DD/YYYY, DD/MM/YYYY, MM-DD-YYYY, etc.");
    }

    private String generateUserFriendlyMessage(Exception e, String line, String type) {
        String message = e.getMessage();
        if (message == null) {
            message = e.toString();
        }

        // Handle specific exception types
        if (message.contains("Duplicate entry") && message.contains("for key")) {
            // Extract the field and value that caused the duplicate
            try {
                // Message format: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry 'Gamma Enterprise' for key 'ux_distributor_name'
                int startQuote = message.indexOf("'") + 1;
                int endQuote = message.indexOf("'", startQuote);
                String duplicateValue = message.substring(startQuote, endQuote);

                int keyStart = message.indexOf("for key '") + 9;
                int keyEnd = message.indexOf("'", keyStart);
                String keyName = message.substring(keyStart, keyEnd);

                // Map key names to readable field names
                String fieldName = "unknown field";
                if (keyName.contains("name")) {
                    if (type.equals("distributor")) {
                        fieldName = "distributor name";
                    } else {
                        fieldName = "product name";
                    }
                } else if (keyName.contains("batch")) {
                    fieldName = "batch number";
                } else if (keyName.contains("email")) {
                    fieldName = "email";
                } else if (keyName.contains("phone")) {
                    fieldName = "phone";
                }

                return "Duplicate " + fieldName + " '" + duplicateValue + "' already exists for this " + type;
            } catch (Exception ex) {
                return "Duplicate data found in row: " + line + ". Please check for existing records.";
            }
        } else if (message.contains("Invalid date")) {
            return "Invalid date format in row: " + line + ". Please use formats like YYYY-MM-DD.";
        } else if (message.contains("NumberFormatException") || message.contains("cannot be converted")) {
            return "Invalid number format in row: " + line + ". Please check numeric fields (quantity, prices, etc.).";
        } else if (message.contains("NullPointerException") || message.contains("null")) {
            return "Missing required data in row: " + line + ". All required fields must be filled.";
        } else if (message.contains("SQLIntegrityConstraintViolationException") || message.contains("constraint")) {
            return "Data constraint violation in row: " + line + ". Please check that all required fields are correct.";
        } else if (e instanceof NumberFormatException) {
            return "Invalid number format in row: " + line;
        } else if (e instanceof IllegalArgumentException) {
            return "Invalid data in row: " + line + " - " + message;
        } else {
            // Generic fallback
            return "Error processing row '" + line + "': " + message;
        }
    }
}

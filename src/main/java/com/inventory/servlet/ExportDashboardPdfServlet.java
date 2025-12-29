package com.inventory.servlet;

import com.inventory.dao.ProductDAO;
import com.inventory.dao.DistributorDAO;
import com.inventory.dao.SaleDAO;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

@WebServlet("/ExportDashboardPdfServlet")
public class ExportDashboardPdfServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String exportType = request.getParameter("type");
        if (exportType == null || exportType.isEmpty()) {
            exportType = "full";
        }

        try {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                response.sendRedirect("index.jsp");
                return;
            }

            ProductDAO productDAO = new ProductDAO();
            DistributorDAO distributorDAO = new DistributorDAO();
            SaleDAO saleDAO = new SaleDAO();

            response.setContentType("application/pdf");
            String fileName = "dashboard_report_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".pdf";
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

            Document document = new Document(PageSize.A4, 50, 50, 50, 50);
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Define fonts
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.DARK_GRAY);
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, BaseColor.BLACK);
            Font subHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.DARK_GRAY);
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 11, BaseColor.BLACK);
            Font smallFont = FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.GRAY);

            // Title
            Paragraph title = new Paragraph("Dashboard Report", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(10);
            document.add(title);

            // Date
            Paragraph date = new Paragraph("Generated on: " + new SimpleDateFormat("dd MMM yyyy HH:mm:ss").format(new Date()), smallFont);
            date.setAlignment(Element.ALIGN_CENTER);
            date.setSpacingAfter(20);
            document.add(date);

            // Add a line separator
            LineSeparator line = new LineSeparator();
            document.add(new Chunk(line));
            document.add(Chunk.NEWLINE);

            if ("full".equals(exportType) || "summary".equals(exportType)) {
                // Key Metrics Section
                Paragraph metricsHeader = new Paragraph("Key Performance Metrics", headerFont);
                metricsHeader.setSpacingBefore(10);
                metricsHeader.setSpacingAfter(15);
                document.add(metricsHeader);

                double todaySaleAmount = saleDAO.getTodaySalesAmount(userId);
                double monthlySaleAmount = saleDAO.getMonthlySalesAmount(userId);
                double yearlySaleAmount = saleDAO.getYearlySalesAmount(userId);
                double pendingPaymentsAmount = saleDAO.getPendingPaymentsAmount(userId);
                int pendingPaymentsCount = saleDAO.getPendingPaymentsCount(userId);
                int productCount = productDAO.countProduct(userId);
                int distributorCount = distributorDAO.countDistributor(userId);

                PdfPTable metricsTable = new PdfPTable(2);
                metricsTable.setWidthPercentage(100);
                metricsTable.setSpacingAfter(20);
                
                // Table headers
                PdfPCell cell1 = new PdfPCell(new Phrase("Metric", subHeaderFont));
                cell1.setBackgroundColor(new BaseColor(240, 240, 240));
                cell1.setPadding(8);
                metricsTable.addCell(cell1);
                
                PdfPCell cell2 = new PdfPCell(new Phrase("Value", subHeaderFont));
                cell2.setBackgroundColor(new BaseColor(240, 240, 240));
                cell2.setPadding(8);
                metricsTable.addCell(cell2);

                // Add metrics data
                addMetricRow(metricsTable, "Today's Sale", String.format("₹ %.2f", todaySaleAmount), normalFont);
                addMetricRow(metricsTable, "Monthly Sale", String.format("₹ %.2f", monthlySaleAmount), normalFont);
                addMetricRow(metricsTable, "Yearly Sale", String.format("₹ %.2f", yearlySaleAmount), normalFont);
                addMetricRow(metricsTable, "Pending Payments", String.format("₹ %.2f (%d transactions)", pendingPaymentsAmount, pendingPaymentsCount), normalFont);
                addMetricRow(metricsTable, "Total Products", String.valueOf(productCount), normalFont);
                addMetricRow(metricsTable, "Total Distributors", String.valueOf(distributorCount), normalFont);

                document.add(metricsTable);
            }

            if ("full".equals(exportType) || "sales".equals(exportType)) {
                // Sales Trend Section
                String trendType = request.getParameter("trend");
                if (trendType == null || trendType.isEmpty()) {
                    trendType = "day";
                }

                Map<String, Double> salesTrendData;
                String trendLabel;
                switch (trendType.toLowerCase()) {
                    case "month":
                        salesTrendData = saleDAO.getMonthlySalesTrend(userId);
                        trendLabel = "Monthly Sales Trend (Last 12 Months)";
                        break;
                    case "year":
                        salesTrendData = saleDAO.getYearlySalesTrend(userId);
                        trendLabel = "Yearly Sales Trend";
                        break;
                    default:
                        salesTrendData = saleDAO.getDailySalesTrend(userId);
                        trendLabel = "Daily Sales Trend (Last 7 Days)";
                        break;
                }

                Paragraph salesHeader = new Paragraph(trendLabel, headerFont);
                salesHeader.setSpacingBefore(10);
                salesHeader.setSpacingAfter(15);
                document.add(salesHeader);

                if (salesTrendData != null && !salesTrendData.isEmpty()) {
                    PdfPTable salesTable = new PdfPTable(2);
                    salesTable.setWidthPercentage(100);
                    salesTable.setSpacingAfter(20);

                    // Table headers
                    PdfPCell periodCell = new PdfPCell(new Phrase("Period", subHeaderFont));
                    periodCell.setBackgroundColor(new BaseColor(240, 240, 240));
                    periodCell.setPadding(8);
                    salesTable.addCell(periodCell);

                    PdfPCell amountCell = new PdfPCell(new Phrase("Sales Amount", subHeaderFont));
                    amountCell.setBackgroundColor(new BaseColor(240, 240, 240));
                    amountCell.setPadding(8);
                    salesTable.addCell(amountCell);

                    // Add sales data
                    for (Map.Entry<String, Double> entry : salesTrendData.entrySet()) {
                        addMetricRow(salesTable, entry.getKey(), String.format("₹ %.2f", entry.getValue()), normalFont);
                    }

                    document.add(salesTable);
                } else {
                    document.add(new Paragraph("No sales data available for this period.", normalFont));
                    document.add(Chunk.NEWLINE);
                }
            }

            if ("full".equals(exportType) || "categories".equals(exportType)) {
                // Product Categories Section
                Paragraph categoryHeader = new Paragraph("Product Category Distribution", headerFont);
                categoryHeader.setSpacingBefore(10);
                categoryHeader.setSpacingAfter(15);
                document.add(categoryHeader);

                Map<String, Integer> categoryData = productDAO.getProductCategoryDistribution(userId);

                if (categoryData != null && !categoryData.isEmpty()) {
                    int totalProducts = categoryData.values().stream().mapToInt(Integer::intValue).sum();

                    PdfPTable categoryTable = new PdfPTable(3);
                    categoryTable.setWidthPercentage(100);
                    categoryTable.setSpacingAfter(20);
                    categoryTable.setWidths(new float[]{3, 2, 2});

                    // Table headers
                    PdfPCell catCell = new PdfPCell(new Phrase("Category", subHeaderFont));
                    catCell.setBackgroundColor(new BaseColor(240, 240, 240));
                    catCell.setPadding(8);
                    categoryTable.addCell(catCell);

                    PdfPCell countCell = new PdfPCell(new Phrase("Count", subHeaderFont));
                    countCell.setBackgroundColor(new BaseColor(240, 240, 240));
                    countCell.setPadding(8);
                    categoryTable.addCell(countCell);

                    PdfPCell percentCell = new PdfPCell(new Phrase("Percentage", subHeaderFont));
                    percentCell.setBackgroundColor(new BaseColor(240, 240, 240));
                    percentCell.setPadding(8);
                    categoryTable.addCell(percentCell);

                    // Add category data
                    for (Map.Entry<String, Integer> entry : categoryData.entrySet()) {
                        double percentage = totalProducts > 0 ? (entry.getValue() * 100.0 / totalProducts) : 0;
                        
                        PdfPCell nameCell = new PdfPCell(new Phrase(entry.getKey(), normalFont));
                        nameCell.setPadding(6);
                        categoryTable.addCell(nameCell);

                        PdfPCell valCell = new PdfPCell(new Phrase(String.valueOf(entry.getValue()), normalFont));
                        valCell.setPadding(6);
                        valCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        categoryTable.addCell(valCell);

                        PdfPCell pctCell = new PdfPCell(new Phrase(String.format("%.1f%%", percentage), normalFont));
                        pctCell.setPadding(6);
                        pctCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        categoryTable.addCell(pctCell);
                    }

                    document.add(categoryTable);
                } else {
                    document.add(new Paragraph("No product category data available.", normalFont));
                    document.add(Chunk.NEWLINE);
                }
            }

            if ("full".equals(exportType)) {
                // Payment Methods Section
                Paragraph paymentHeader = new Paragraph("Payment Method Distribution", headerFont);
                paymentHeader.setSpacingBefore(10);
                paymentHeader.setSpacingAfter(15);
                document.add(paymentHeader);

                Map<String, Integer> paymentMethodData = saleDAO.getPaymentMethodDistribution(userId);

                if (paymentMethodData != null && !paymentMethodData.isEmpty()) {
                    int totalTransactions = paymentMethodData.values().stream().mapToInt(Integer::intValue).sum();

                    PdfPTable paymentTable = new PdfPTable(3);
                    paymentTable.setWidthPercentage(100);
                    paymentTable.setSpacingAfter(20);
                    paymentTable.setWidths(new float[]{3, 2, 2});

                    // Table headers
                    PdfPCell methodCell = new PdfPCell(new Phrase("Payment Method", subHeaderFont));
                    methodCell.setBackgroundColor(new BaseColor(240, 240, 240));
                    methodCell.setPadding(8);
                    paymentTable.addCell(methodCell);

                    PdfPCell transCell = new PdfPCell(new Phrase("Transactions", subHeaderFont));
                    transCell.setBackgroundColor(new BaseColor(240, 240, 240));
                    transCell.setPadding(8);
                    paymentTable.addCell(transCell);

                    PdfPCell pctCell = new PdfPCell(new Phrase("Percentage", subHeaderFont));
                    pctCell.setBackgroundColor(new BaseColor(240, 240, 240));
                    pctCell.setPadding(8);
                    paymentTable.addCell(pctCell);

                    // Add payment data
                    for (Map.Entry<String, Integer> entry : paymentMethodData.entrySet()) {
                        double percentage = totalTransactions > 0 ? (entry.getValue() * 100.0 / totalTransactions) : 0;
                        
                        PdfPCell nameCell = new PdfPCell(new Phrase(entry.getKey(), normalFont));
                        nameCell.setPadding(6);
                        paymentTable.addCell(nameCell);

                        PdfPCell valCell = new PdfPCell(new Phrase(String.valueOf(entry.getValue()), normalFont));
                        valCell.setPadding(6);
                        valCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        paymentTable.addCell(valCell);

                        PdfPCell percentageCell = new PdfPCell(new Phrase(String.format("%.1f%%", percentage), normalFont));
                        percentageCell.setPadding(6);
                        percentageCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        paymentTable.addCell(percentageCell);
                    }

                    document.add(paymentTable);
                } else {
                    document.add(new Paragraph("No payment method data available.", normalFont));
                }
            }

            // Footer
            document.add(Chunk.NEWLINE);
            document.add(new Chunk(line));
            Paragraph footer = new Paragraph("Mahadev Medical Store - Pharmacy Management System", smallFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setSpacingBefore(10);
            document.add(footer);

            document.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error generating PDF: " + e.getMessage());
        }
    }

    private void addMetricRow(PdfPTable table, String label, String value, Font font) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, font));
        labelCell.setPadding(6);
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setBorderWidthBottom(0.5f);
        labelCell.setBorderColorBottom(BaseColor.LIGHT_GRAY);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(value, font));
        valueCell.setPadding(6);
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setBorderWidthBottom(0.5f);
        valueCell.setBorderColorBottom(BaseColor.LIGHT_GRAY);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(valueCell);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
